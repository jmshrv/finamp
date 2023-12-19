import 'package:collection/collection.dart';
import 'package:finamp/models/finamp_models.dart';
import 'package:finamp/services/jellyfin_api.dart';
import 'package:finamp/services/jellyfin_api_helper.dart';
import 'package:finamp/services/queue_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get_it/get_it.dart';

import '../../models/jellyfin_models.dart';
import '../../services/audio_service_helper.dart';
import '../album_image.dart';
import 'artist_item_info.dart';

class ArtistScreenContentFlexibleSpaceBar extends StatelessWidget {
  const ArtistScreenContentFlexibleSpaceBar({
    Key? key,
    required this.parentItem,
    required this.isGenre,
    required this.allSongs,
    required this.albumCount,
  }) : super(key: key);

  final BaseItemDto parentItem;
  final bool isGenre;
  final Future<List<BaseItemDto>?> allSongs;
  final int albumCount;

  @override
  Widget build(BuildContext context) {
    GetIt.instance<AudioServiceHelper>();
    QueueService queueService = GetIt.instance<QueueService>();

    void playAllFromArtist(List<BaseItemDto> items) {
      queueService.startPlayback(
        items: items,
        source: QueueItemSource(
          type:
              isGenre ? QueueItemSourceType.genre : QueueItemSourceType.artist,
          name: QueueItemSourceName(
              type: QueueItemSourceNameType.preTranslated,
              pretranslatedName: parentItem.name ??
                  AppLocalizations.of(context)!.placeholderSource),
          id: parentItem.id,
          item: parentItem,
        ),
        order: FinampPlaybackOrder.linear,
      );
    }

    void shuffleAllFromArtist(List<BaseItemDto> items) {
      queueService.startPlayback(
        items: items,
        source: QueueItemSource(
          type:
              isGenre ? QueueItemSourceType.genre : QueueItemSourceType.artist,
          name: QueueItemSourceName(
              type: QueueItemSourceNameType.preTranslated,
              pretranslatedName: parentItem.name ??
                  AppLocalizations.of(context)!.placeholderSource),
          id: parentItem.id,
          item: parentItem,
        ),
        order: FinampPlaybackOrder.shuffled,
      );
    }

    void addArtistNext(List<BaseItemDto> items) {
      queueService.addNext(
          items: items,
          source: QueueItemSource(
            type: isGenre
                ? QueueItemSourceType.nextUpPlaylist
                : QueueItemSourceType.nextUpArtist,
            name: QueueItemSourceName(
                type: QueueItemSourceNameType.preTranslated,
                pretranslatedName: parentItem.name ??
                    AppLocalizations.of(context)!.placeholderSource),
            id: parentItem.id,
            item: parentItem,
          ));
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context)!
              .confirmPlayNext(isGenre ? "genre" : "artist")),
        ),
      );
    }

    void shuffleAlbumsFromArtist(List<BaseItemDto> items) {
      var songs =
          (items.groupListsBy((element) => element.albumId).values.toList()
                ..shuffle())
              .flattened
              .toList();

      queueService.startPlayback(
        items: songs,
        source: QueueItemSource(
          type:
              isGenre ? QueueItemSourceType.genre : QueueItemSourceType.artist,
          name: QueueItemSourceName(
              type: QueueItemSourceNameType.preTranslated,
              pretranslatedName: parentItem.name ??
                  AppLocalizations.of(context)!.placeholderSource),
          id: parentItem.id,
          item: parentItem,
        ),
        order: FinampPlaybackOrder.linear,
      );
    }

    return FlexibleSpaceBar(
      background: SafeArea(
        child: Align(
          alignment: Alignment.bottomCenter,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    SizedBox(
                      height: 125,
                      child: AlbumImage(item: parentItem),
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 4),
                    ),
                    FutureBuilder(
                      future: allSongs,
                      builder: (context, snapshot) => Expanded(
                        flex: 2,
                        child: ArtistItemInfo(
                          item: parentItem,
                          itemSongs: snapshot.data?.length ?? 0,
                          itemAlbums: albumCount,
                        ),
                      ),
                    )
                  ],
                ),
                // We don't want to add a whole genre to the queue
                if (!isGenre)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Column(
                      children: [
                        Row(children: [
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: () => allSongs.then(
                                  (items) => playAllFromArtist(items ?? [])),
                              icon: const Icon(Icons.play_arrow),
                              label: Text(AppLocalizations.of(context)!
                                  .playButtonLabel),
                            ),
                          ),
                          const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 8)),
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: () => allSongs.then(
                                  (items) => shuffleAllFromArtist(items ?? [])),
                              icon: const Icon(Icons.shuffle),
                              label: Text(AppLocalizations.of(context)!
                                  .shuffleButtonLabel),
                            ),
                          ),
                        ]),
                        Row(children: [
                          Expanded(
                            child: ElevatedButton.icon(
                              style: const ButtonStyle(
                                  visualDensity: VisualDensity.compact),
                              onPressed: () => allSongs
                                  .then((items) => addArtistNext(items ?? [])),
                              icon: const Icon(Icons.hourglass_bottom),
                              label:
                                  Text(AppLocalizations.of(context)!.playNext),
                            ),
                          ),
                          const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 8)),
                          Expanded(
                            child: ElevatedButton.icon(
                              style: const ButtonStyle(
                                  visualDensity: VisualDensity.compact),
                              onPressed: () => allSongs.then((items) =>
                                  shuffleAlbumsFromArtist(items ?? [])),
                              icon: const Icon(Icons.album),
                              label: Text(
                                  AppLocalizations.of(context)!.shuffleAlbums),
                            ),
                          ),
                        ])
                      ],
                    ),
                  )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
