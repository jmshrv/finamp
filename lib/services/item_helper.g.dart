// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'item_helper.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$loadChildTracksHash() => r'df14f407da4591662fd189358acc71aa1faee19a';

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

/// See also [loadChildTracks].
@ProviderFor(loadChildTracks)
const loadChildTracksProvider = LoadChildTracksFamily();

/// See also [loadChildTracks].
class LoadChildTracksFamily extends Family<AsyncValue<List<BaseItemDto>?>> {
  /// See also [loadChildTracks].
  const LoadChildTracksFamily();

  /// See also [loadChildTracks].
  LoadChildTracksProvider call({
    required BaseItemDto baseItem,
    SortBy? sortBy,
    SortOrder? sortOrder,
    String? Function(BaseItemDto)? groupListBy,
    BaseItemDto? genreFilter,
    bool manuallyShuffle = false,
  }) {
    return LoadChildTracksProvider(
      baseItem: baseItem,
      sortBy: sortBy,
      sortOrder: sortOrder,
      groupListBy: groupListBy,
      genreFilter: genreFilter,
      manuallyShuffle: manuallyShuffle,
    );
  }

  @override
  LoadChildTracksProvider getProviderOverride(
    covariant LoadChildTracksProvider provider,
  ) {
    return call(
      baseItem: provider.baseItem,
      sortBy: provider.sortBy,
      sortOrder: provider.sortOrder,
      groupListBy: provider.groupListBy,
      genreFilter: provider.genreFilter,
      manuallyShuffle: provider.manuallyShuffle,
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
  String? get name => r'loadChildTracksProvider';
}

/// See also [loadChildTracks].
class LoadChildTracksProvider
    extends AutoDisposeFutureProvider<List<BaseItemDto>?> {
  /// See also [loadChildTracks].
  LoadChildTracksProvider({
    required BaseItemDto baseItem,
    SortBy? sortBy,
    SortOrder? sortOrder,
    String? Function(BaseItemDto)? groupListBy,
    BaseItemDto? genreFilter,
    bool manuallyShuffle = false,
  }) : this._internal(
          (ref) => loadChildTracks(
            ref as LoadChildTracksRef,
            baseItem: baseItem,
            sortBy: sortBy,
            sortOrder: sortOrder,
            groupListBy: groupListBy,
            genreFilter: genreFilter,
            manuallyShuffle: manuallyShuffle,
          ),
          from: loadChildTracksProvider,
          name: r'loadChildTracksProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$loadChildTracksHash,
          dependencies: LoadChildTracksFamily._dependencies,
          allTransitiveDependencies:
              LoadChildTracksFamily._allTransitiveDependencies,
          baseItem: baseItem,
          sortBy: sortBy,
          sortOrder: sortOrder,
          groupListBy: groupListBy,
          genreFilter: genreFilter,
          manuallyShuffle: manuallyShuffle,
        );

  LoadChildTracksProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.baseItem,
    required this.sortBy,
    required this.sortOrder,
    required this.groupListBy,
    required this.genreFilter,
    required this.manuallyShuffle,
  }) : super.internal();

  final BaseItemDto baseItem;
  final SortBy? sortBy;
  final SortOrder? sortOrder;
  final String? Function(BaseItemDto)? groupListBy;
  final BaseItemDto? genreFilter;
  final bool manuallyShuffle;

  @override
  Override overrideWith(
    FutureOr<List<BaseItemDto>?> Function(LoadChildTracksRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: LoadChildTracksProvider._internal(
        (ref) => create(ref as LoadChildTracksRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        baseItem: baseItem,
        sortBy: sortBy,
        sortOrder: sortOrder,
        groupListBy: groupListBy,
        genreFilter: genreFilter,
        manuallyShuffle: manuallyShuffle,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<BaseItemDto>?> createElement() {
    return _LoadChildTracksProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is LoadChildTracksProvider &&
        other.baseItem == baseItem &&
        other.sortBy == sortBy &&
        other.sortOrder == sortOrder &&
        other.groupListBy == groupListBy &&
        other.genreFilter == genreFilter &&
        other.manuallyShuffle == manuallyShuffle;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, baseItem.hashCode);
    hash = _SystemHash.combine(hash, sortBy.hashCode);
    hash = _SystemHash.combine(hash, sortOrder.hashCode);
    hash = _SystemHash.combine(hash, groupListBy.hashCode);
    hash = _SystemHash.combine(hash, genreFilter.hashCode);
    hash = _SystemHash.combine(hash, manuallyShuffle.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin LoadChildTracksRef on AutoDisposeFutureProviderRef<List<BaseItemDto>?> {
  /// The parameter `baseItem` of this provider.
  BaseItemDto get baseItem;

  /// The parameter `sortBy` of this provider.
  SortBy? get sortBy;

  /// The parameter `sortOrder` of this provider.
  SortOrder? get sortOrder;

  /// The parameter `groupListBy` of this provider.
  String? Function(BaseItemDto)? get groupListBy;

  /// The parameter `genreFilter` of this provider.
  BaseItemDto? get genreFilter;

  /// The parameter `manuallyShuffle` of this provider.
  bool get manuallyShuffle;
}

class _LoadChildTracksProviderElement
    extends AutoDisposeFutureProviderElement<List<BaseItemDto>?>
    with LoadChildTracksRef {
  _LoadChildTracksProviderElement(super.provider);

  @override
  BaseItemDto get baseItem => (origin as LoadChildTracksProvider).baseItem;
  @override
  SortBy? get sortBy => (origin as LoadChildTracksProvider).sortBy;
  @override
  SortOrder? get sortOrder => (origin as LoadChildTracksProvider).sortOrder;
  @override
  String? Function(BaseItemDto)? get groupListBy =>
      (origin as LoadChildTracksProvider).groupListBy;
  @override
  BaseItemDto? get genreFilter =>
      (origin as LoadChildTracksProvider).genreFilter;
  @override
  bool get manuallyShuffle =>
      (origin as LoadChildTracksProvider).manuallyShuffle;
}

String _$loadChildTracksOfflineHash() =>
    r'3b8d6d4e10d8106bd066438bfb82a288db3da9ae';

/// See also [loadChildTracksOffline].
@ProviderFor(loadChildTracksOffline)
const loadChildTracksOfflineProvider = LoadChildTracksOfflineFamily();

/// See also [loadChildTracksOffline].
class LoadChildTracksOfflineFamily
    extends Family<AsyncValue<List<BaseItemDto>?>> {
  /// See also [loadChildTracksOffline].
  const LoadChildTracksOfflineFamily();

  /// See also [loadChildTracksOffline].
  LoadChildTracksOfflineProvider call({
    required BaseItemDto baseItem,
    int? limit,
    BaseItemDto? genreFilter,
  }) {
    return LoadChildTracksOfflineProvider(
      baseItem: baseItem,
      limit: limit,
      genreFilter: genreFilter,
    );
  }

  @override
  LoadChildTracksOfflineProvider getProviderOverride(
    covariant LoadChildTracksOfflineProvider provider,
  ) {
    return call(
      baseItem: provider.baseItem,
      limit: provider.limit,
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
  String? get name => r'loadChildTracksOfflineProvider';
}

/// See also [loadChildTracksOffline].
class LoadChildTracksOfflineProvider
    extends AutoDisposeFutureProvider<List<BaseItemDto>?> {
  /// See also [loadChildTracksOffline].
  LoadChildTracksOfflineProvider({
    required BaseItemDto baseItem,
    int? limit,
    BaseItemDto? genreFilter,
  }) : this._internal(
          (ref) => loadChildTracksOffline(
            ref as LoadChildTracksOfflineRef,
            baseItem: baseItem,
            limit: limit,
            genreFilter: genreFilter,
          ),
          from: loadChildTracksOfflineProvider,
          name: r'loadChildTracksOfflineProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$loadChildTracksOfflineHash,
          dependencies: LoadChildTracksOfflineFamily._dependencies,
          allTransitiveDependencies:
              LoadChildTracksOfflineFamily._allTransitiveDependencies,
          baseItem: baseItem,
          limit: limit,
          genreFilter: genreFilter,
        );

  LoadChildTracksOfflineProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.baseItem,
    required this.limit,
    required this.genreFilter,
  }) : super.internal();

  final BaseItemDto baseItem;
  final int? limit;
  final BaseItemDto? genreFilter;

  @override
  Override overrideWith(
    FutureOr<List<BaseItemDto>?> Function(LoadChildTracksOfflineRef provider)
        create,
  ) {
    return ProviderOverride(
      origin: this,
      override: LoadChildTracksOfflineProvider._internal(
        (ref) => create(ref as LoadChildTracksOfflineRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        baseItem: baseItem,
        limit: limit,
        genreFilter: genreFilter,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<BaseItemDto>?> createElement() {
    return _LoadChildTracksOfflineProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is LoadChildTracksOfflineProvider &&
        other.baseItem == baseItem &&
        other.limit == limit &&
        other.genreFilter == genreFilter;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, baseItem.hashCode);
    hash = _SystemHash.combine(hash, limit.hashCode);
    hash = _SystemHash.combine(hash, genreFilter.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin LoadChildTracksOfflineRef
    on AutoDisposeFutureProviderRef<List<BaseItemDto>?> {
  /// The parameter `baseItem` of this provider.
  BaseItemDto get baseItem;

  /// The parameter `limit` of this provider.
  int? get limit;

  /// The parameter `genreFilter` of this provider.
  BaseItemDto? get genreFilter;
}

class _LoadChildTracksOfflineProviderElement
    extends AutoDisposeFutureProviderElement<List<BaseItemDto>?>
    with LoadChildTracksOfflineRef {
  _LoadChildTracksOfflineProviderElement(super.provider);

  @override
  BaseItemDto get baseItem =>
      (origin as LoadChildTracksOfflineProvider).baseItem;
  @override
  int? get limit => (origin as LoadChildTracksOfflineProvider).limit;
  @override
  BaseItemDto? get genreFilter =>
      (origin as LoadChildTracksOfflineProvider).genreFilter;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
