// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'artist_screen_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$getArtistTracksSectionHash() =>
    r'9cc1ff8e3490dacce062e0653f73a3f7831a7a9c';

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

/// See also [getArtistTracksSection].
@ProviderFor(getArtistTracksSection)
const getArtistTracksSectionProvider = GetArtistTracksSectionFamily();

/// See also [getArtistTracksSection].
class GetArtistTracksSectionFamily extends Family<
    AsyncValue<
        (
          List<BaseItemDto>,
          CuratedItemSelectionType,
          Set<CuratedItemSelectionType>?
        )>> {
  /// See also [getArtistTracksSection].
  const GetArtistTracksSectionFamily();

  /// See also [getArtistTracksSection].
  GetArtistTracksSectionProvider call(
    BaseItemDto parent,
    BaseItemDto? library,
    BaseItemDto? genreFilter,
  ) {
    return GetArtistTracksSectionProvider(
      parent,
      library,
      genreFilter,
    );
  }

  @override
  GetArtistTracksSectionProvider getProviderOverride(
    covariant GetArtistTracksSectionProvider provider,
  ) {
    return call(
      provider.parent,
      provider.library,
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
  String? get name => r'getArtistTracksSectionProvider';
}

/// See also [getArtistTracksSection].
class GetArtistTracksSectionProvider extends AutoDisposeFutureProvider<
    (
      List<BaseItemDto>,
      CuratedItemSelectionType,
      Set<CuratedItemSelectionType>?
    )> {
  /// See also [getArtistTracksSection].
  GetArtistTracksSectionProvider(
    BaseItemDto parent,
    BaseItemDto? library,
    BaseItemDto? genreFilter,
  ) : this._internal(
          (ref) => getArtistTracksSection(
            ref as GetArtistTracksSectionRef,
            parent,
            library,
            genreFilter,
          ),
          from: getArtistTracksSectionProvider,
          name: r'getArtistTracksSectionProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$getArtistTracksSectionHash,
          dependencies: GetArtistTracksSectionFamily._dependencies,
          allTransitiveDependencies:
              GetArtistTracksSectionFamily._allTransitiveDependencies,
          parent: parent,
          library: library,
          genreFilter: genreFilter,
        );

  GetArtistTracksSectionProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.parent,
    required this.library,
    required this.genreFilter,
  }) : super.internal();

  final BaseItemDto parent;
  final BaseItemDto? library;
  final BaseItemDto? genreFilter;

  @override
  Override overrideWith(
    FutureOr<
                (
                  List<BaseItemDto>,
                  CuratedItemSelectionType,
                  Set<CuratedItemSelectionType>?
                )>
            Function(GetArtistTracksSectionRef provider)
        create,
  ) {
    return ProviderOverride(
      origin: this,
      override: GetArtistTracksSectionProvider._internal(
        (ref) => create(ref as GetArtistTracksSectionRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        parent: parent,
        library: library,
        genreFilter: genreFilter,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<
      (
        List<BaseItemDto>,
        CuratedItemSelectionType,
        Set<CuratedItemSelectionType>?
      )> createElement() {
    return _GetArtistTracksSectionProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is GetArtistTracksSectionProvider &&
        other.parent == parent &&
        other.library == library &&
        other.genreFilter == genreFilter;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, parent.hashCode);
    hash = _SystemHash.combine(hash, library.hashCode);
    hash = _SystemHash.combine(hash, genreFilter.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin GetArtistTracksSectionRef on AutoDisposeFutureProviderRef<
    (
      List<BaseItemDto>,
      CuratedItemSelectionType,
      Set<CuratedItemSelectionType>?
    )> {
  /// The parameter `parent` of this provider.
  BaseItemDto get parent;

  /// The parameter `library` of this provider.
  BaseItemDto? get library;

  /// The parameter `genreFilter` of this provider.
  BaseItemDto? get genreFilter;
}

class _GetArtistTracksSectionProviderElement
    extends AutoDisposeFutureProviderElement<
        (
          List<BaseItemDto>,
          CuratedItemSelectionType,
          Set<CuratedItemSelectionType>?
        )> with GetArtistTracksSectionRef {
  _GetArtistTracksSectionProviderElement(super.provider);

  @override
  BaseItemDto get parent => (origin as GetArtistTracksSectionProvider).parent;
  @override
  BaseItemDto? get library =>
      (origin as GetArtistTracksSectionProvider).library;
  @override
  BaseItemDto? get genreFilter =>
      (origin as GetArtistTracksSectionProvider).genreFilter;
}

String _$getArtistAlbumsHash() => r'0224beeee2ebe77aeb7d302ae2b3d063c77017ec';

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
    BaseItemDto? library,
    BaseItemDto? genreFilter,
  ) {
    return GetArtistAlbumsProvider(
      parent,
      library,
      genreFilter,
    );
  }

  @override
  GetArtistAlbumsProvider getProviderOverride(
    covariant GetArtistAlbumsProvider provider,
  ) {
    return call(
      provider.parent,
      provider.library,
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
    BaseItemDto? library,
    BaseItemDto? genreFilter,
  ) : this._internal(
          (ref) => getArtistAlbums(
            ref as GetArtistAlbumsRef,
            parent,
            library,
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
          library: library,
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
    required this.library,
    required this.genreFilter,
  }) : super.internal();

  final BaseItemDto parent;
  final BaseItemDto? library;
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
        library: library,
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
        other.library == library &&
        other.genreFilter == genreFilter;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, parent.hashCode);
    hash = _SystemHash.combine(hash, library.hashCode);
    hash = _SystemHash.combine(hash, genreFilter.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin GetArtistAlbumsRef on AutoDisposeFutureProviderRef<List<BaseItemDto>> {
  /// The parameter `parent` of this provider.
  BaseItemDto get parent;

  /// The parameter `library` of this provider.
  BaseItemDto? get library;

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
  BaseItemDto? get library => (origin as GetArtistAlbumsProvider).library;
  @override
  BaseItemDto? get genreFilter =>
      (origin as GetArtistAlbumsProvider).genreFilter;
}

String _$getPerformingArtistAlbumsHash() =>
    r'19399216cef3e2758f4497ef079953990b935ff7';

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
    BaseItemDto? library,
    BaseItemDto? genreFilter,
  ) {
    return GetPerformingArtistAlbumsProvider(
      parent,
      library,
      genreFilter,
    );
  }

  @override
  GetPerformingArtistAlbumsProvider getProviderOverride(
    covariant GetPerformingArtistAlbumsProvider provider,
  ) {
    return call(
      provider.parent,
      provider.library,
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
    BaseItemDto? library,
    BaseItemDto? genreFilter,
  ) : this._internal(
          (ref) => getPerformingArtistAlbums(
            ref as GetPerformingArtistAlbumsRef,
            parent,
            library,
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
          library: library,
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
    required this.library,
    required this.genreFilter,
  }) : super.internal();

  final BaseItemDto parent;
  final BaseItemDto? library;
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
        library: library,
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
        other.library == library &&
        other.genreFilter == genreFilter;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, parent.hashCode);
    hash = _SystemHash.combine(hash, library.hashCode);
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

  /// The parameter `library` of this provider.
  BaseItemDto? get library;

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
  BaseItemDto? get library =>
      (origin as GetPerformingArtistAlbumsProvider).library;
  @override
  BaseItemDto? get genreFilter =>
      (origin as GetPerformingArtistAlbumsProvider).genreFilter;
}

String _$getPerformingArtistTracksHash() =>
    r'72b6d951306d5ea2540837ba23f032f93f49b5fe';

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
    BaseItemDto? library,
    BaseItemDto? genreFilter, {
    bool onlyFavorites = false,
  }) {
    return GetPerformingArtistTracksProvider(
      parent,
      library,
      genreFilter,
      onlyFavorites: onlyFavorites,
    );
  }

  @override
  GetPerformingArtistTracksProvider getProviderOverride(
    covariant GetPerformingArtistTracksProvider provider,
  ) {
    return call(
      provider.parent,
      provider.library,
      provider.genreFilter,
      onlyFavorites: provider.onlyFavorites,
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
    BaseItemDto? library,
    BaseItemDto? genreFilter, {
    bool onlyFavorites = false,
  }) : this._internal(
          (ref) => getPerformingArtistTracks(
            ref as GetPerformingArtistTracksRef,
            parent,
            library,
            genreFilter,
            onlyFavorites: onlyFavorites,
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
          library: library,
          genreFilter: genreFilter,
          onlyFavorites: onlyFavorites,
        );

  GetPerformingArtistTracksProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.parent,
    required this.library,
    required this.genreFilter,
    required this.onlyFavorites,
  }) : super.internal();

  final BaseItemDto parent;
  final BaseItemDto? library;
  final BaseItemDto? genreFilter;
  final bool onlyFavorites;

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
        library: library,
        genreFilter: genreFilter,
        onlyFavorites: onlyFavorites,
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
        other.library == library &&
        other.genreFilter == genreFilter &&
        other.onlyFavorites == onlyFavorites;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, parent.hashCode);
    hash = _SystemHash.combine(hash, library.hashCode);
    hash = _SystemHash.combine(hash, genreFilter.hashCode);
    hash = _SystemHash.combine(hash, onlyFavorites.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin GetPerformingArtistTracksRef
    on AutoDisposeFutureProviderRef<List<BaseItemDto>> {
  /// The parameter `parent` of this provider.
  BaseItemDto get parent;

  /// The parameter `library` of this provider.
  BaseItemDto? get library;

  /// The parameter `genreFilter` of this provider.
  BaseItemDto? get genreFilter;

  /// The parameter `onlyFavorites` of this provider.
  bool get onlyFavorites;
}

class _GetPerformingArtistTracksProviderElement
    extends AutoDisposeFutureProviderElement<List<BaseItemDto>>
    with GetPerformingArtistTracksRef {
  _GetPerformingArtistTracksProviderElement(super.provider);

  @override
  BaseItemDto get parent =>
      (origin as GetPerformingArtistTracksProvider).parent;
  @override
  BaseItemDto? get library =>
      (origin as GetPerformingArtistTracksProvider).library;
  @override
  BaseItemDto? get genreFilter =>
      (origin as GetPerformingArtistTracksProvider).genreFilter;
  @override
  bool get onlyFavorites =>
      (origin as GetPerformingArtistTracksProvider).onlyFavorites;
}

String _$getAllTracksHash() => r'e2aad275ffbec7c1a92369a2306213f7005dd4eb';

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
    BaseItemDto? library,
    BaseItemDto? genreFilter, {
    bool onlyFavorites = false,
  }) {
    return GetAllTracksProvider(
      parent,
      library,
      genreFilter,
      onlyFavorites: onlyFavorites,
    );
  }

  @override
  GetAllTracksProvider getProviderOverride(
    covariant GetAllTracksProvider provider,
  ) {
    return call(
      provider.parent,
      provider.library,
      provider.genreFilter,
      onlyFavorites: provider.onlyFavorites,
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
    BaseItemDto? library,
    BaseItemDto? genreFilter, {
    bool onlyFavorites = false,
  }) : this._internal(
          (ref) => getAllTracks(
            ref as GetAllTracksRef,
            parent,
            library,
            genreFilter,
            onlyFavorites: onlyFavorites,
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
          library: library,
          genreFilter: genreFilter,
          onlyFavorites: onlyFavorites,
        );

  GetAllTracksProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.parent,
    required this.library,
    required this.genreFilter,
    required this.onlyFavorites,
  }) : super.internal();

  final BaseItemDto parent;
  final BaseItemDto? library;
  final BaseItemDto? genreFilter;
  final bool onlyFavorites;

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
        library: library,
        genreFilter: genreFilter,
        onlyFavorites: onlyFavorites,
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
        other.library == library &&
        other.genreFilter == genreFilter &&
        other.onlyFavorites == onlyFavorites;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, parent.hashCode);
    hash = _SystemHash.combine(hash, library.hashCode);
    hash = _SystemHash.combine(hash, genreFilter.hashCode);
    hash = _SystemHash.combine(hash, onlyFavorites.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin GetAllTracksRef on AutoDisposeFutureProviderRef<List<BaseItemDto>> {
  /// The parameter `parent` of this provider.
  BaseItemDto get parent;

  /// The parameter `library` of this provider.
  BaseItemDto? get library;

  /// The parameter `genreFilter` of this provider.
  BaseItemDto? get genreFilter;

  /// The parameter `onlyFavorites` of this provider.
  bool get onlyFavorites;
}

class _GetAllTracksProviderElement
    extends AutoDisposeFutureProviderElement<List<BaseItemDto>>
    with GetAllTracksRef {
  _GetAllTracksProviderElement(super.provider);

  @override
  BaseItemDto get parent => (origin as GetAllTracksProvider).parent;
  @override
  BaseItemDto? get library => (origin as GetAllTracksProvider).library;
  @override
  BaseItemDto? get genreFilter => (origin as GetAllTracksProvider).genreFilter;
  @override
  bool get onlyFavorites => (origin as GetAllTracksProvider).onlyFavorites;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
