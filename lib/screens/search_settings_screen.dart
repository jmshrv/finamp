import 'dart:async';
import 'package:finamp/components/NetworkSettingsScreen/active_network_display.dart';
import 'package:finamp/l10n/app_localizations.dart';
import 'package:finamp/screens/settings_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fuzzy/fuzzy.dart';

class SettingsSearchDelegate extends SearchDelegate<String> {
  SettingsList settingsList;
  SettingsSearchDelegate({required this.settingsList});

  @override
  String get searchFieldLabel => 'Search settings...';

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
          showSuggestions(context);
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () => close(context, ''),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return _buildSearchResults();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return _buildSearchResults();
  }

  Widget _buildSearchResults() {
    final filteredSettings = _filterSettings(query);

    return ListView.builder(
      itemCount: filteredSettings.length,
      itemBuilder: (context, index) {
        final setting = filteredSettings[index];
        return ListTile(
          leading: Icon(setting.icon),
          title: setting.title != null
              ? _highlightText(setting.title!, query, context)
              : null,
          subtitle: setting.subtitle != null
              ? _highlightText(setting.subtitle!, query, context)
              : null,
          onTap: () {
            if (setting.onTap == null && setting.route != null) {
              Navigator.of(context).popAndPushNamed(setting.route!);
            } else {
              setting.onTap?.call();
            }
          },
        );
      },
    );
  }

  List<SettingsItem> _filterSettings(String query) {
    final lowercaseQuery = query.toLowerCase();
    List<SettingsItem> filteredSettings = [];
    Map<String, SettingsItem> categoriesSearchStrings = Map.fromEntries(
      settingsList.categoryItems.map(
        (e) => MapEntry((e.title ?? "") + (e.subtitle ?? ""), e),
      ),
    );
    if (query.isEmpty) {
      return settingsList.categoryItems + settingsList.settingsItems;
    }
    final fuzzyCategories = Fuzzy(categoriesSearchStrings.keys.toList());
    filteredSettings = fuzzyCategories
        .search(lowercaseQuery)
        .map((e) => categoriesSearchStrings[e.item]!)
        .toList();
    return filteredSettings;
  }

  // Helper method to highlight matching text
  Widget _highlightText(String text, String query, BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final colorScheme = theme.colorScheme;
    if (query.isEmpty) {
      return Text(text, style: textTheme.bodyLarge);
    }

    final lowercaseText = text.toLowerCase();
    final lowercaseQuery = query.toLowerCase();

    if (!lowercaseText.contains(lowercaseQuery)) {
      return Text(text, style: textTheme.bodyLarge);
    }

    final startIndex = lowercaseText.indexOf(lowercaseQuery);
    final endIndex = startIndex + query.length;

    return RichText(
      text: TextSpan(
        children: [
          TextSpan(text: text.substring(0, startIndex)),
          TextSpan(
            text: text.substring(startIndex, endIndex),
            style: textTheme.bodyLarge?.copyWith(color: colorScheme.primary),
          ),
          TextSpan(text: text.substring(endIndex)),
        ],
      ),
    );
  }
}
