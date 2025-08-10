// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: deprecated_member_use_from_same_package

// dart format off


part of 'public_address_selector.dart';

// **************************************************************************
// _SearchableGenerator
// **************************************************************************

extension PublicAddressSelectorSearchable on PublicAddressSelector {
  String getSearchableContent(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    return [
      l.preferLocalNetworkPublicAddressSettingTitle is String
          ? l.preferLocalNetworkPublicAddressSettingTitle
          : l.preferLocalNetworkPublicAddressSettingTitle.toString(),
      l.preferLocalNetworkPublicAddressSettingDescription is String
          ? l.preferLocalNetworkPublicAddressSettingDescription
          : l.preferLocalNetworkPublicAddressSettingDescription.toString(),
      l.missingSchemaError is String
          ? l.missingSchemaError
          : l.missingSchemaError.toString(),
    ].where((text) => text.isNotEmpty).join(' ').toLowerCase();
  }
}
