import 'package:finamp/models/finamp_models.dart';
import 'package:finamp/models/jellyfin_models.dart';
import 'package:finamp/services/downloads_helper.dart';
import 'package:finamp/services/jellyfin_api_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get_it/get_it.dart';
import 'package:logging/logging.dart';

class SyncDownloadedPlaylistsButton extends StatelessWidget {
  SyncDownloadedPlaylistsButton({super.key});

  final _syncLogger = Logger("SyncDownloadedPlaylistsButton");
  final _downloadsHelper = GetIt.instance<DownloadsHelper>();
  final _jellyfinApiData = GetIt.instance<JellyfinApiHelper>();

  void syncPlaylists() async {
    _syncLogger.info("Syncing downloaded playlists");
    final parents = _downloadsHelper.downloadedParents.toList();
    final songs = _downloadsHelper.downloadedItems.toList();

    for (DownloadedParent parent in parents) {
      final children =
          parent.downloadedChildren.values.map((e) => e.id).toSet();
      final firstSong = songs.first;
      final items = await _jellyfinApiData.getItems(
        isGenres: false,
        parentItem: parent.item,
      );

      if (items == null) continue;

      for (BaseItemDto item in items) {
        _syncLogger.info(item.id.toString());
        final isInChildren = children.contains(item.id);

        if (isInChildren) {
          _syncLogger.info("Need sync download of ${item.id}");

          await _downloadsHelper.addDownloads(
            items: [item],
            parent: parent.item,
            useHumanReadableNames: firstSong.useHumanReadableNames,
            downloadLocation: firstSong.downloadLocation!,
            viewId: firstSong.viewId,
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () => syncPlaylists(),
      icon: const Icon(Icons.sync),
      tooltip: AppLocalizations.of(context)!.syncDownloadedPlaylists,
    );
  }
}