// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'item_amount_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$itemAmountHash() => r'7dae4d43af1597e1f837ee31d3cd4f753a126de8';

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

/// See also [itemAmount].
@ProviderFor(itemAmount)
const itemAmountProvider = ItemAmountFamily();

/// See also [itemAmount].
class ItemAmountFamily extends Family<AsyncValue<(int, BaseItemDtoType)>> {
  /// See also [itemAmount].
  const ItemAmountFamily();

  /// See also [itemAmount].
  ItemAmountProvider call({
    required BaseItemDto baseItem,
    bool showTrackCountForArtists = false,
  }) {
    return ItemAmountProvider(
      baseItem: baseItem,
      showTrackCountForArtists: showTrackCountForArtists,
    );
  }

  @override
  ItemAmountProvider getProviderOverride(
    covariant ItemAmountProvider provider,
  ) {
    return call(
      baseItem: provider.baseItem,
      showTrackCountForArtists: provider.showTrackCountForArtists,
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
  String? get name => r'itemAmountProvider';
}

/// See also [itemAmount].
class ItemAmountProvider
    extends AutoDisposeFutureProvider<(int, BaseItemDtoType)> {
  /// See also [itemAmount].
  ItemAmountProvider({
    required BaseItemDto baseItem,
    bool showTrackCountForArtists = false,
  }) : this._internal(
          (ref) => itemAmount(
            ref as ItemAmountRef,
            baseItem: baseItem,
            showTrackCountForArtists: showTrackCountForArtists,
          ),
          from: itemAmountProvider,
          name: r'itemAmountProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$itemAmountHash,
          dependencies: ItemAmountFamily._dependencies,
          allTransitiveDependencies:
              ItemAmountFamily._allTransitiveDependencies,
          baseItem: baseItem,
          showTrackCountForArtists: showTrackCountForArtists,
        );

  ItemAmountProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.baseItem,
    required this.showTrackCountForArtists,
  }) : super.internal();

  final BaseItemDto baseItem;
  final bool showTrackCountForArtists;

  @override
  Override overrideWith(
    FutureOr<(int, BaseItemDtoType)> Function(ItemAmountRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: ItemAmountProvider._internal(
        (ref) => create(ref as ItemAmountRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        baseItem: baseItem,
        showTrackCountForArtists: showTrackCountForArtists,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<(int, BaseItemDtoType)> createElement() {
    return _ItemAmountProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ItemAmountProvider &&
        other.baseItem == baseItem &&
        other.showTrackCountForArtists == showTrackCountForArtists;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, baseItem.hashCode);
    hash = _SystemHash.combine(hash, showTrackCountForArtists.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin ItemAmountRef on AutoDisposeFutureProviderRef<(int, BaseItemDtoType)> {
  /// The parameter `baseItem` of this provider.
  BaseItemDto get baseItem;

  /// The parameter `showTrackCountForArtists` of this provider.
  bool get showTrackCountForArtists;
}

class _ItemAmountProviderElement
    extends AutoDisposeFutureProviderElement<(int, BaseItemDtoType)>
    with ItemAmountRef {
  _ItemAmountProviderElement(super.provider);

  @override
  BaseItemDto get baseItem => (origin as ItemAmountProvider).baseItem;
  @override
  bool get showTrackCountForArtists =>
      (origin as ItemAmountProvider).showTrackCountForArtists;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
