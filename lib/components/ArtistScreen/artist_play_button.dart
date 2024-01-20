import 'package:finamp/services/queue_service.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:hive/hive.dart';


import '../../models/jellyfin_models.dart';
import '../../models/finamp_models.dart';
import '../../services/jellyfin_api_helper.dart';
import '../../services/audio_service_helper.dart';
import '../../services/finamp_settings_helper.dart';
import '../../services/downloads_helper.dart';

class ArtistPlayButton extends StatefulWidget {
  const ArtistPlayButton({
    Key? key,
    required this.artist,
  }) : super(key: key);

  final BaseItemDto artist;
  

  @override
  State<ArtistPlayButton> createState() => _ArtistPlayButtonState();
}

class _ArtistPlayButtonState extends State<ArtistPlayButton> {
  static const _disabledButton = IconButton(
    onPressed: null,
    icon: Icon(Icons.play_arrow)
    );
    Future<List<BaseItemDto>?>? artistPlayButtonFuture;

    final _jellyfinApiHelper = GetIt.instance<JellyfinApiHelper>();
    final _audioServiceHelper = GetIt.instance<AudioServiceHelper>();
    final _queueService = GetIt.instance<QueueService>();

    @override
    Widget build(BuildContext context) {
      return ValueListenableBuilder<Box<FinampSettings>>(
        valueListenable: FinampSettingsHelper.finampSettingsListener,
        builder: (context, box, _) {
          final isOffline = box.get("FinampSettings")?.isOffline ?? false;

          if (isOffline) {
             final downloadsHelper = GetIt.instance<DownloadsHelper>();

             final List<BaseItemDto>artistsSongs = [];

             for (DownloadedSong item in downloadsHelper.downloadedItems) {
              if (item.song.albumArtist == widget.artist.name) {
                artistsSongs.add(item.song);
              }
             }
            
             // We have to sort by hand in offline mode because a downloadedParent for artists hasn't been implemented
             Map<String, List<BaseItemDto>> groupedSongs = {};
             for (BaseItemDto song in artistsSongs) {
              groupedSongs.putIfAbsent((song.albumId ?? 'unknown'), () => []);
              groupedSongs[song.albumId]!.add(song);
             }

             final List<BaseItemDto> sortedSongs = [];
             groupedSongs.forEach((album, albumSongs) {
               albumSongs.sort((a, b) => (a.indexNumber ?? 0).compareTo(b.indexNumber ?? 0));
               sortedSongs.addAll(albumSongs);
             });

              return IconButton(
                onPressed: () async {
                  await _queueService.startPlayback(items: sortedSongs, source: QueueItemSource(type: QueueItemSourceType.artist, name: QueueItemSourceName(type: QueueItemSourceNameType.preTranslated, pretranslatedName: widget.artist.name), id: widget.artist.id));
                },
                icon: const Icon(Icons.play_arrow),
              );
          } else {
            artistPlayButtonFuture ??= _jellyfinApiHelper.getItems(
            parentItem: widget.artist,
            includeItemTypes: "Audio",
            sortBy: 'PremiereDate,Album,SortName',
            isGenres: false,
            );

            return FutureBuilder<List<BaseItemDto>?>(
            future: artistPlayButtonFuture,
            builder: (context, snapshot) {
              if (snapshot.hasData){
                final List<BaseItemDto> items = snapshot.data!;

                return IconButton(
                  onPressed: () async {
                    await _queueService.startPlayback(items: items, source: QueueItemSource(type: QueueItemSourceType.artist, name: QueueItemSourceName(type: QueueItemSourceNameType.preTranslated, pretranslatedName: widget.artist.name), id: widget.artist.id));
                  }, 
                  icon: const Icon(Icons.play_arrow),
                  );
              } else {
                return _disabledButton;
              }
            },
          );
         }
        },
      );
    }
}
