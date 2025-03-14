// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'theme_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$finampThemeFromImageHash() =>
    r'edff4d3a49bb77d0a4b282ea16ec6b77433b70c4';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

abstract class _$FinampThemeFromImage
    extends BuildlessAutoDisposeNotifier<ColorScheme> {
  late final ThemeRequestFromImage request;

  ColorScheme build(
    ThemeRequestFromImage request,
  );
}

/// See also [FinampThemeFromImage].
@ProviderFor(FinampThemeFromImage)
const finampThemeFromImageProvider = FinampThemeFromImageFamily();

/// See also [FinampThemeFromImage].
class FinampThemeFromImageFamily extends Family<ColorScheme> {
  /// See also [FinampThemeFromImage].
  const FinampThemeFromImageFamily();

  /// See also [FinampThemeFromImage].
  FinampThemeFromImageProvider call(
    ThemeRequestFromImage request,
  ) {
    return FinampThemeFromImageProvider(
      request,
    );
  }

  @override
  FinampThemeFromImageProvider getProviderOverride(
    covariant FinampThemeFromImageProvider provider,
  ) {
    return call(
      provider.request,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'finampThemeFromImageProvider';
}

/// See also [FinampThemeFromImage].
class FinampThemeFromImageProvider
    extends AutoDisposeNotifierProviderImpl<FinampThemeFromImage, ColorScheme> {
  /// See also [FinampThemeFromImage].
  FinampThemeFromImageProvider(
    ThemeRequestFromImage request,
  ) : this._internal(
          () => FinampThemeFromImage()..request = request,
          from: finampThemeFromImageProvider,
          name: r'finampThemeFromImageProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$finampThemeFromImageHash,
          dependencies: FinampThemeFromImageFamily._dependencies,
          allTransitiveDependencies:
              FinampThemeFromImageFamily._allTransitiveDependencies,
          request: request,
        );

  FinampThemeFromImageProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.request,
  }) : super.internal();

  final ThemeRequestFromImage request;

  @override
  ColorScheme runNotifierBuild(
    covariant FinampThemeFromImage notifier,
  ) {
    return notifier.build(
      request,
    );
  }

  @override
  Override overrideWith(FinampThemeFromImage Function() create) {
    return ProviderOverride(
      origin: this,
      override: FinampThemeFromImageProvider._internal(
        () => create()..request = request,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        request: request,
      ),
    );
  }

  @override
  AutoDisposeNotifierProviderElement<FinampThemeFromImage, ColorScheme>
      createElement() {
    return _FinampThemeFromImageProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is FinampThemeFromImageProvider && other.request == request;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, request.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin FinampThemeFromImageRef on AutoDisposeNotifierProviderRef<ColorScheme> {
  /// The parameter `request` of this provider.
  ThemeRequestFromImage get request;
}

class _FinampThemeFromImageProviderElement
    extends AutoDisposeNotifierProviderElement<FinampThemeFromImage,
        ColorScheme> with FinampThemeFromImageRef {
  _FinampThemeFromImageProviderElement(super.provider);

  @override
  ThemeRequestFromImage get request =>
      (origin as FinampThemeFromImageProvider).request;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
