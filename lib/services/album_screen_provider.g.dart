// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'album_screen_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$getAlbumOrPlaylistTracksHash() =>
    r'52ce8759a6954d8253a3e16d31dcc4c1e0ed11a9';

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

/// See also [getAlbumOrPlaylistTracks].
@ProviderFor(getAlbumOrPlaylistTracks)
const getAlbumOrPlaylistTracksProvider = GetAlbumOrPlaylistTracksFamily();

/// See also [getAlbumOrPlaylistTracks].
class GetAlbumOrPlaylistTracksFamily
    extends Family<AsyncValue<(List<BaseItemDto>, List<BaseItemDto>)>> {
  /// See also [getAlbumOrPlaylistTracks].
  const GetAlbumOrPlaylistTracksFamily();

  /// See also [getAlbumOrPlaylistTracks].
  GetAlbumOrPlaylistTracksProvider call(
    BaseItemDto parent, {
    BaseItemDto? genreFilter,
  }) {
    return GetAlbumOrPlaylistTracksProvider(
      parent,
      genreFilter: genreFilter,
    );
  }

  @override
  GetAlbumOrPlaylistTracksProvider getProviderOverride(
    covariant GetAlbumOrPlaylistTracksProvider provider,
  ) {
    return call(
      provider.parent,
      genreFilter: provider.genreFilter,
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
  String? get name => r'getAlbumOrPlaylistTracksProvider';
}

/// See also [getAlbumOrPlaylistTracks].
class GetAlbumOrPlaylistTracksProvider
    extends AutoDisposeFutureProvider<(List<BaseItemDto>, List<BaseItemDto>)> {
  /// See also [getAlbumOrPlaylistTracks].
  GetAlbumOrPlaylistTracksProvider(
    BaseItemDto parent, {
    BaseItemDto? genreFilter,
  }) : this._internal(
          (ref) => getAlbumOrPlaylistTracks(
            ref as GetAlbumOrPlaylistTracksRef,
            parent,
            genreFilter: genreFilter,
          ),
          from: getAlbumOrPlaylistTracksProvider,
          name: r'getAlbumOrPlaylistTracksProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$getAlbumOrPlaylistTracksHash,
          dependencies: GetAlbumOrPlaylistTracksFamily._dependencies,
          allTransitiveDependencies:
              GetAlbumOrPlaylistTracksFamily._allTransitiveDependencies,
          parent: parent,
          genreFilter: genreFilter,
        );

  GetAlbumOrPlaylistTracksProvider._internal(
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
    FutureOr<(List<BaseItemDto>, List<BaseItemDto>)> Function(
            GetAlbumOrPlaylistTracksRef provider)
        create,
  ) {
    return ProviderOverride(
      origin: this,
      override: GetAlbumOrPlaylistTracksProvider._internal(
        (ref) => create(ref as GetAlbumOrPlaylistTracksRef),
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
  AutoDisposeFutureProviderElement<(List<BaseItemDto>, List<BaseItemDto>)>
      createElement() {
    return _GetAlbumOrPlaylistTracksProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is GetAlbumOrPlaylistTracksProvider &&
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
mixin GetAlbumOrPlaylistTracksRef
    on AutoDisposeFutureProviderRef<(List<BaseItemDto>, List<BaseItemDto>)> {
  /// The parameter `parent` of this provider.
  BaseItemDto get parent;

  /// The parameter `genreFilter` of this provider.
  BaseItemDto? get genreFilter;
}

class _GetAlbumOrPlaylistTracksProviderElement
    extends AutoDisposeFutureProviderElement<
        (List<BaseItemDto>, List<BaseItemDto>)>
    with GetAlbumOrPlaylistTracksRef {
  _GetAlbumOrPlaylistTracksProviderElement(super.provider);

  @override
  BaseItemDto get parent => (origin as GetAlbumOrPlaylistTracksProvider).parent;
  @override
  BaseItemDto? get genreFilter =>
      (origin as GetAlbumOrPlaylistTracksProvider).genreFilter;
}

String _$getSortedPlaylistTracksHash() =>
    r'104d7b849f919bb29003867fa6d6db4418e84bda';

/// See also [getSortedPlaylistTracks].
@ProviderFor(getSortedPlaylistTracks)
const getSortedPlaylistTracksProvider = GetSortedPlaylistTracksFamily();

/// See also [getSortedPlaylistTracks].
class GetSortedPlaylistTracksFamily
    extends Family<AsyncValue<(List<BaseItemDto>, List<BaseItemDto>)>> {
  /// See also [getSortedPlaylistTracks].
  const GetSortedPlaylistTracksFamily();

  /// See also [getSortedPlaylistTracks].
  GetSortedPlaylistTracksProvider call(
    BaseItemDto parent, {
    BaseItemDto? genreFilter,
  }) {
    return GetSortedPlaylistTracksProvider(
      parent,
      genreFilter: genreFilter,
    );
  }

  @override
  GetSortedPlaylistTracksProvider getProviderOverride(
    covariant GetSortedPlaylistTracksProvider provider,
  ) {
    return call(
      provider.parent,
      genreFilter: provider.genreFilter,
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
  String? get name => r'getSortedPlaylistTracksProvider';
}

/// See also [getSortedPlaylistTracks].
class GetSortedPlaylistTracksProvider
    extends AutoDisposeFutureProvider<(List<BaseItemDto>, List<BaseItemDto>)> {
  /// See also [getSortedPlaylistTracks].
  GetSortedPlaylistTracksProvider(
    BaseItemDto parent, {
    BaseItemDto? genreFilter,
  }) : this._internal(
          (ref) => getSortedPlaylistTracks(
            ref as GetSortedPlaylistTracksRef,
            parent,
            genreFilter: genreFilter,
          ),
          from: getSortedPlaylistTracksProvider,
          name: r'getSortedPlaylistTracksProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$getSortedPlaylistTracksHash,
          dependencies: GetSortedPlaylistTracksFamily._dependencies,
          allTransitiveDependencies:
              GetSortedPlaylistTracksFamily._allTransitiveDependencies,
          parent: parent,
          genreFilter: genreFilter,
        );

  GetSortedPlaylistTracksProvider._internal(
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
    FutureOr<(List<BaseItemDto>, List<BaseItemDto>)> Function(
            GetSortedPlaylistTracksRef provider)
        create,
  ) {
    return ProviderOverride(
      origin: this,
      override: GetSortedPlaylistTracksProvider._internal(
        (ref) => create(ref as GetSortedPlaylistTracksRef),
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
  AutoDisposeFutureProviderElement<(List<BaseItemDto>, List<BaseItemDto>)>
      createElement() {
    return _GetSortedPlaylistTracksProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is GetSortedPlaylistTracksProvider &&
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
mixin GetSortedPlaylistTracksRef
    on AutoDisposeFutureProviderRef<(List<BaseItemDto>, List<BaseItemDto>)> {
  /// The parameter `parent` of this provider.
  BaseItemDto get parent;

  /// The parameter `genreFilter` of this provider.
  BaseItemDto? get genreFilter;
}

class _GetSortedPlaylistTracksProviderElement
    extends AutoDisposeFutureProviderElement<
        (List<BaseItemDto>, List<BaseItemDto>)>
    with GetSortedPlaylistTracksRef {
  _GetSortedPlaylistTracksProviderElement(super.provider);

  @override
  BaseItemDto get parent => (origin as GetSortedPlaylistTracksProvider).parent;
  @override
  BaseItemDto? get genreFilter =>
      (origin as GetSortedPlaylistTracksProvider).genreFilter;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
