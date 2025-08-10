// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: deprecated_member_use_from_same_package

// dart format off


part of 'active_network_display.dart';

// **************************************************************************
// _SearchableGenerator
// **************************************************************************

extension ActiveNetworkDisplaySearchable on ActiveNetworkDisplay {
  String getSearchableContent(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    return [
      l.preferLocalNetworkActiveAddressInfoText is String
          ? l.preferLocalNetworkActiveAddressInfoText
          : l.preferLocalNetworkActiveAddressInfoText.toString(),
    ].where((text) => text.isNotEmpty).join(' ').toLowerCase();
  }
}
