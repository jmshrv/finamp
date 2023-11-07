import 'package:finamp/models/jellyfin_models.dart';
import 'package:finamp/services/sync_helper.dart';
import 'package:flutter/material.dart';
import 'package:logging/logging.dart';

class SyncAlbumOrPlaylistButton extends StatefulWidget {
  const SyncAlbumOrPlaylistButton({
    Key? key,
    required this.parent,
    required this.items,
  }) : super(key: key);

  final BaseItemDto parent;
  final List<BaseItemDto> items;
  @override
  State<SyncAlbumOrPlaylistButton> createState() =>
      _SyncAlbumOrPlaylistButtonState();
}
class _SyncAlbumOrPlaylistButtonState
    extends State<SyncAlbumOrPlaylistButton> {
  final _syncLogger = Logger("SyncPlaylistButton");

  void syncAlbumOrPlaylist() async {
    _syncLogger.info("Syncing playlist");

    var syncHelper = DownloadsSyncHelper(_syncLogger);
    syncHelper.sync(widget.parent, widget.items);
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
        onPressed: () => syncAlbumOrPlaylist(), icon: const Icon(Icons.sync));
  }
}