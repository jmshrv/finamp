// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: deprecated_member_use_from_same_package

// dart format off


part of 'show_text_on_grid_view_selector.dart';

// **************************************************************************
// _SearchableGenerator
// **************************************************************************

extension ShowTextOnGridViewSelectorSearchable on ShowTextOnGridViewSelector {
  String getSearchableContent(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    return [
      l.showTextOnGridView is String
          ? l.showTextOnGridView
          : l.showTextOnGridView.toString(),
      l.showTextOnGridViewSubtitle is String
          ? l.showTextOnGridViewSubtitle
          : l.showTextOnGridViewSubtitle.toString(),
    ].where((text) => text.isNotEmpty).join(' ').toLowerCase();
  }
}
