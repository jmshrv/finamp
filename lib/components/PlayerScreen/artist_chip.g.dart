// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'artist_chip.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$artistItemHash() => r'8e699c71ec503dbea29574069bd231e396ad3db2';

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

/// See also [artistItem].
@ProviderFor(artistItem)
const artistItemProvider = ArtistItemFamily();

/// See also [artistItem].
class ArtistItemFamily extends Family<AsyncValue<BaseItemDto>> {
  /// See also [artistItem].
  const ArtistItemFamily();

  /// See also [artistItem].
  ArtistItemProvider call(
    String id,
  ) {
    return ArtistItemProvider(
      id,
    );
  }

  @override
  ArtistItemProvider getProviderOverride(
    covariant ArtistItemProvider provider,
  ) {
    return call(
      provider.id,
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
  String? get name => r'artistItemProvider';
}

/// See also [artistItem].
class ArtistItemProvider extends AutoDisposeFutureProvider<BaseItemDto> {
  /// See also [artistItem].
  ArtistItemProvider(
    String id,
  ) : this._internal(
          (ref) => artistItem(
            ref as ArtistItemRef,
            id,
          ),
          from: artistItemProvider,
          name: r'artistItemProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$artistItemHash,
          dependencies: ArtistItemFamily._dependencies,
          allTransitiveDependencies:
              ArtistItemFamily._allTransitiveDependencies,
          id: id,
        );

  ArtistItemProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.id,
  }) : super.internal();

  final String id;

  @override
  Override overrideWith(
    FutureOr<BaseItemDto> Function(ArtistItemRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: ArtistItemProvider._internal(
        (ref) => create(ref as ArtistItemRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        id: id,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<BaseItemDto> createElement() {
    return _ArtistItemProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ArtistItemProvider && other.id == id;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, id.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin ArtistItemRef on AutoDisposeFutureProviderRef<BaseItemDto> {
  /// The parameter `id` of this provider.
  String get id;
}

class _ArtistItemProviderElement
    extends AutoDisposeFutureProviderElement<BaseItemDto> with ArtistItemRef {
  _ArtistItemProviderElement(super.provider);

  @override
  String get id => (origin as ArtistItemProvider).id;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
