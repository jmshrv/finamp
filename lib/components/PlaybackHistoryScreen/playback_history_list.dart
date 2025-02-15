import 'package:finamp/components/AlbumScreen/track_list_tile.dart';
import 'package:finamp/models/finamp_models.dart';
import 'package:finamp/services/audio_service_helper.dart';
import 'package:finamp/services/locale_helper.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';

import '../../services/playback_history_service.dart';
import '../padded_custom_scrollview.dart';

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

            return PaddedCustomScrollview(
              // use nested SliverList.builder()s to show history items grouped by date
              slivers: groupedHistory.indexed.map((indexedGroup) {
                final groupIndex = indexedGroup.$1;
                final group = indexedGroup.$2;
                return SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final actualIndex = group.value.length - index - 1;

                      final historyItem = TrackListTile(
                        index: Future.value(actualIndex),
                        item: group.value[actualIndex].item.baseItem!,
                        highlightCurrentTrack: groupIndex == 0 &&
                            index == 0, // only highlight first track
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
