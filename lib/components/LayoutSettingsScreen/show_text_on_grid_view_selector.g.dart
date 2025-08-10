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
      l.showTextOnGridView,
      l.showTextOnGridViewSubtitle,
    ].where((text) => text.isNotEmpty).join(' ').toLowerCase();
  }
}
