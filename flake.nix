{
  description = "Flutter 3.27+";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };
  outputs =
    {
      self,
      nixpkgs,
      flake-utils,
    }:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = import nixpkgs {
          inherit system;
          config = {
            android_sdk.accept_license = true;
            allowUnfree = true;
          };
        };
        buildToolsVersion = "35.0.0";
        androidComposition = pkgs.androidenv.composeAndroidPackages {
          cmdLineToolsVersion = "8.0";
          toolsVersion = "26.1.1";
          buildToolsVersions = [
            buildToolsVersion
            "35.0.0"
            "34.0.0"
            "33.0.2"
            "30.0.3"
          ];
          platformVersions = [
            "36"
            "35"
            "34"
            "33"
            "32"
          ];
          abiVersions = [
            "armeabi-v7a"
            "arm64-v8a"
            "x86_64" # Added x86_64 for emulator
          ];
          # This is the key fix - include system images
          includeSystemImages = true;
          systemImageTypes = [
            "google_apis_playstore"
            "default"
          ];
          includeNDK = true;
          ndkVersions = [ "27.0.12077973" ];
          cmakeVersions = [ "3.22.1" ];
          includeEmulator = true;
        };
        androidSdk = androidComposition.androidsdk;

        # Create emulator with explicit system image reference
        emulator = pkgs.androidenv.emulateApp {
          name = "emulate-MyAndroidApp";
          platformVersion = "33";
          abiVersion = "x86_64";
          systemImageType = "google_apis_playstore";
        };
      in
      {
        devShell =
          with pkgs;
          mkShell rec {
            ANDROID_SDK_ROOT = "${androidSdk}/libexec/android-sdk";
            ANDROID_HOME = "${androidSdk}/libexec/android-sdk";
            GRADLE_OPTS = "-Dorg.gradle.project.android.aapt2FromMavenOverride=${androidSdk}/libexec/android-sdk/build-tools/${buildToolsVersion}/aapt2";
            FLUTTER_ROOT = "${flutter}";
            # Ensure Android SDK paths are properly set
            PATH = "${androidSdk}/libexec/android-sdk/emulator:${androidSdk}/libexec/android-sdk/platform-tools:$PATH";
            # finamp can't find libmpv on its own, even with `nix-shell -p mpv-unwrapped`
            # still requires `cd build/linux/x64/release/bundle/lib/`
            LD_LIBRARY_PATH = "${lib.makeLibraryPath [ pkgs.mpv-unwrapped ]}";
            buildInputs = [
              flutter
              androidSdk
              jdk17
              androidComposition.platform-tools
              cmake
              rustup
              # emulator - temporarily removed to fix build issues
            ];

            shellHook = ''
              echo ""
              echo "🎯 Flutter Android Development Environment"
              echo "=========================================="
              echo ""
              echo "📱 Android SDK: $ANDROID_SDK_ROOT"
              echo "🎯 Flutter: $(flutter --version | head -1)"
              echo ""
              echo "🚀 Quick Start:"
              echo "  1. Run: nix run .#setup-android-emulator"
              echo "  2. Then: flutter emulators --launch finamp_dev_emulator"
              echo "  3. Check: flutter devices"
              echo ""
              echo "💡 The setup-android-emulator script handles everything automatically!"
              echo ""
            '';
          };

        # Automated emulator setup script
        packages.setup-android-emulator = pkgs.writeShellScriptBin "setup-android-emulator" ''
          set -e
          export ANDROID_SDK_ROOT="${androidSdk}/libexec/android-sdk"
          export ANDROID_HOME="${androidSdk}/libexec/android-sdk"

          echo "🚀 Setting up Android emulator for Flutter development..."

          # Find cmdline-tools directory automatically
          CMDLINE_TOOLS_DIR=""
          for dir in "$ANDROID_HOME"/cmdline-tools/*/; do
            if [ -f "$dir/bin/avdmanager" ]; then
              CMDLINE_TOOLS_DIR="$dir"
              break
            fi
          done

          if [ -z "$CMDLINE_TOOLS_DIR" ]; then
            echo "❌ Error: Could not find avdmanager in cmdline-tools"
            echo "Available directories in $ANDROID_HOME/cmdline-tools/:"
            ls -la "$ANDROID_HOME/cmdline-tools/" 2>/dev/null || echo "cmdline-tools directory not found"
            exit 1
          fi

          echo "✅ Found Android command-line tools at: $CMDLINE_TOOLS_DIR"

          # Standard AVD name for consistency
          AVD_NAME="finamp_dev_emulator"

          # Check if AVD already exists and has correct architecture
          if ${androidSdk}/libexec/android-sdk/emulator/emulator -list-avds | grep -q "$AVD_NAME"; then
            echo "📱 AVD '$AVD_NAME' already exists"

            # Check if it's ARM64 (problematic on x86_64)
            AVD_CONFIG="$HOME/.android/avd/$AVD_NAME.avd/config.ini"
            if [ -f "$AVD_CONFIG" ] && grep -q "abi.type=arm64-v8a" "$AVD_CONFIG"; then
              echo "⚠️  Existing AVD uses ARM64 architecture, which won't work on x86_64 systems"
              echo "🗑️  Deleting and recreating with x86_64 architecture..."
              "$CMDLINE_TOOLS_DIR/bin/avdmanager" delete avd -n "$AVD_NAME"
            else
              echo "✅ AVD architecture looks good"
              echo "🚀 You can start the emulator with: flutter emulators --launch $AVD_NAME"
              exit 0
            fi
          fi

          # Create new AVD with x86_64 architecture
          echo "🛠️  Creating new Android Virtual Device: $AVD_NAME"
          echo "📋 Using API level 33 with Google Play Store support"

          SYSTEM_IMAGE="system-images;android-33;google_apis_playstore;x86_64"

          echo "no" | "$CMDLINE_TOOLS_DIR/bin/avdmanager" create avd \
            -n "$AVD_NAME" \
            -k "$SYSTEM_IMAGE" \
            --device "pixel_6" \
            --force || {
            echo "❌ Failed to create AVD. Let's check what's available:"
            echo ""
            echo "Available x86_64 system images:"
            "$CMDLINE_TOOLS_DIR/bin/sdkmanager" --list | grep "system-images.*x86_64" | head -10
            echo ""
            echo "If no system images are shown, the Android SDK might not include them."
            echo "This could be a Nix configuration issue."
            exit 1
          }

          echo ""
          echo "✅ Successfully created Android emulator!"
          echo "🚀 Start it with one of these commands:"
          echo "   flutter emulators --launch $AVD_NAME"
          echo "   flutter emulators"  # to see all available emulators
          echo ""
          echo "💡 The emulator will appear in 'flutter devices' once it's running"
        '';
      }
    );
}
