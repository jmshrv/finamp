import 'package:finamp/services/jellyfin_api_helper.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../../models/finamp_models.dart';
import '../../services/downloads_helper.dart';
import '../../models/jellyfin_models.dart';
import '../../services/isar_downloads.dart';
import '../album_image.dart';
import '../confirmation_prompt_dialog.dart';
import 'item_media_source_info.dart';
import 'album_file_size.dart';

class DownloadedAlbumsList extends StatefulWidget {
  const DownloadedAlbumsList({Key? key}) : super(key: key);

  @override
  State<DownloadedAlbumsList> createState() => _DownloadedAlbumsListState();
}

class _DownloadedAlbumsListState extends State<DownloadedAlbumsList> {
  final DownloadsHelper downloadsHelper = GetIt.instance<DownloadsHelper>();

  final JellyfinApiHelper jellyfinApiHelper = JellyfinApiHelper();
  final IsarDownloads isarDownloads = GetIt.instance<IsarDownloads>();

  @override
  Widget build(BuildContext context) {
    final List<DownloadItem> parents = isarDownloads.getUserDownloaded();

    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          DownloadItem album = parents.elementAt(index);
          return ExpansionTile(
            key: PageStorageKey(album.id),
            leading: AlbumImage(item: album.baseItem),
            title: Text(album.baseItem?.name ?? "Unknown Name"),
            trailing: IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () => showDialog(
                context: context,
                builder: (context) => ConfirmationPromptDialog(
                  promptText: AppLocalizations.of(context)!
                      .deleteDownloadsPrompt(album.baseItem?.name ?? "",
                          album.baseItem?.type ?? "Collection"),
                  confirmButtonText: AppLocalizations.of(context)!
                      .deleteDownloadsConfirmButtonText,
                  abortButtonText: AppLocalizations.of(context)!
                      .deleteDownloadsAbortButtonText,
                  onConfirmed: () async {
                    await isarDownloads.deleteDownload(stub: album);
                    setState(() {});
                  },
                  onAborted: () {},
                ),
              ),
            ),
            subtitle: AlbumFileSize(
              downloadedParent: album,
            ),
            children: [
              DownloadedSongsInAlbumList(
                parent: album,
              )
            ],
          );
        },
        childCount: parents.length,
      ),
    );
  }
}

class DownloadedSongsInAlbumList extends StatefulWidget {
  const DownloadedSongsInAlbumList({Key? key, required this.parent})
      : super(key: key);

  final DownloadItem parent;

  @override
  State<DownloadedSongsInAlbumList> createState() =>
      _DownloadedSongsInAlbumListState();
}

class _DownloadedSongsInAlbumListState
    extends State<DownloadedSongsInAlbumList> {
  final isarDownloads = GetIt.instance<IsarDownloads>();

  @override
  Widget build(BuildContext context) {
    final List<DownloadItem> children =
        isarDownloads.getAllChildren(widget.parent);
    // TODO figure out what to do here.  Just filter for songs?
    // Handle something like an individual song download?
    // Just delete if you can't touch individual songs?

    return Column(children: [
      //TODO use a list builder here
      for (final song in children)
        ListTile(
          title: Text(song.baseItem?.name ?? "Unknown Name"),
          leading: AlbumImage(item: song?.baseItem),
          trailing: IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () => showDialog(
              context: context,
              builder: (context) => ConfirmationPromptDialog(
                promptText: AppLocalizations.of(context)!
                    .deleteDownloadsPrompt(song.baseItem?.name ?? "", "track"),
                confirmButtonText: AppLocalizations.of(context)!
                    .deleteDownloadsConfirmButtonText,
                abortButtonText: AppLocalizations.of(context)!
                    .deleteDownloadsAbortButtonText,
                onConfirmed: () async {
                  throw UnimplementedError(
                      "You can't delete individual songs.");
                  setState(() {});
                },
                onAborted: () {},
              ),
            ),
          ),
          subtitle: ItemMediaSourceInfo(
            item: song,
          ),
        )
    ]);
  }
}
