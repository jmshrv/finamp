import 'package:flutter/material.dart';
import 'package:finamp/l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/finamp_models.dart';
import '../services/finamp_settings_helper.dart';

class GenreSettingsScreen extends StatefulWidget {
  const GenreSettingsScreen({super.key});
  static const routeName = "/settings/genre";
  @override
  State<GenreSettingsScreen> createState() => _GenreSettingsScreenState();
}

class _GenreSettingsScreenState extends State<GenreSettingsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.genreScreen),
        actions: [
          FinampSettingsHelper.makeSettingsResetButtonWithDialog(
              context, FinampSettingsHelper.resetLyricsSettings)
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(2.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListTile(
              title: Text(AppLocalizations.of(context)!.genreItemCurationType),
              subtitle: Text(AppLocalizations.of(context)!.genreItemCurationTypeSubtitle),
            ),
            const SizedBox(height: 8),
            const GenreCuratedItemsSelectionTypeSelector(isOffline: false),
            const SizedBox(height: 8),
            const GenreCuratedItemsSelectionTypeSelector(isOffline: true),
          ],
        ),
      ),
    );
  }
}

class GenreCuratedItemsSelectionTypeSelector extends ConsumerWidget {
  const GenreCuratedItemsSelectionTypeSelector({
    super.key,
    required this.isOffline,
  });

  final bool isOffline;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final value = isOffline
        ? ref.watch(finampSettingsProvider.genreCuratedItemSelectionTypeOffline)
        : ref.watch(finampSettingsProvider.genreCuratedItemSelectionTypeOnline);

    final onChanged = isOffline
        ? FinampSetters.setGenreCuratedItemSelectionTypeOffline.ifNonNull
        : FinampSetters.setGenreCuratedItemSelectionTypeOnline.ifNonNull;

    final label = isOffline
        ? AppLocalizations.of(context)!.offlineMode
        : AppLocalizations.of(context)!.onlineMode;

    final items = GenreCuratedItemSelectionType.values
        .where((e) => !(isOffline && e == GenreCuratedItemSelectionType.mostPlayed))
        .map(
          (e) => DropdownMenuItem<GenreCuratedItemSelectionType>(
            value: e,
            child: Text(e.toLocalisedString(context)),
          ),
        )
        .toList();

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 18),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              label,
              style: Theme.of(context).textTheme.labelMedium,
            ),
          ),
          DropdownButton<GenreCuratedItemSelectionType>(
            isExpanded: false,
            value: value,
            items: items,
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }
}

