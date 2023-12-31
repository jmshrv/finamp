import 'package:finamp/services/jellyfin_api_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get_it/get_it.dart';

import '../../models/finamp_models.dart';
import '../../services/isar_downloads.dart';
import '../album_image.dart';
import '../confirmation_prompt_dialog.dart';
import '../first_page_progress_indicator.dart';
import 'album_file_size.dart';
import 'item_media_source_info.dart';

class DownloadedAlbumsList extends StatefulWidget {
  const DownloadedAlbumsList({Key? key}) : super(key: key);

  @override
  State<DownloadedAlbumsList> createState() => _DownloadedAlbumsListState();
}

class _DownloadedAlbumsListState extends State<DownloadedAlbumsList> {
  final JellyfinApiHelper jellyfinApiHelper = JellyfinApiHelper();
  final IsarDownloads isarDownloads = GetIt.instance<IsarDownloads>();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: isarDownloads.getUserDownloaded(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  DownloadStub album = snapshot.data!.elementAt(index);
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
                              .deleteDownloadsPrompt(
                            album.name,
                            album.baseItemType.idString ?? "",
                          ),
                          confirmButtonText: AppLocalizations.of(context)!
                              .deleteDownloadsConfirmButtonText,
                          abortButtonText: AppLocalizations.of(context)!
                              .deleteDownloadsAbortButtonText,
                          onConfirmed: () async {
                            await isarDownloads.deleteDownload(stub: album);
                            if (mounted) {
                              setState(() {});
                            }
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
                childCount: snapshot.data!.length,
              ),
            );
          } else {
            return SliverList(
                delegate: SliverChildBuilderDelegate(
                    (context, index) => const FirstPageProgressIndicator(),
                    childCount: 0));
          }
        });
  }
}

//TODO rename these
class DownloadedSongsInAlbumList extends StatefulWidget {
  const DownloadedSongsInAlbumList({Key? key, required this.parent})
      : super(key: key);

  final DownloadStub parent;

  @override
  State<DownloadedSongsInAlbumList> createState() =>
      _DownloadedSongsInAlbumListState();
}

class _DownloadedSongsInAlbumListState
    extends State<DownloadedSongsInAlbumList> {
  final isarDownloads = GetIt.instance<IsarDownloads>();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: isarDownloads.getVisibleChildren(widget.parent),
        builder: (context, snapshot) {
          return Column(children: [
            //TODO use a list builder here
            for (final song in snapshot.data ?? [])
              ListTile(
                title: Text(song.baseItem?.name ?? "Unknown Name"),
                leading: AlbumImage(item: song?.baseItem),
                subtitle: ItemMediaSourceInfo(
                  item: song,
                ),
              )
          ]);
        });
  }
}
