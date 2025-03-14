// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'theme_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$rawThemeAccentHash() => r'37e9726b26abb76df207e08902e694363b6e1e9c';

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
  late final ThemeRequestFromImage request;

  FutureOr<Color?> build(
    ThemeRequestFromImage request,
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
    ThemeRequestFromImage request,
  ) {
    return RawThemeAccentProvider(
      request,
    );
  }

  @override
  RawThemeAccentProvider getProviderOverride(
    covariant RawThemeAccentProvider provider,
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
  String? get name => r'rawThemeAccentProvider';
}

/// See also [RawThemeAccent].
class RawThemeAccentProvider
    extends AutoDisposeAsyncNotifierProviderImpl<RawThemeAccent, Color?> {
  /// See also [RawThemeAccent].
  RawThemeAccentProvider(
    ThemeRequestFromImage request,
  ) : this._internal(
          () => RawThemeAccent()..request = request,
          from: rawThemeAccentProvider,
          name: r'rawThemeAccentProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$rawThemeAccentHash,
          dependencies: RawThemeAccentFamily._dependencies,
          allTransitiveDependencies:
              RawThemeAccentFamily._allTransitiveDependencies,
          request: request,
        );

  RawThemeAccentProvider._internal(
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
  FutureOr<Color?> runNotifierBuild(
    covariant RawThemeAccent notifier,
  ) {
    return notifier.build(
      request,
    );
  }

  @override
  Override overrideWith(RawThemeAccent Function() create) {
    return ProviderOverride(
      origin: this,
      override: RawThemeAccentProvider._internal(
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
  AutoDisposeAsyncNotifierProviderElement<RawThemeAccent, Color?>
      createElement() {
    return _RawThemeAccentProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is RawThemeAccentProvider && other.request == request;
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
mixin RawThemeAccentRef on AutoDisposeAsyncNotifierProviderRef<Color?> {
  /// The parameter `request` of this provider.
  ThemeRequestFromImage get request;
}

class _RawThemeAccentProviderElement
    extends AutoDisposeAsyncNotifierProviderElement<RawThemeAccent, Color?>
    with RawThemeAccentRef {
  _RawThemeAccentProviderElement(super.provider);

  @override
  ThemeRequestFromImage get request =>
      (origin as RawThemeAccentProvider).request;
}

String _$finampThemeFromImageHash() =>
    r'c73e2c6add7681a3b527a7ea618ec0c22b7f4da9';

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
