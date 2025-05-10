import 'package:finamp/models/finamp_models.dart';
import 'package:finamp/services/finamp_settings_helper.dart';
import 'package:flutter/material.dart';
import 'package:finamp/l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


class GenreSettingsScreen extends ConsumerStatefulWidget {
  const GenreSettingsScreen({super.key});
  static const routeName = "/settings/genre";
  @override
  ConsumerState<GenreSettingsScreen> createState() => _GenreSettingsScreenState();
}

class _GenreSettingsScreenState extends ConsumerState<GenreSettingsScreen> {
  @override
  Widget build(BuildContext context) {
    var genreMostPlayedOfflineFallbackValue = ref.watch(finampSettingsProvider.genreMostPlayedOfflineFallback);
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.genreScreen),
        actions: [
          FinampSettingsHelper.makeSettingsResetButtonWithDialog(
              context, FinampSettingsHelper.resetGenreSettings)
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(2.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ListTile(
                  title: Text(AppLocalizations.of(context)!.genreItemSectionsOrder),
                  subtitle: Text(AppLocalizations.of(context)!.genreItemSectionsOrderSubtitle),
                ),
                ReorderableListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: FinampSettingsHelper.finampSettings.genreItemSectionsOrder.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      key: ValueKey(FinampSettingsHelper.finampSettings.genreItemSectionsOrder[index]),
                      title: Text(FinampSettingsHelper.finampSettings.genreItemSectionsOrder[index].toLocalisedString(context)),
                      leading: ReorderableDragStartListener(
                        index: index,
                        child: const Icon(Icons.drag_handle),
                      ),
                    );
                  },
                  onReorder: (oldIndex, newIndex) {
                    setState(() {
                      if (oldIndex < newIndex) newIndex -= 1;
                      final currentOrder = List.of(FinampSettingsHelper.finampSettings.genreItemSectionsOrder);
                      final movedItem = currentOrder.removeAt(oldIndex);
                      currentOrder.insert(newIndex, movedItem);
                      FinampSetters.setGenreItemSectionsOrder(currentOrder);
                    });
                  }
                ),
              ]
            ),
            SizedBox(height: 12),
            SwitchListTile.adaptive(
              title: Text(AppLocalizations.of(context)!.genreFilterArtistScreens),
              subtitle: Text(AppLocalizations.of(context)!.genreFilterArtistScreensSubtitle),
              value: ref.watch(finampSettingsProvider.genreFilterArtistScreens),
              onChanged: FinampSetters.setGenreFilterArtistScreens,
            ),
            SizedBox(height: 8),
            SwitchListTile.adaptive(
              title: Text(AppLocalizations.of(context)!.genreListsInheritSorting),
              subtitle: Text(AppLocalizations.of(context)!.genreListsInheritSortingSubtitle),
              value: ref.watch(finampSettingsProvider.genreListsInheritSorting),
              onChanged: FinampSetters.setGenreListsInheritSorting,
            ),
            SizedBox(height: 8),
            ListTile(
              title: Text(AppLocalizations.of(context)!.genreMostPlayedOfflineFallback),
              subtitle:
                  Text(AppLocalizations.of(context)!.genreMostPlayedOfflineFallbackSubtitle),
              trailing: DropdownButton<CuratedItemSelectionType>(
                  value: genreMostPlayedOfflineFallbackValue,
                  items: CuratedItemSelectionType.values
                      .where((e) => e != CuratedItemSelectionType.mostPlayed)
                      .map((e) => DropdownMenuItem<CuratedItemSelectionType>(
                            value: e,
                            child: Text(e.toLocalisedString(context)),
                          ))
                      .toList(),
                  onChanged: (value) {
                    if (value != null) {
                      FinampSetters.setGenreMostPlayedOfflineFallback(value);
                    }
                  },
                ),
            ),
            SizedBox(height: 16),
          ]
        ),
      ),
    );
  }
}
