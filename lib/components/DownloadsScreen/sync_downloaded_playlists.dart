import 'package:finamp/services/isar_downloads.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

class SyncDownloadedPlaylistsButton extends StatefulWidget {
  const SyncDownloadedPlaylistsButton({super.key});

  @override
  State<SyncDownloadedPlaylistsButton> createState() =>
      _SyncDownloadedPlaylistsButtonState();
}

class _SyncDownloadedPlaylistsButtonState
    extends State<SyncDownloadedPlaylistsButton> {

  @override
  Widget build(BuildContext context) {
    return IconButton(
        onPressed: () => GetIt.instance<IsarDownloads>().resyncAll(), icon: const Icon(Icons.sync));
  }
}
