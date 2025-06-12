import 'package:finamp/models/finamp_models.dart';
import 'package:finamp/services/finamp_settings_helper.dart';
import 'package:flutter/material.dart';
import 'package:finamp/l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


class ArtistSettingsScreen extends ConsumerStatefulWidget {
  const ArtistSettingsScreen({super.key});
  static const routeName = "/settings/artist";
  @override
  ConsumerState<ArtistSettingsScreen> createState() => _ArtistSettingsScreenState();
}

class _ArtistSettingsScreenState extends ConsumerState<ArtistSettingsScreen> {
  @override
  Widget build(BuildContext context) {
    final showArtistsTracksSection = ref.watch(finampSettingsProvider.showArtistsTracksSection);
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.artistScreen),
        actions: [
          FinampSettingsHelper.makeSettingsResetButtonWithDialog(
              context, FinampSettingsHelper.resetArtistSettings)
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
                  title: Text(AppLocalizations.of(context)!.itemSectionsOrder),
                  subtitle: Text(AppLocalizations.of(context)!.itemSectionsOrderSubtitle),
                ),
                ReorderableListView.builder(
                  buildDefaultDragHandles: false,
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: FinampSettingsHelper.finampSettings.artistItemSectionsOrder.length,
                  itemBuilder: (context, index) {
                    final section = FinampSettingsHelper.finampSettings.artistItemSectionsOrder[index];
                    final isTracksSection = section == ArtistItemSections.tracks;
                    final showTracks = ref.watch(finampSettingsProvider.showArtistsTracksSection);
                    return Opacity(
                      opacity: (isTracksSection && !showTracks) ? 0.4 : 1.0,
                      key: ValueKey(FinampSettingsHelper.finampSettings.artistItemSectionsOrder[index]),
                      child: ReorderableDelayedDragStartListener(
                        index: index,
                        child: ListTile(
                          title: Text(section.toLocalisedString(context)),
                          leading: ReorderableDragStartListener(
                            index: index,
                            child: const Icon(Icons.drag_handle),
                          ),
                        ),
                      ),
                    );
                  },
                  onReorder: (oldIndex, newIndex) {
                    setState(() {
                      if (oldIndex < newIndex) newIndex -= 1;
                      final currentOrder = List.of(FinampSettingsHelper.finampSettings.artistItemSectionsOrder);
                      final movedItem = currentOrder.removeAt(oldIndex);
                      currentOrder.insert(newIndex, movedItem);
                      FinampSetters.setArtistItemSectionsOrder(currentOrder);
                    });
                  }
                ),
              ]
            ),
            SizedBox(height: 8),
            SwitchListTile.adaptive(
              title: Text(AppLocalizations.of(context)!.showArtistsTracksSection),
              subtitle:
                  Text(AppLocalizations.of(context)!.showArtistsTracksSectionSubtitle),
              value: showArtistsTracksSection,
              onChanged: (value) => FinampSetters.setShowArtistsTracksSection(value),
            ),
            SizedBox(height: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ListTile(
                  title: Text(AppLocalizations.of(context)!.artistItemSectionFilterChipOrderTitle),
                  subtitle: Text(AppLocalizations.of(context)!.artistItemSectionFilterChipOrderSubtitle),
                ),
                ReorderableListView.builder(
                  buildDefaultDragHandles: false,
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: FinampSettingsHelper.finampSettings.artistItemSectionFilterChipOrder.length,
                  itemBuilder: (context, index) {
                    return ReorderableDelayedDragStartListener(
                      key: ValueKey(FinampSettingsHelper.finampSettings.artistItemSectionFilterChipOrder[index]),
                      index: index,
                      child: ListTile(
                        title: Text(FinampSettingsHelper.finampSettings.artistItemSectionFilterChipOrder[index].toLocalisedString(context)),
                        leading: ReorderableDragStartListener(
                          index: index,
                          child: const Icon(Icons.drag_handle),
                        ),
                      ),
                    );
                  },
                  onReorder: (oldIndex, newIndex) {
                    setState(() {
                      if (oldIndex < newIndex) newIndex -= 1;
                      final currentOrder = List.of(FinampSettingsHelper.finampSettings.artistItemSectionFilterChipOrder);
                      final movedItem = currentOrder.removeAt(oldIndex);
                      currentOrder.insert(newIndex, movedItem);
                      FinampSetters.setArtistItemSectionFilterChipOrder(currentOrder);
                    });
                  }
                ),
              ]
            ),
            SizedBox(height: 20),
          ]
        ),
      ),
    );
  }
}
