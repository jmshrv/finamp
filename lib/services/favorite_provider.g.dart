// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'favorite_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$isFavoriteHash() => r'4c20e32cb59b9ae69ad7cfc9f79ae1061ecae760';

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

abstract class _$IsFavorite extends BuildlessAutoDisposeNotifier<bool> {
  late final FavoriteRequest value;

  bool build(
    FavoriteRequest value,
  );
}

/// See also [IsFavorite].
@ProviderFor(IsFavorite)
const isFavoriteProvider = IsFavoriteFamily();

/// See also [IsFavorite].
class IsFavoriteFamily extends Family<bool> {
  /// See also [IsFavorite].
  const IsFavoriteFamily();

  /// See also [IsFavorite].
  IsFavoriteProvider call(
    FavoriteRequest value,
  ) {
    return IsFavoriteProvider(
      value,
    );
  }

  @override
  IsFavoriteProvider getProviderOverride(
    covariant IsFavoriteProvider provider,
  ) {
    return call(
      provider.value,
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
  String? get name => r'isFavoriteProvider';
}

/// See also [IsFavorite].
class IsFavoriteProvider
    extends AutoDisposeNotifierProviderImpl<IsFavorite, bool> {
  /// See also [IsFavorite].
  IsFavoriteProvider(
    FavoriteRequest value,
  ) : this._internal(
          () => IsFavorite()..value = value,
          from: isFavoriteProvider,
          name: r'isFavoriteProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$isFavoriteHash,
          dependencies: IsFavoriteFamily._dependencies,
          allTransitiveDependencies:
              IsFavoriteFamily._allTransitiveDependencies,
          value: value,
        );

  IsFavoriteProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.value,
  }) : super.internal();

  final FavoriteRequest value;

  @override
  bool runNotifierBuild(
    covariant IsFavorite notifier,
  ) {
    return notifier.build(
      value,
    );
  }

  @override
  Override overrideWith(IsFavorite Function() create) {
    return ProviderOverride(
      origin: this,
      override: IsFavoriteProvider._internal(
        () => create()..value = value,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        value: value,
      ),
    );
  }

  @override
  AutoDisposeNotifierProviderElement<IsFavorite, bool> createElement() {
    return _IsFavoriteProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is IsFavoriteProvider && other.value == value;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, value.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin IsFavoriteRef on AutoDisposeNotifierProviderRef<bool> {
  /// The parameter `value` of this provider.
  FavoriteRequest get value;
}

class _IsFavoriteProviderElement
    extends AutoDisposeNotifierProviderElement<IsFavorite, bool>
    with IsFavoriteRef {
  _IsFavoriteProviderElement(super.provider);

  @override
  FavoriteRequest get value => (origin as IsFavoriteProvider).value;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
