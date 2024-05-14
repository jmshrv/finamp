// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'favorite_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$isFavoriteHash() => r'72fb1365755e053a70b239dd1c5e757065af3104';

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
  late final String? itemId;
  late final DefaultValue value;

  bool build(
    String? itemId,
    DefaultValue value,
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
    String? itemId,
    DefaultValue value,
  ) {
    return IsFavoriteProvider(
      itemId,
      value,
    );
  }

  @override
  IsFavoriteProvider getProviderOverride(
    covariant IsFavoriteProvider provider,
  ) {
    return call(
      provider.itemId,
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
    String? itemId,
    DefaultValue value,
  ) : this._internal(
          () => IsFavorite()
            ..itemId = itemId
            ..value = value,
          from: isFavoriteProvider,
          name: r'isFavoriteProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$isFavoriteHash,
          dependencies: IsFavoriteFamily._dependencies,
          allTransitiveDependencies:
              IsFavoriteFamily._allTransitiveDependencies,
          itemId: itemId,
          value: value,
        );

  IsFavoriteProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.itemId,
    required this.value,
  }) : super.internal();

  final String? itemId;
  final DefaultValue value;

  @override
  bool runNotifierBuild(
    covariant IsFavorite notifier,
  ) {
    return notifier.build(
      itemId,
      value,
    );
  }

  @override
  Override overrideWith(IsFavorite Function() create) {
    return ProviderOverride(
      origin: this,
      override: IsFavoriteProvider._internal(
        () => create()
          ..itemId = itemId
          ..value = value,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        itemId: itemId,
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
    return other is IsFavoriteProvider &&
        other.itemId == itemId &&
        other.value == value;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, itemId.hashCode);
    hash = _SystemHash.combine(hash, value.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin IsFavoriteRef on AutoDisposeNotifierProviderRef<bool> {
  /// The parameter `itemId` of this provider.
  String? get itemId;

  /// The parameter `value` of this provider.
  DefaultValue get value;
}

class _IsFavoriteProviderElement
    extends AutoDisposeNotifierProviderElement<IsFavorite, bool>
    with IsFavoriteRef {
  _IsFavoriteProviderElement(super.provider);

  @override
  String? get itemId => (origin as IsFavoriteProvider).itemId;
  @override
  DefaultValue get value => (origin as IsFavoriteProvider).value;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
