// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: deprecated_member_use_from_same_package

// dart format off


part of 'prefer_local_network_address_selector.dart';

// **************************************************************************
// _SearchableGenerator
// **************************************************************************

extension LocalNetworkAddressSelectorSearchable on LocalNetworkAddressSelector {
  String getSearchableContent(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final searchableTexts = <String>[
      _safeToString(l.preferLocalNetworkTargetAddressLocalSettingTitle),
      _safeToString(l.preferLocalNetworkTargetAddressLocalSettingDescription),
      _safeToString(l.missingSchemaError),
    ];
    return searchableTexts
        .where((text) => text.isNotEmpty)
        .join(' ')
        .toLowerCase();
  }

  String _safeToString(dynamic value) {
    if (value == null) return '';
    if (value is String) return value;
    return value.toString();
  }
}
