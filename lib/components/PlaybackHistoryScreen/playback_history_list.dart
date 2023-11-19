import 'package:finamp/models/finamp_models.dart';
import 'package:finamp/services/audio_service_helper.dart';
import 'package:finamp/services/locale_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';

import '../../services/playback_history_service.dart';
import '../../models/jellyfin_models.dart' as jellyfin_models;
import 'playback_history_list_tile.dart';

class PlaybackHistoryList extends StatelessWidget {
  const PlaybackHistoryList({Key? key}) : super(key: key);

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
            // groupedHistory = playbackHistoryService.getHistoryGroupedByDate();
            // groupedHistory = playbackHistoryService.getHistoryGroupedByHour();
            groupedHistory =
                playbackHistoryService.getHistoryGroupedDynamically();

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

                      final now = DateTime.now();
                      final String localeString = (LocaleHelper.locale != null)
                          ? ((LocaleHelper.locale?.countryCode != null)
                              ? "${LocaleHelper.locale?.languageCode.toLowerCase()}_${LocaleHelper.locale?.countryCode?.toUpperCase()}"
                              : LocaleHelper.locale.toString())
                          : "en_US";

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
