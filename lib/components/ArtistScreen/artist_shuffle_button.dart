import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:hive/hive.dart';


import '../../models/jellyfin_models.dart';
import '../../models/finamp_models.dart';
import '../../services/jellyfin_api_helper.dart';
import '../../services/audio_service_helper.dart';
import '../../services/finamp_settings_helper.dart';
import '../../services/downloads_helper.dart';

class ArtistShuffleButton extends StatefulWidget {
  const ArtistShuffleButton({
    Key? key,
    required this.artist,
  }) : super(key: key);

  final BaseItemDto artist;
  

  @override
  State<ArtistShuffleButton> createState() => _ArtistShuffleButtonState();
}

class _ArtistShuffleButtonState extends State<ArtistShuffleButton> {
  static const _disabledButton = IconButton(
    onPressed: null,
    icon: Icon(Icons.play_arrow)
    );
    Future<List<BaseItemDto>?>? artistShuffleButtonFuture;

    final _jellyfinApiHelper = GetIt.instance<JellyfinApiHelper>();
    final _audioServiceHelper = GetIt.instance<AudioServiceHelper>();


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
            
              return IconButton(
                onPressed: () async {
                  await _audioServiceHelper
                         .replaceQueueWithItem(itemList: artistsSongs, shuffle: true);
                },
                icon: const Icon(Icons.shuffle),
              );
          } else {
            artistShuffleButtonFuture ??= _jellyfinApiHelper.getItems(
              parentItem: widget.artist,
              includeItemTypes: "Audio",
              sortBy: 'PremiereDate,Album,SortName',
              isGenres: false,
            );

            return FutureBuilder<List<BaseItemDto>?>(
            future: artistShuffleButtonFuture,
            builder: (context, snapshot) {
              if (snapshot.hasData){
                final List<BaseItemDto> items = snapshot.data!;

                return IconButton(
                  onPressed: () async {
                    await _audioServiceHelper
                           .replaceQueueWithItem(itemList: items, shuffle: true, initialIndex: Random().nextInt(items.length));
                  }, 
                  icon: const Icon(Icons.shuffle),
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
