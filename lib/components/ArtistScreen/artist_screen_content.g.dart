// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'artist_screen_content.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$getArtistTopTracksHash() =>
    r'8547dc55a092625fe0c9d66b18c8b95e7b0692e3';

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

/// See also [getArtistTopTracks].
@ProviderFor(getArtistTopTracks)
const getArtistTopTracksProvider = GetArtistTopTracksFamily();

/// See also [getArtistTopTracks].
class GetArtistTopTracksFamily extends Family<AsyncValue<List<BaseItemDto>>> {
  /// See also [getArtistTopTracks].
  const GetArtistTopTracksFamily();

  /// See also [getArtistTopTracks].
  GetArtistTopTracksProvider call(
    BaseItemDto parent,
    BaseItemDto? genreFilter,
  ) {
    return GetArtistTopTracksProvider(
      parent,
      genreFilter,
    );
  }

  @override
  GetArtistTopTracksProvider getProviderOverride(
    covariant GetArtistTopTracksProvider provider,
  ) {
    return call(
      provider.parent,
      provider.genreFilter,
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
  String? get name => r'getArtistTopTracksProvider';
}

/// See also [getArtistTopTracks].
class GetArtistTopTracksProvider
    extends AutoDisposeFutureProvider<List<BaseItemDto>> {
  /// See also [getArtistTopTracks].
  GetArtistTopTracksProvider(
    BaseItemDto parent,
    BaseItemDto? genreFilter,
  ) : this._internal(
          (ref) => getArtistTopTracks(
            ref as GetArtistTopTracksRef,
            parent,
            genreFilter,
          ),
          from: getArtistTopTracksProvider,
          name: r'getArtistTopTracksProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$getArtistTopTracksHash,
          dependencies: GetArtistTopTracksFamily._dependencies,
          allTransitiveDependencies:
              GetArtistTopTracksFamily._allTransitiveDependencies,
          parent: parent,
          genreFilter: genreFilter,
        );

  GetArtistTopTracksProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.parent,
    required this.genreFilter,
  }) : super.internal();

  final BaseItemDto parent;
  final BaseItemDto? genreFilter;

  @override
  Override overrideWith(
    FutureOr<List<BaseItemDto>> Function(GetArtistTopTracksRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: GetArtistTopTracksProvider._internal(
        (ref) => create(ref as GetArtistTopTracksRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        parent: parent,
        genreFilter: genreFilter,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<BaseItemDto>> createElement() {
    return _GetArtistTopTracksProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is GetArtistTopTracksProvider &&
        other.parent == parent &&
        other.genreFilter == genreFilter;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, parent.hashCode);
    hash = _SystemHash.combine(hash, genreFilter.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin GetArtistTopTracksRef on AutoDisposeFutureProviderRef<List<BaseItemDto>> {
  /// The parameter `parent` of this provider.
  BaseItemDto get parent;

  /// The parameter `genreFilter` of this provider.
  BaseItemDto? get genreFilter;
}

class _GetArtistTopTracksProviderElement
    extends AutoDisposeFutureProviderElement<List<BaseItemDto>>
    with GetArtistTopTracksRef {
  _GetArtistTopTracksProviderElement(super.provider);

  @override
  BaseItemDto get parent => (origin as GetArtistTopTracksProvider).parent;
  @override
  BaseItemDto? get genreFilter =>
      (origin as GetArtistTopTracksProvider).genreFilter;
}

String _$getArtistAlbumsHash() => r'e0b6c493e54b8b721ef228639d1fa96d180b602e';

/// See also [getArtistAlbums].
@ProviderFor(getArtistAlbums)
const getArtistAlbumsProvider = GetArtistAlbumsFamily();

/// See also [getArtistAlbums].
class GetArtistAlbumsFamily extends Family<AsyncValue<List<BaseItemDto>>> {
  /// See also [getArtistAlbums].
  const GetArtistAlbumsFamily();

  /// See also [getArtistAlbums].
  GetArtistAlbumsProvider call(
    BaseItemDto parent,
    BaseItemDto? genreFilter,
  ) {
    return GetArtistAlbumsProvider(
      parent,
      genreFilter,
    );
  }

  @override
  GetArtistAlbumsProvider getProviderOverride(
    covariant GetArtistAlbumsProvider provider,
  ) {
    return call(
      provider.parent,
      provider.genreFilter,
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
  String? get name => r'getArtistAlbumsProvider';
}

/// See also [getArtistAlbums].
class GetArtistAlbumsProvider
    extends AutoDisposeFutureProvider<List<BaseItemDto>> {
  /// See also [getArtistAlbums].
  GetArtistAlbumsProvider(
    BaseItemDto parent,
    BaseItemDto? genreFilter,
  ) : this._internal(
          (ref) => getArtistAlbums(
            ref as GetArtistAlbumsRef,
            parent,
            genreFilter,
          ),
          from: getArtistAlbumsProvider,
          name: r'getArtistAlbumsProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$getArtistAlbumsHash,
          dependencies: GetArtistAlbumsFamily._dependencies,
          allTransitiveDependencies:
              GetArtistAlbumsFamily._allTransitiveDependencies,
          parent: parent,
          genreFilter: genreFilter,
        );

  GetArtistAlbumsProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.parent,
    required this.genreFilter,
  }) : super.internal();

  final BaseItemDto parent;
  final BaseItemDto? genreFilter;

  @override
  Override overrideWith(
    FutureOr<List<BaseItemDto>> Function(GetArtistAlbumsRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: GetArtistAlbumsProvider._internal(
        (ref) => create(ref as GetArtistAlbumsRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        parent: parent,
        genreFilter: genreFilter,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<BaseItemDto>> createElement() {
    return _GetArtistAlbumsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is GetArtistAlbumsProvider &&
        other.parent == parent &&
        other.genreFilter == genreFilter;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, parent.hashCode);
    hash = _SystemHash.combine(hash, genreFilter.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin GetArtistAlbumsRef on AutoDisposeFutureProviderRef<List<BaseItemDto>> {
  /// The parameter `parent` of this provider.
  BaseItemDto get parent;

  /// The parameter `genreFilter` of this provider.
  BaseItemDto? get genreFilter;
}

class _GetArtistAlbumsProviderElement
    extends AutoDisposeFutureProviderElement<List<BaseItemDto>>
    with GetArtistAlbumsRef {
  _GetArtistAlbumsProviderElement(super.provider);

  @override
  BaseItemDto get parent => (origin as GetArtistAlbumsProvider).parent;
  @override
  BaseItemDto? get genreFilter =>
      (origin as GetArtistAlbumsProvider).genreFilter;
}

String _$getPerformingArtistAlbumsHash() =>
    r'd48e28af7f2bab5138f08cf59f40fc66e73edc8e';

/// See also [getPerformingArtistAlbums].
@ProviderFor(getPerformingArtistAlbums)
const getPerformingArtistAlbumsProvider = GetPerformingArtistAlbumsFamily();

/// See also [getPerformingArtistAlbums].
class GetPerformingArtistAlbumsFamily
    extends Family<AsyncValue<List<BaseItemDto>>> {
  /// See also [getPerformingArtistAlbums].
  const GetPerformingArtistAlbumsFamily();

  /// See also [getPerformingArtistAlbums].
  GetPerformingArtistAlbumsProvider call(
    BaseItemDto parent,
    BaseItemDto? genreFilter,
  ) {
    return GetPerformingArtistAlbumsProvider(
      parent,
      genreFilter,
    );
  }

  @override
  GetPerformingArtistAlbumsProvider getProviderOverride(
    covariant GetPerformingArtistAlbumsProvider provider,
  ) {
    return call(
      provider.parent,
      provider.genreFilter,
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
  String? get name => r'getPerformingArtistAlbumsProvider';
}

/// See also [getPerformingArtistAlbums].
class GetPerformingArtistAlbumsProvider
    extends AutoDisposeFutureProvider<List<BaseItemDto>> {
  /// See also [getPerformingArtistAlbums].
  GetPerformingArtistAlbumsProvider(
    BaseItemDto parent,
    BaseItemDto? genreFilter,
  ) : this._internal(
          (ref) => getPerformingArtistAlbums(
            ref as GetPerformingArtistAlbumsRef,
            parent,
            genreFilter,
          ),
          from: getPerformingArtistAlbumsProvider,
          name: r'getPerformingArtistAlbumsProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$getPerformingArtistAlbumsHash,
          dependencies: GetPerformingArtistAlbumsFamily._dependencies,
          allTransitiveDependencies:
              GetPerformingArtistAlbumsFamily._allTransitiveDependencies,
          parent: parent,
          genreFilter: genreFilter,
        );

  GetPerformingArtistAlbumsProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.parent,
    required this.genreFilter,
  }) : super.internal();

  final BaseItemDto parent;
  final BaseItemDto? genreFilter;

  @override
  Override overrideWith(
    FutureOr<List<BaseItemDto>> Function(GetPerformingArtistAlbumsRef provider)
        create,
  ) {
    return ProviderOverride(
      origin: this,
      override: GetPerformingArtistAlbumsProvider._internal(
        (ref) => create(ref as GetPerformingArtistAlbumsRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        parent: parent,
        genreFilter: genreFilter,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<BaseItemDto>> createElement() {
    return _GetPerformingArtistAlbumsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is GetPerformingArtistAlbumsProvider &&
        other.parent == parent &&
        other.genreFilter == genreFilter;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, parent.hashCode);
    hash = _SystemHash.combine(hash, genreFilter.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin GetPerformingArtistAlbumsRef
    on AutoDisposeFutureProviderRef<List<BaseItemDto>> {
  /// The parameter `parent` of this provider.
  BaseItemDto get parent;

  /// The parameter `genreFilter` of this provider.
  BaseItemDto? get genreFilter;
}

class _GetPerformingArtistAlbumsProviderElement
    extends AutoDisposeFutureProviderElement<List<BaseItemDto>>
    with GetPerformingArtistAlbumsRef {
  _GetPerformingArtistAlbumsProviderElement(super.provider);

  @override
  BaseItemDto get parent =>
      (origin as GetPerformingArtistAlbumsProvider).parent;
  @override
  BaseItemDto? get genreFilter =>
      (origin as GetPerformingArtistAlbumsProvider).genreFilter;
}

String _$getPerformingArtistTracksHash() =>
    r'4e95a967fdc93add3c4684e77b0b1d410f482b40';

/// See also [getPerformingArtistTracks].
@ProviderFor(getPerformingArtistTracks)
const getPerformingArtistTracksProvider = GetPerformingArtistTracksFamily();

/// See also [getPerformingArtistTracks].
class GetPerformingArtistTracksFamily
    extends Family<AsyncValue<List<BaseItemDto>>> {
  /// See also [getPerformingArtistTracks].
  const GetPerformingArtistTracksFamily();

  /// See also [getPerformingArtistTracks].
  GetPerformingArtistTracksProvider call(
    BaseItemDto parent,
    BaseItemDto? genreFilter,
  ) {
    return GetPerformingArtistTracksProvider(
      parent,
      genreFilter,
    );
  }

  @override
  GetPerformingArtistTracksProvider getProviderOverride(
    covariant GetPerformingArtistTracksProvider provider,
  ) {
    return call(
      provider.parent,
      provider.genreFilter,
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
  String? get name => r'getPerformingArtistTracksProvider';
}

/// See also [getPerformingArtistTracks].
class GetPerformingArtistTracksProvider
    extends AutoDisposeFutureProvider<List<BaseItemDto>> {
  /// See also [getPerformingArtistTracks].
  GetPerformingArtistTracksProvider(
    BaseItemDto parent,
    BaseItemDto? genreFilter,
  ) : this._internal(
          (ref) => getPerformingArtistTracks(
            ref as GetPerformingArtistTracksRef,
            parent,
            genreFilter,
          ),
          from: getPerformingArtistTracksProvider,
          name: r'getPerformingArtistTracksProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$getPerformingArtistTracksHash,
          dependencies: GetPerformingArtistTracksFamily._dependencies,
          allTransitiveDependencies:
              GetPerformingArtistTracksFamily._allTransitiveDependencies,
          parent: parent,
          genreFilter: genreFilter,
        );

  GetPerformingArtistTracksProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.parent,
    required this.genreFilter,
  }) : super.internal();

  final BaseItemDto parent;
  final BaseItemDto? genreFilter;

  @override
  Override overrideWith(
    FutureOr<List<BaseItemDto>> Function(GetPerformingArtistTracksRef provider)
        create,
  ) {
    return ProviderOverride(
      origin: this,
      override: GetPerformingArtistTracksProvider._internal(
        (ref) => create(ref as GetPerformingArtistTracksRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        parent: parent,
        genreFilter: genreFilter,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<BaseItemDto>> createElement() {
    return _GetPerformingArtistTracksProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is GetPerformingArtistTracksProvider &&
        other.parent == parent &&
        other.genreFilter == genreFilter;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, parent.hashCode);
    hash = _SystemHash.combine(hash, genreFilter.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin GetPerformingArtistTracksRef
    on AutoDisposeFutureProviderRef<List<BaseItemDto>> {
  /// The parameter `parent` of this provider.
  BaseItemDto get parent;

  /// The parameter `genreFilter` of this provider.
  BaseItemDto? get genreFilter;
}

class _GetPerformingArtistTracksProviderElement
    extends AutoDisposeFutureProviderElement<List<BaseItemDto>>
    with GetPerformingArtistTracksRef {
  _GetPerformingArtistTracksProviderElement(super.provider);

  @override
  BaseItemDto get parent =>
      (origin as GetPerformingArtistTracksProvider).parent;
  @override
  BaseItemDto? get genreFilter =>
      (origin as GetPerformingArtistTracksProvider).genreFilter;
}

String _$getAllTracksHash() => r'7658eb4192e7e8a767ce22f68352bfae319295fe';

/// See also [getAllTracks].
@ProviderFor(getAllTracks)
const getAllTracksProvider = GetAllTracksFamily();

/// See also [getAllTracks].
class GetAllTracksFamily extends Family<AsyncValue<List<BaseItemDto>>> {
  /// See also [getAllTracks].
  const GetAllTracksFamily();

  /// See also [getAllTracks].
  GetAllTracksProvider call(
    BaseItemDto parent,
    BaseItemDto? genreFilter,
  ) {
    return GetAllTracksProvider(
      parent,
      genreFilter,
    );
  }

  @override
  GetAllTracksProvider getProviderOverride(
    covariant GetAllTracksProvider provider,
  ) {
    return call(
      provider.parent,
      provider.genreFilter,
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
  String? get name => r'getAllTracksProvider';
}

/// See also [getAllTracks].
class GetAllTracksProvider
    extends AutoDisposeFutureProvider<List<BaseItemDto>> {
  /// See also [getAllTracks].
  GetAllTracksProvider(
    BaseItemDto parent,
    BaseItemDto? genreFilter,
  ) : this._internal(
          (ref) => getAllTracks(
            ref as GetAllTracksRef,
            parent,
            genreFilter,
          ),
          from: getAllTracksProvider,
          name: r'getAllTracksProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$getAllTracksHash,
          dependencies: GetAllTracksFamily._dependencies,
          allTransitiveDependencies:
              GetAllTracksFamily._allTransitiveDependencies,
          parent: parent,
          genreFilter: genreFilter,
        );

  GetAllTracksProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.parent,
    required this.genreFilter,
  }) : super.internal();

  final BaseItemDto parent;
  final BaseItemDto? genreFilter;

  @override
  Override overrideWith(
    FutureOr<List<BaseItemDto>> Function(GetAllTracksRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: GetAllTracksProvider._internal(
        (ref) => create(ref as GetAllTracksRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        parent: parent,
        genreFilter: genreFilter,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<BaseItemDto>> createElement() {
    return _GetAllTracksProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is GetAllTracksProvider &&
        other.parent == parent &&
        other.genreFilter == genreFilter;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, parent.hashCode);
    hash = _SystemHash.combine(hash, genreFilter.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin GetAllTracksRef on AutoDisposeFutureProviderRef<List<BaseItemDto>> {
  /// The parameter `parent` of this provider.
  BaseItemDto get parent;

  /// The parameter `genreFilter` of this provider.
  BaseItemDto? get genreFilter;
}

class _GetAllTracksProviderElement
    extends AutoDisposeFutureProviderElement<List<BaseItemDto>>
    with GetAllTracksRef {
  _GetAllTracksProviderElement(super.provider);

  @override
  BaseItemDto get parent => (origin as GetAllTracksProvider).parent;
  @override
  BaseItemDto? get genreFilter => (origin as GetAllTracksProvider).genreFilter;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
