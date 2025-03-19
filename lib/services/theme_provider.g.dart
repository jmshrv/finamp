// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'theme_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$finampThemeHash() => r'c10deae9cad8aab8370049f2dd3ce0d0c3c232f9';

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

/// See also [finampTheme].
@ProviderFor(finampTheme)
const finampThemeProvider = FinampThemeFamily();

/// See also [finampTheme].
class FinampThemeFamily extends Family<ColorScheme> {
  /// See also [finampTheme].
  const FinampThemeFamily();

  /// See also [finampTheme].
  FinampThemeProvider call(
    ThemeRequest request,
  ) {
    return FinampThemeProvider(
      request,
    );
  }

  @override
  FinampThemeProvider getProviderOverride(
    covariant FinampThemeProvider provider,
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
  String? get name => r'finampThemeProvider';
}

/// See also [finampTheme].
class FinampThemeProvider extends AutoDisposeProvider<ColorScheme> {
  /// See also [finampTheme].
  FinampThemeProvider(
    ThemeRequest request,
  ) : this._internal(
          (ref) => finampTheme(
            ref as FinampThemeRef,
            request,
          ),
          from: finampThemeProvider,
          name: r'finampThemeProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$finampThemeHash,
          dependencies: FinampThemeFamily._dependencies,
          allTransitiveDependencies:
              FinampThemeFamily._allTransitiveDependencies,
          request: request,
        );

  FinampThemeProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.request,
  }) : super.internal();

  final ThemeRequest request;

  @override
  Override overrideWith(
    ColorScheme Function(FinampThemeRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: FinampThemeProvider._internal(
        (ref) => create(ref as FinampThemeRef),
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
  AutoDisposeProviderElement<ColorScheme> createElement() {
    return _FinampThemeProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is FinampThemeProvider && other.request == request;
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
mixin FinampThemeRef on AutoDisposeProviderRef<ColorScheme> {
  /// The parameter `request` of this provider.
  ThemeRequest get request;
}

class _FinampThemeProviderElement
    extends AutoDisposeProviderElement<ColorScheme> with FinampThemeRef {
  _FinampThemeProviderElement(super.provider);

  @override
  ThemeRequest get request => (origin as FinampThemeProvider).request;
}

String _$themeImageHash() => r'90490337e4822fc16cc99ff22c57d4660cf34844';

/// See also [themeImage].
@ProviderFor(themeImage)
const themeImageProvider = ThemeImageFamily();

/// See also [themeImage].
class ThemeImageFamily extends Family<ListenableImage> {
  /// See also [themeImage].
  const ThemeImageFamily();

  /// See also [themeImage].
  ThemeImageProvider call(
    ThemeRequest request,
  ) {
    return ThemeImageProvider(
      request,
    );
  }

  @override
  ThemeImageProvider getProviderOverride(
    covariant ThemeImageProvider provider,
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
  String? get name => r'themeImageProvider';
}

/// See also [themeImage].
class ThemeImageProvider extends AutoDisposeProvider<ListenableImage> {
  /// See also [themeImage].
  ThemeImageProvider(
    ThemeRequest request,
  ) : this._internal(
          (ref) => themeImage(
            ref as ThemeImageRef,
            request,
          ),
          from: themeImageProvider,
          name: r'themeImageProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$themeImageHash,
          dependencies: ThemeImageFamily._dependencies,
          allTransitiveDependencies:
              ThemeImageFamily._allTransitiveDependencies,
          request: request,
        );

  ThemeImageProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.request,
  }) : super.internal();

  final ThemeRequest request;

  @override
  Override overrideWith(
    ListenableImage Function(ThemeImageRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: ThemeImageProvider._internal(
        (ref) => create(ref as ThemeImageRef),
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
  AutoDisposeProviderElement<ListenableImage> createElement() {
    return _ThemeImageProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ThemeImageProvider && other.request == request;
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
mixin ThemeImageRef on AutoDisposeProviderRef<ListenableImage> {
  /// The parameter `request` of this provider.
  ThemeRequest get request;
}

class _ThemeImageProviderElement
    extends AutoDisposeProviderElement<ListenableImage> with ThemeImageRef {
  _ThemeImageProviderElement(super.provider);

  @override
  ThemeRequest get request => (origin as ThemeImageProvider).request;
}

String _$finampThemeFromImageHash() =>
    r'1361d782c9a70578d6b02b36c6ed222288b2776d';

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
