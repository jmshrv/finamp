import 'package:finamp/models/finamp_models.dart';
import 'package:finamp/models/jellyfin_models.dart';
import 'package:finamp/services/downloads_helper.dart';
import 'package:finamp/services/jellyfin_api_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:get_it/get_it.dart';
import 'package:logging/logging.dart';

class SyncDownloadedPlaylistsButton extends StatefulWidget {
  const SyncDownloadedPlaylistsButton({super.key});

  @override
  State<SyncDownloadedPlaylistsButton> createState() =>
      _SyncDownloadedPlaylistsButtonState();
}

class _SyncDownloadedPlaylistsButtonState
    extends State<SyncDownloadedPlaylistsButton> {
  final _syncLogger = Logger("SyncDownloadedPlaylistsButton");
  DownloadsHelper downloadsHelper = GetIt.instance<DownloadsHelper>();
  final _jellyfinApiData = GetIt.instance<JellyfinApiHelper>();

  void syncPlaylists() async {
    _syncLogger.info("Syncing downloaded playlists");
    List<DownloadedParent> parents = downloadsHelper.downloadedParents.toList();
    List<DownloadedSong> songs = downloadsHelper.downloadedItems.toList();

    for (DownloadedParent parent in parents) {
      Set<String> children =
          parent.downloadedChildren.values.map((e) => e.id).toSet();
      DownloadedSong firstSong = songs.first;
      List<BaseItemDto>? items = await _jellyfinApiData.getItems(
          isGenres: false, parentItem: parent.item);

      if (items == null) continue;

      for (BaseItemDto item in items) {
        _syncLogger.info(item.id.toString());
        bool isInChildren = children.contains(item.id);

        if (isInChildren) {
          _syncLogger.info("Need sync download of ${item.id}");

          await downloadsHelper.addDownloads(
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
        onPressed: () => syncPlaylists(), icon: const Icon(Icons.sync));
  }
}
