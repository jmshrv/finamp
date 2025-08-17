// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: deprecated_member_use_from_same_package

// dart format off


part of 'layout_settings_screen.dart';

// **************************************************************************
// _SearchableGenerator
// **************************************************************************

extension AllowSplitScreenSwitchSearchable on AllowSplitScreenSwitch {
  String getSearchableContent(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final searchableTexts = <String>[
      _safeToString(l.allowSplitScreenTitle),
      _safeToString(l.allowSplitScreenSubtitle),
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

extension FixedSizeGridSwitchSearchable on FixedSizeGridSwitch {
  String getSearchableContent(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final searchableTexts = <String>[
      _safeToString(l.fixedGridSizeSwitchTitle),
      _safeToString(l.fixedGridSizeSwitchSubtitle),
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

extension ShowProgressOnNowPlayingBarToggleSearchable
    on ShowProgressOnNowPlayingBarToggle {
  String getSearchableContent(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final searchableTexts = <String>[
      _safeToString(l.showProgressOnNowPlayingBarTitle),
      _safeToString(l.showProgressOnNowPlayingBarSubtitle),
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
