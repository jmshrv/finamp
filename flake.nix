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
          ];
          includeNDK = true;
          ndkVersions = [ "27.0.12077973" ];
          cmakeVersions = [ "3.22.1" ];
        };
        androidSdk = androidComposition.androidsdk;
      in
      {
        devShell =
          with pkgs;
          mkShell rec {
            ANDROID_SDK_ROOT = "${androidSdk}/libexec/android-sdk";
            ANDROID_HOME = "${androidSdk}/libexec/android-sdk";
            GRADLE_OPTS = "-Dorg.gradle.project.android.aapt2FromMavenOverride=${androidSdk}/libexec/android-sdk/build-tools/${buildToolsVersion}/aapt2";
            buildInputs = [
              flutter
              androidSdk
              jdk17
              androidComposition.platform-tools
              cmake
            ];
          };
      }
    );
}
