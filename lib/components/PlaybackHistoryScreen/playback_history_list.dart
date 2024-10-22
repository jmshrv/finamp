import 'package:finamp/components/AlbumScreen/track_list_tile.dart';
import 'package:finamp/components/global_snackbar.dart';
import 'package:finamp/models/finamp_models.dart';
import 'package:finamp/services/audio_service_helper.dart';
import 'package:finamp/services/locale_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';

import '../../models/jellyfin_models.dart' as jellyfin_models;
import '../../services/playback_history_service.dart';
import 'playback_history_list_tile.dart';

class PlaybackHistoryList extends StatelessWidget {
  const PlaybackHistoryList({super.key});

  @override
  Widget build(BuildContext context) {
    final playbackHistoryService = GetIt.instance<PlaybackHistoryService>();
    final audioServiceHelper = GetIt.instance<AudioServiceHelper>();

    List<FinampHistoryItem>? history;
    List<MapEntry<DateTime, List<FinampHistoryItem>>> groupedHistory;

    return StreamBuilder<List<FinampHistoryItem>>(
        stream: playbackHistoryService.historyStream,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            history = snapshot.data;
            groupedHistory =
                playbackHistoryService.getHistoryGroupedDynamically();

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
                        // child: PlaybackHistoryListTile(
                        //   actualIndex: actualIndex,
                        //   item: group.value[actualIndex],
                        //   audioServiceHelper: audioServiceHelper,
                        //   onTap: () {
                        //     GlobalSnackbar.message(
                        //       (scaffold) => AppLocalizations.of(context)!
                        //           .startingInstantMix,
                        //       isConfirmation: true,
                        //     );

                        //     audioServiceHelper
                        //         .startInstantMixForItem(
                        //             jellyfin_models.BaseItemDto.fromJson(group
                        //                 .value[actualIndex]
                        //                 .item
                        //                 .item
                        //                 .extras?["itemJson"]))
                        //         .catchError((e) {
                        //       GlobalSnackbar.error(e);
                        //     });
                        //   },
                        // ),
                        child: TrackListTile(
                          index: Future.value(actualIndex),
                          item: group.value[actualIndex].item.baseItem!,
                        ),
                      );

                      final now = DateTime.now();
                      final String? localeString = LocaleHelper.localeString;

                      return index == 0
                          ? Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 16.0, top: 8.0, bottom: 4.0),
                                  child: Text(
                                    (group.key.year == now.year &&
                                            group.key.month == now.month &&
                                            group.key.day == now.day)
                                        ? (group.key.hour == now.hour
                                            ? DateFormat.jm(localeString)
                                                .format(group.key)
                                            : DateFormat.j(localeString)
                                                .format(group.key))
                                        : DateFormat.MMMMd(localeString)
                                            .format(group.key),
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
