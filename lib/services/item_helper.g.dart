// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'item_helper.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$loadChildTracksHash() => r'b6152f93d59d5b36a87a5d267b7edc7350c15355';

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
    bool manuallyShuffle = false,
  }) {
    return LoadChildTracksProvider(
      baseItem: baseItem,
      sortBy: sortBy,
      sortOrder: sortOrder,
      groupListBy: groupListBy,
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
    bool manuallyShuffle = false,
  }) : this._internal(
          (ref) => loadChildTracks(
            ref as LoadChildTracksRef,
            baseItem: baseItem,
            sortBy: sortBy,
            sortOrder: sortOrder,
            groupListBy: groupListBy,
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
    required this.manuallyShuffle,
  }) : super.internal();

  final BaseItemDto baseItem;
  final SortBy? sortBy;
  final SortOrder? sortOrder;
  final String? Function(BaseItemDto)? groupListBy;
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
        other.manuallyShuffle == manuallyShuffle;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, baseItem.hashCode);
    hash = _SystemHash.combine(hash, sortBy.hashCode);
    hash = _SystemHash.combine(hash, sortOrder.hashCode);
    hash = _SystemHash.combine(hash, groupListBy.hashCode);
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
  bool get manuallyShuffle =>
      (origin as LoadChildTracksProvider).manuallyShuffle;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
