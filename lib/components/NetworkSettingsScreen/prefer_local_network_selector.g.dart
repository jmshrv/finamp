// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: deprecated_member_use_from_same_package

// dart format off


part of 'prefer_local_network_selector.dart';

// **************************************************************************
// _SearchableGenerator
// **************************************************************************

extension LocalNetworkSelectorSearchable on LocalNetworkSelector {
  String getSearchableContent(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    return [
      l.preferLocalNetworkEnableSwitchTitle is String
          ? l.preferLocalNetworkEnableSwitchTitle
          : l.preferLocalNetworkEnableSwitchTitle.toString(),
      l.preferLocalNetworkEnableSwitchDescription is String
          ? l.preferLocalNetworkEnableSwitchDescription
          : l.preferLocalNetworkEnableSwitchDescription.toString(),
    ].where((text) => text.isNotEmpty).join(' ').toLowerCase();
  }
}
