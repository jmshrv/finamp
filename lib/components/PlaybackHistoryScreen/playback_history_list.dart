import 'package:finamp/models/finamp_models.dart';
import 'package:finamp/services/audio_service_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get_it/get_it.dart';

import '../../services/playback_history_service.dart';
import '../../models/jellyfin_models.dart' as jellyfin_models;
import 'playback_history_list_tile.dart';

class PlaybackHistoryList extends StatelessWidget {
  const PlaybackHistoryList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final playbackHistoryService = GetIt.instance<PlaybackHistoryService>();
    final audioServiceHelper = GetIt.instance<AudioServiceHelper>();

    List<HistoryItem>? history;
    List<MapEntry<DateTime, List<HistoryItem>>> groupedHistory;

    return StreamBuilder<List<HistoryItem>>(
        stream: playbackHistoryService.historyStream,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            history = snapshot.data;
            // groupedHistory = playbackHistoryService.getHistoryGroupedByDate();
            groupedHistory = playbackHistoryService.getHistoryGroupedByHour();

            print(groupedHistory);

            return CustomScrollView(
              // use nested SliverList.builder()s to show history items grouped by date
              slivers: groupedHistory.map((group) {
                return SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final actualIndex = group.value.length - index - 1;

                      final historyItem = Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        child: PlaybackHistoryListTile(
                          actualIndex: actualIndex,
                          item: group.value[actualIndex],
                          audioServiceHelper: audioServiceHelper,
                          onTap: () {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text(AppLocalizations.of(context)!
                                  .startingInstantMix),
                            ));

                            audioServiceHelper
                                .startInstantMixForItem(
                                    jellyfin_models.BaseItemDto.fromJson(group
                                        .value[actualIndex]
                                        .item
                                        .item
                                        .extras?["itemJson"]))
                                .catchError((e) {
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(SnackBar(
                                content: Text(AppLocalizations.of(context)!
                                    .anErrorHasOccured),
                              ));
                            });
                          },
                        ),
                      );

                      return index == 0
                          ? Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 16.0, top: 8.0, bottom: 4.0),
                                  child: Text(
                                    "${group.key.hour % 12} ${group.key.hour >= 12 ? "pm" : "am"}",
                                    style: const TextStyle(
                                      fontSize: 16.0,
                                    ),
                                  ),
                                ),
                                historyItem,
                              ],
                            )
                          : historyItem;
                    },
                    childCount: group.value.length,
                  ),
                );
              }).toList(),
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        });
  }
}
