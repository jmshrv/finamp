import 'package:finamp/models/finamp_models.dart';
import 'package:finamp/services/audio_service_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get_it/get_it.dart';

import '../../services/playback_history_service.dart';
import '../../models/jellyfin_models.dart' as jellyfin_models;
import '../album_image.dart';
import '../../services/process_artist.dart';

class PlaybackHistoryList extends StatelessWidget {
  const PlaybackHistoryList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final playbackHistoryService = GetIt.instance<PlaybackHistoryService>();
    final audioServiceHelper = GetIt.instance<AudioServiceHelper>();

    List<HistoryItem>? history;

    return Scrollbar(
      child: StreamBuilder<List<HistoryItem>>(
        stream: playbackHistoryService.historyStream,
        builder: (context, snapshot) {
          if (snapshot.hasData) {

            history = snapshot.data;
            
            return ListView.builder(
              itemCount: history!.length,
              reverse: true,
              padding: const EdgeInsets.only(bottom: 160.0),
              itemBuilder: (context, index) {
                // return ListTile(
                //   title: Text(history![index].item.item.title),
                //   subtitle: Text(history![index].item.item.artist!),
                // );
                return Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  child: ListTile(
                    visualDensity: VisualDensity.compact,
                    minVerticalPadding: 0.0,
                    contentPadding: const EdgeInsets.symmetric(vertical: 0.0, horizontal: 8.0),
                    leading: AlbumImage(
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(7.0),
                        bottomLeft: Radius.circular(7.0),
                      ),
                      item: history![index].item.item
                                  .extras?["itemJson"] == null
                              ? null
                              : jellyfin_models.BaseItemDto.fromJson(history![index].item.item.extras?["itemJson"]),
                    ),
                    title: Text(
                        history![index].item.item.title,
                    ),
                    subtitle: Text(processArtist(
                        history![index].item.item.artist,
                        context)),
                    trailing: Container(
                      alignment: Alignment.centerRight,
                      margin: const EdgeInsets.only(right: 0.0),
                      width: 95.0,
                      height: 50.0,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,  
                        children: [
                          Text(
                            "${history![index].item.item.duration?.inMinutes.toString().padLeft(2, '0')}:${((history![index].item.item.duration?.inSeconds ?? 0) % 60).toString().padLeft(2, '0')}",
                            textAlign: TextAlign.end,
                            style: TextStyle(
                              color: Theme.of(context).textTheme.bodySmall?.color,
                            ),
                          ),
                          IconButton(
                            icon: const Icon(TablerIcons.dots_vertical),
                            iconSize: 24.0,
                            onPressed: () async => {},
                          ),
                        ],
                      ),  
                    ),
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text(AppLocalizations.of(context)!.startingInstantMix),
                      ));

                      audioServiceHelper.startInstantMixForItem(jellyfin_models.BaseItemDto.fromJson(history![index].item.item.extras?["itemJson"])).catchError((e) {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text(AppLocalizations.of(context)!.anErrorHasOccured),
                        ));
                      });

                    }
                        // await _queueService.skipByOffset(indexOffset),
                  )
                );
              },
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}
