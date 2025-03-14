// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'theme_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$rawThemeAccentHash() => r'36bf7c9840031b741ee8ea1dd1c5032f5e4a3637';

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

abstract class _$RawThemeAccent
    extends BuildlessAutoDisposeAsyncNotifier<Color?> {
  late final ImageProvider<Object>? image;
  late final bool useIsolate;

  FutureOr<Color?> build(
    ImageProvider<Object>? image,
    bool useIsolate,
  );
}

/// See also [RawThemeAccent].
@ProviderFor(RawThemeAccent)
const rawThemeAccentProvider = RawThemeAccentFamily();

/// See also [RawThemeAccent].
class RawThemeAccentFamily extends Family<AsyncValue<Color?>> {
  /// See also [RawThemeAccent].
  const RawThemeAccentFamily();

  /// See also [RawThemeAccent].
  RawThemeAccentProvider call(
    ImageProvider<Object>? image,
    bool useIsolate,
  ) {
    return RawThemeAccentProvider(
      image,
      useIsolate,
    );
  }

  @override
  RawThemeAccentProvider getProviderOverride(
    covariant RawThemeAccentProvider provider,
  ) {
    return call(
      provider.image,
      provider.useIsolate,
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
  String? get name => r'rawThemeAccentProvider';
}

/// See also [RawThemeAccent].
class RawThemeAccentProvider
    extends AutoDisposeAsyncNotifierProviderImpl<RawThemeAccent, Color?> {
  /// See also [RawThemeAccent].
  RawThemeAccentProvider(
    ImageProvider<Object>? image,
    bool useIsolate,
  ) : this._internal(
          () => RawThemeAccent()
            ..image = image
            ..useIsolate = useIsolate,
          from: rawThemeAccentProvider,
          name: r'rawThemeAccentProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$rawThemeAccentHash,
          dependencies: RawThemeAccentFamily._dependencies,
          allTransitiveDependencies:
              RawThemeAccentFamily._allTransitiveDependencies,
          image: image,
          useIsolate: useIsolate,
        );

  RawThemeAccentProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.image,
    required this.useIsolate,
  }) : super.internal();

  final ImageProvider<Object>? image;
  final bool useIsolate;

  @override
  FutureOr<Color?> runNotifierBuild(
    covariant RawThemeAccent notifier,
  ) {
    return notifier.build(
      image,
      useIsolate,
    );
  }

  @override
  Override overrideWith(RawThemeAccent Function() create) {
    return ProviderOverride(
      origin: this,
      override: RawThemeAccentProvider._internal(
        () => create()
          ..image = image
          ..useIsolate = useIsolate,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        image: image,
        useIsolate: useIsolate,
      ),
    );
  }

  @override
  AutoDisposeAsyncNotifierProviderElement<RawThemeAccent, Color?>
      createElement() {
    return _RawThemeAccentProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is RawThemeAccentProvider &&
        other.image == image &&
        other.useIsolate == useIsolate;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, image.hashCode);
    hash = _SystemHash.combine(hash, useIsolate.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin RawThemeAccentRef on AutoDisposeAsyncNotifierProviderRef<Color?> {
  /// The parameter `image` of this provider.
  ImageProvider<Object>? get image;

  /// The parameter `useIsolate` of this provider.
  bool get useIsolate;
}

class _RawThemeAccentProviderElement
    extends AutoDisposeAsyncNotifierProviderElement<RawThemeAccent, Color?>
    with RawThemeAccentRef {
  _RawThemeAccentProviderElement(super.provider);

  @override
  ImageProvider<Object>? get image => (origin as RawThemeAccentProvider).image;
  @override
  bool get useIsolate => (origin as RawThemeAccentProvider).useIsolate;
}

String _$finampThemeFromImageHash() =>
    r'340f80b1174ac199f9ccb2e5b2a8a9bb14c549ed';

abstract class _$FinampThemeFromImage
    extends BuildlessAutoDisposeNotifier<ColorScheme> {
  late final ImageProvider<Object>? image;
  late final bool useIsolate;

  ColorScheme build(
    ImageProvider<Object>? image, {
    bool useIsolate = true,
  });
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
    ImageProvider<Object>? image, {
    bool useIsolate = true,
  }) {
    return FinampThemeFromImageProvider(
      image,
      useIsolate: useIsolate,
    );
  }

  @override
  FinampThemeFromImageProvider getProviderOverride(
    covariant FinampThemeFromImageProvider provider,
  ) {
    return call(
      provider.image,
      useIsolate: provider.useIsolate,
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
    ImageProvider<Object>? image, {
    bool useIsolate = true,
  }) : this._internal(
          () => FinampThemeFromImage()
            ..image = image
            ..useIsolate = useIsolate,
          from: finampThemeFromImageProvider,
          name: r'finampThemeFromImageProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$finampThemeFromImageHash,
          dependencies: FinampThemeFromImageFamily._dependencies,
          allTransitiveDependencies:
              FinampThemeFromImageFamily._allTransitiveDependencies,
          image: image,
          useIsolate: useIsolate,
        );

  FinampThemeFromImageProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.image,
    required this.useIsolate,
  }) : super.internal();

  final ImageProvider<Object>? image;
  final bool useIsolate;

  @override
  ColorScheme runNotifierBuild(
    covariant FinampThemeFromImage notifier,
  ) {
    return notifier.build(
      image,
      useIsolate: useIsolate,
    );
  }

  @override
  Override overrideWith(FinampThemeFromImage Function() create) {
    return ProviderOverride(
      origin: this,
      override: FinampThemeFromImageProvider._internal(
        () => create()
          ..image = image
          ..useIsolate = useIsolate,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        image: image,
        useIsolate: useIsolate,
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
    return other is FinampThemeFromImageProvider &&
        other.image == image &&
        other.useIsolate == useIsolate;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, image.hashCode);
    hash = _SystemHash.combine(hash, useIsolate.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin FinampThemeFromImageRef on AutoDisposeNotifierProviderRef<ColorScheme> {
  /// The parameter `image` of this provider.
  ImageProvider<Object>? get image;

  /// The parameter `useIsolate` of this provider.
  bool get useIsolate;
}

class _FinampThemeFromImageProviderElement
    extends AutoDisposeNotifierProviderElement<FinampThemeFromImage,
        ColorScheme> with FinampThemeFromImageRef {
  _FinampThemeFromImageProviderElement(super.provider);

  @override
  ImageProvider<Object>? get image =>
      (origin as FinampThemeFromImageProvider).image;
  @override
  bool get useIsolate => (origin as FinampThemeFromImageProvider).useIsolate;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
