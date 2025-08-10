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
    return [
      l.preferLocalNetworkTargetAddressLocalSettingTitle is String
          ? l.preferLocalNetworkTargetAddressLocalSettingTitle
          : l.preferLocalNetworkTargetAddressLocalSettingTitle.toString(),
      l.preferLocalNetworkTargetAddressLocalSettingDescription is String
          ? l.preferLocalNetworkTargetAddressLocalSettingDescription
          : l.preferLocalNetworkTargetAddressLocalSettingDescription.toString(),
      l.missingSchemaError is String
          ? l.missingSchemaError
          : l.missingSchemaError.toString(),
    ].where((text) => text.isNotEmpty).join(' ').toLowerCase();
  }
}
