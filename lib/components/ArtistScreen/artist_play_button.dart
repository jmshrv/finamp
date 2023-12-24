import 'package:finamp/services/queue_service.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:hive/hive.dart';


import '../../models/jellyfin_models.dart';
import '../../models/finamp_models.dart';
import '../../services/isar_downloads.dart';
import '../../services/jellyfin_api_helper.dart';
import '../../services/audio_service_helper.dart';
import '../../services/finamp_settings_helper.dart';

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
          final isOffline = FinampSettingsHelper.finampSettings.isOffline ?? false;
          final isarDownloads = GetIt.instance<IsarDownloads>();

          if (isOffline) {

            artistPlayButtonFuture ??= Future.sync(() async {
              final List<DownloadStub> artistAlbums = await isarDownloads.getAllCollections(baseTypeFilter: BaseItemDtoType.album,relatedTo: widget.artist);
              // TODO see if the date format is correct for this to work.  Check placment of blanks.
              artistAlbums.sort((a,b) => (a.baseItem?.premiereDate??"").compareTo(b.baseItem!.premiereDate??""));

              final List<BaseItemDto> sortedSongs = [];
              for(var album in artistAlbums){
                sortedSongs.addAll(await isarDownloads.getCollectionSongs(album.baseItem!));
              }
              return sortedSongs;
            });
          } else {
            artistPlayButtonFuture ??= _jellyfinApiHelper.getItems(
              parentItem: widget.artist,
              includeItemTypes: "Audio",
              sortBy: 'PremiereDate,Album,SortName',
              isGenres: false,
            );
          }

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
        },
      );
    }
}
