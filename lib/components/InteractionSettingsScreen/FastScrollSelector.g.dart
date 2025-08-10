// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: deprecated_member_use_from_same_package

// dart format off


part of 'FastScrollSelector.dart';

// **************************************************************************
// _SearchableGenerator
// **************************************************************************

extension FastScrollSelectorSearchable on FastScrollSelector {
  String getSearchableContent(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    return [
      l.showFastScroller is String
          ? l.showFastScroller
          : l.showFastScroller.toString(),
    ].where((text) => text.isNotEmpty).join(' ').toLowerCase();
  }
}
