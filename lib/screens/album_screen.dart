import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get_it/get_it.dart';
import 'package:hive/hive.dart';

import '../components/AlbumScreen/album_screen_content.dart';
import '../components/now_playing_bar.dart';
import '../components/padded_custom_scrollview.dart';
import '../models/finamp_models.dart';
import '../models/jellyfin_models.dart';
import '../services/downloads_service.dart';
import '../services/finamp_settings_helper.dart';
import '../services/jellyfin_api_helper.dart';
import '../services/music_player_background_task.dart';

class AlbumScreen extends StatefulWidget {
  const AlbumScreen({
    Key? key,
    this.parent,
  }) : super(key: key);

  static const routeName = "/music/album";

  /// The album to show. Can also be provided as an argument in a named route
  final BaseItemDto? parent;

  @override
  State<AlbumScreen> createState() => _AlbumScreenState();
}

class _AlbumScreenState extends State<AlbumScreen> {
  Future<List<List<BaseItemDto>?>>? albumScreenContentFuture;
  JellyfinApiHelper jellyfinApiHelper = GetIt.instance<JellyfinApiHelper>();
  final audioHandler = GetIt.instance<MusicPlayerBackgroundTask>();

  @override
  Widget build(BuildContext context) {
    final BaseItemDto parent = widget.parent ??
        ModalRoute.of(context)!.settings.arguments as BaseItemDto;

    return Scaffold(
      extendBody: true,
      body: ValueListenableBuilder<Box<FinampSettings>>(
          valueListenable: FinampSettingsHelper.finampSettingsListener,
          builder: (context, box, widget) {
            bool isOffline = box.get("FinampSettings")?.isOffline ?? false;

            if (isOffline) {
              final downloadsService = GetIt.instance<DownloadsService>();
              // This is a pretty messy way to do this, but we already need both a
              // display list and a queue-able list inside AlbumScreenContent to deal
              // with multi-disc albums, so creating that distinction here seems fine.
              albumScreenContentFuture ??= Future.wait([
                downloadsService.getCollectionSongs(parent, playable: false),
                downloadsService.getCollectionSongs(parent, playable: true)
              ]);
            } else {
              if (albumScreenContentFuture == null) {
                var future = jellyfinApiHelper.getItems(
                  parentItem: parent,
                  sortBy: "ParentIndexNumber,IndexNumber,SortName",
                  includeItemTypes: "Audio",
                );
                albumScreenContentFuture = Future.wait([future, future]);
              }
            }

            return FutureBuilder<List<List<BaseItemDto>?>>(
              future: albumScreenContentFuture,
              builder: (context, snapshot) {
                if (snapshot.data
                    case [
                      List<BaseItemDto> items,
                      List<BaseItemDto> playableItems
                    ]) {
                  return AlbumScreenContent(
                      parent: parent,
                      displayChildren: items,
                      queueChildren: playableItems);
                } else if (snapshot.hasError) {
                  return PaddedCustomScrollview(
                    physics: const NeverScrollableScrollPhysics(),
                    slivers: [
                      SliverAppBar(
                        title: Text(AppLocalizations.of(context)!.error),
                      ),
                      SliverFillRemaining(
                        child: Center(child: Text(snapshot.error.toString())),
                      )
                    ],
                  );
                } else {
                  // We return all of this so that we can have an app bar while loading.
                  // This is especially important for iOS, where there isn't a hardware back button.
                  return PaddedCustomScrollview(
                    physics: const NeverScrollableScrollPhysics(),
                    slivers: [
                      SliverAppBar(
                        title: Text(parent.name ??
                            AppLocalizations.of(context)!.unknownName),
                      ),
                      const SliverFillRemaining(
                        child: Center(
                          child: CircularProgressIndicator.adaptive(),
                        ),
                      )
                    ],
                  );
                }
              },
            );
          }),
      bottomNavigationBar: const NowPlayingBar(),
    );
  }
}
