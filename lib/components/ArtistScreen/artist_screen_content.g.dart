// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'artist_screen_content.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$getArtistItemsHash() => r'5885058ecce28d5245597bdd32e208a1cc7505a9';

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

/// See also [getArtistItems].
@ProviderFor(getArtistItems)
const getArtistItemsProvider = GetArtistItemsFamily();

/// See also [getArtistItems].
class GetArtistItemsFamily extends Family<
    AsyncValue<
        (
          List<BaseItemDto>,
          List<BaseItemDto>,
          List<BaseItemDto>,
          List<BaseItemDto>
        )>> {
  /// See also [getArtistItems].
  const GetArtistItemsFamily();

  /// See also [getArtistItems].
  GetArtistItemsProvider call(
    BaseItemDto parent,
    BaseItemDto? genreFilter,
  ) {
    return GetArtistItemsProvider(
      parent,
      genreFilter,
    );
  }

  @override
  GetArtistItemsProvider getProviderOverride(
    covariant GetArtistItemsProvider provider,
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
  String? get name => r'getArtistItemsProvider';
}

/// See also [getArtistItems].
class GetArtistItemsProvider extends AutoDisposeFutureProvider<
    (
      List<BaseItemDto>,
      List<BaseItemDto>,
      List<BaseItemDto>,
      List<BaseItemDto>
    )> {
  /// See also [getArtistItems].
  GetArtistItemsProvider(
    BaseItemDto parent,
    BaseItemDto? genreFilter,
  ) : this._internal(
          (ref) => getArtistItems(
            ref as GetArtistItemsRef,
            parent,
            genreFilter,
          ),
          from: getArtistItemsProvider,
          name: r'getArtistItemsProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$getArtistItemsHash,
          dependencies: GetArtistItemsFamily._dependencies,
          allTransitiveDependencies:
              GetArtistItemsFamily._allTransitiveDependencies,
          parent: parent,
          genreFilter: genreFilter,
        );

  GetArtistItemsProvider._internal(
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
    FutureOr<
                (
                  List<BaseItemDto>,
                  List<BaseItemDto>,
                  List<BaseItemDto>,
                  List<BaseItemDto>
                )>
            Function(GetArtistItemsRef provider)
        create,
  ) {
    return ProviderOverride(
      origin: this,
      override: GetArtistItemsProvider._internal(
        (ref) => create(ref as GetArtistItemsRef),
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
  AutoDisposeFutureProviderElement<
      (
        List<BaseItemDto>,
        List<BaseItemDto>,
        List<BaseItemDto>,
        List<BaseItemDto>
      )> createElement() {
    return _GetArtistItemsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is GetArtistItemsProvider &&
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
mixin GetArtistItemsRef on AutoDisposeFutureProviderRef<
    (
      List<BaseItemDto>,
      List<BaseItemDto>,
      List<BaseItemDto>,
      List<BaseItemDto>
    )> {
  /// The parameter `parent` of this provider.
  BaseItemDto get parent;

  /// The parameter `genreFilter` of this provider.
  BaseItemDto? get genreFilter;
}

class _GetArtistItemsProviderElement extends AutoDisposeFutureProviderElement<
    (
      List<BaseItemDto>,
      List<BaseItemDto>,
      List<BaseItemDto>,
      List<BaseItemDto>
    )> with GetArtistItemsRef {
  _GetArtistItemsProviderElement(super.provider);

  @override
  BaseItemDto get parent => (origin as GetArtistItemsProvider).parent;
  @override
  BaseItemDto? get genreFilter =>
      (origin as GetArtistItemsProvider).genreFilter;
}

String _$getAllTracksHash() => r'6e1377f694bf1f489a96ce53053829c1c58c463f';

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
