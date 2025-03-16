import 'package:finamp/models/finamp_models.dart';
import 'package:finamp/models/jellyfin_models.dart';
import 'package:finamp/services/downloads_helper.dart';
import 'package:finamp/services/jellyfin_api_helper.dart';
import 'package:finamp/services/sync_helper.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:logging/logging.dart';

class SyncDownloadedAlbumsOrPlaylistsButton extends StatelessWidget {
  SyncDownloadedAlbumsOrPlaylistsButton({super.key});

  final _syncLogger = Logger("SyncDownloadedPlaylistsButton");
  final DownloadsHelper downloadsHelper = GetIt.instance<DownloadsHelper>();
  final _jellyfinApiData = GetIt.instance<JellyfinApiHelper>();

  void syncPlaylists(BuildContext context) async {
    _syncLogger.info("Syncing downloaded playlists");

    var syncHelper = DownloadsSyncHelper(_syncLogger);
    List<DownloadedParent> parents = downloadsHelper.downloadedParents.toList();

    for (DownloadedParent parent in parents) {
      List<BaseItemDto>? items = await _jellyfinApiData.getItems(
          isGenres: false, parentItem: parent.item);

      if (items == null) {
        _syncLogger.warning("Could not find any items for album or playlist id ${parent.item.id}");
        continue;
      }
      syncHelper.sync(context, parent.item, items);
    }
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () => syncPlaylists(context),
      icon: const Icon(Icons.sync),
      tooltip: AppLocalizations.of(context)!.syncDownloadedPlaylists,
    );
  }
}
