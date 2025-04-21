import 'package:finamp/services/finamp_settings_helper.dart';
import 'package:flutter/material.dart';
import 'package:finamp/l10n/app_localizations.dart';


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
              context, FinampSettingsHelper.resetGenreSettings)
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(2.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListTile(
              title: Text(AppLocalizations.of(context)!.genreItemSectionsOrder),
              subtitle: Text(AppLocalizations.of(context)!.genreItemSectionsOrderSubtitle),
            ),
            Expanded( 
              child: ReorderableListView.builder(
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
                  // It's a bit of a hack to call setState with no actual widget
                  // state, but it saves us from using listeners
                  setState(() {
                    // For some weird reason newIndex is one above what it should be
                    // when oldIndex is lower. This if statement is in Flutter's
                    // ReorderableListView documentation.
                    if (oldIndex < newIndex) {
                      newIndex -= 1;
                    }

                    var currentGenreItemSectionsOrder = FinampSettingsHelper.finampSettings.genreItemSectionsOrder;

                    // move all values below newIndex down by one
                    final oldTab = currentGenreItemSectionsOrder[oldIndex];
                    currentGenreItemSectionsOrder.removeAt(oldIndex);
                    currentGenreItemSectionsOrder.insert(newIndex, oldTab);
                    FinampSetters.setGenreItemSectionsOrder(currentGenreItemSectionsOrder);
                  });
                }
              ),
            ),
          ]
        ),
      ),
    );
  }
}
