// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'home_screen_content.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$loadHomeSectionItemsHash() =>
    r'885a0d41386aa5a336e9ccab9f153a612f48abaf';

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

/// See also [loadHomeSectionItems].
@ProviderFor(loadHomeSectionItems)
const loadHomeSectionItemsProvider = LoadHomeSectionItemsFamily();

/// See also [loadHomeSectionItems].
class LoadHomeSectionItemsFamily
    extends Family<AsyncValue<List<BaseItemDto>?>> {
  /// See also [loadHomeSectionItems].
  const LoadHomeSectionItemsFamily();

  /// See also [loadHomeSectionItems].
  LoadHomeSectionItemsProvider call({
    required HomeScreenSectionInfo sectionInfo,
    int startIndex = 0,
    int limit = homeScreenSectionItemLimit,
  }) {
    return LoadHomeSectionItemsProvider(
      sectionInfo: sectionInfo,
      startIndex: startIndex,
      limit: limit,
    );
  }

  @override
  LoadHomeSectionItemsProvider getProviderOverride(
    covariant LoadHomeSectionItemsProvider provider,
  ) {
    return call(
      sectionInfo: provider.sectionInfo,
      startIndex: provider.startIndex,
      limit: provider.limit,
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
  String? get name => r'loadHomeSectionItemsProvider';
}

/// See also [loadHomeSectionItems].
class LoadHomeSectionItemsProvider
    extends AutoDisposeFutureProvider<List<BaseItemDto>?> {
  /// See also [loadHomeSectionItems].
  LoadHomeSectionItemsProvider({
    required HomeScreenSectionInfo sectionInfo,
    int startIndex = 0,
    int limit = homeScreenSectionItemLimit,
  }) : this._internal(
          (ref) => loadHomeSectionItems(
            ref as LoadHomeSectionItemsRef,
            sectionInfo: sectionInfo,
            startIndex: startIndex,
            limit: limit,
          ),
          from: loadHomeSectionItemsProvider,
          name: r'loadHomeSectionItemsProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$loadHomeSectionItemsHash,
          dependencies: LoadHomeSectionItemsFamily._dependencies,
          allTransitiveDependencies:
              LoadHomeSectionItemsFamily._allTransitiveDependencies,
          sectionInfo: sectionInfo,
          startIndex: startIndex,
          limit: limit,
        );

  LoadHomeSectionItemsProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.sectionInfo,
    required this.startIndex,
    required this.limit,
  }) : super.internal();

  final HomeScreenSectionInfo sectionInfo;
  final int startIndex;
  final int limit;

  @override
  Override overrideWith(
    FutureOr<List<BaseItemDto>?> Function(LoadHomeSectionItemsRef provider)
        create,
  ) {
    return ProviderOverride(
      origin: this,
      override: LoadHomeSectionItemsProvider._internal(
        (ref) => create(ref as LoadHomeSectionItemsRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        sectionInfo: sectionInfo,
        startIndex: startIndex,
        limit: limit,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<BaseItemDto>?> createElement() {
    return _LoadHomeSectionItemsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is LoadHomeSectionItemsProvider &&
        other.sectionInfo == sectionInfo &&
        other.startIndex == startIndex &&
        other.limit == limit;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, sectionInfo.hashCode);
    hash = _SystemHash.combine(hash, startIndex.hashCode);
    hash = _SystemHash.combine(hash, limit.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin LoadHomeSectionItemsRef
    on AutoDisposeFutureProviderRef<List<BaseItemDto>?> {
  /// The parameter `sectionInfo` of this provider.
  HomeScreenSectionInfo get sectionInfo;

  /// The parameter `startIndex` of this provider.
  int get startIndex;

  /// The parameter `limit` of this provider.
  int get limit;
}

class _LoadHomeSectionItemsProviderElement
    extends AutoDisposeFutureProviderElement<List<BaseItemDto>?>
    with LoadHomeSectionItemsRef {
  _LoadHomeSectionItemsProviderElement(super.provider);

  @override
  HomeScreenSectionInfo get sectionInfo =>
      (origin as LoadHomeSectionItemsProvider).sectionInfo;
  @override
  int get startIndex => (origin as LoadHomeSectionItemsProvider).startIndex;
  @override
  int get limit => (origin as LoadHomeSectionItemsProvider).limit;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
