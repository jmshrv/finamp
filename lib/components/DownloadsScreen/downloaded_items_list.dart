import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get_it/get_it.dart';

import '../../models/finamp_models.dart';
import '../../services/isar_downloads.dart';
import '../album_image.dart';
import '../confirmation_prompt_dialog.dart';
import '../first_page_progress_indicator.dart';
import 'item_file_size.dart';

class DownloadedItemsList extends StatefulWidget {
  const DownloadedItemsList({Key? key}) : super(key: key);

  @override
  State<DownloadedItemsList> createState() => _DownloadedItemsListState();
}

class _DownloadedItemsListState extends State<DownloadedItemsList> {
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
                    title: Text(album.baseItem?.name ?? album.name),
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
                    subtitle: ItemFileSize(
                      item: album,
                    ),
                    children: [
                      DownloadedChildrenList(
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

class DownloadedChildrenList extends StatefulWidget {
  const DownloadedChildrenList({super.key, required this.parent});

  final DownloadStub parent;

  @override
  State<DownloadedChildrenList> createState() => _DownloadedChildrenListState();
}

class _DownloadedChildrenListState extends State<DownloadedChildrenList> {
  final isarDownloads = GetIt.instance<IsarDownloads>();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: isarDownloads.getVisibleChildren(widget.parent),
        builder: (context, snapshot) {
          return Column(children: [
            //TODO use a list builder here
            for (final song in snapshot.data ?? <DownloadItem>[])
              ListTile(
                title: Text(song.baseItem?.name ?? song.name),
                leading: AlbumImage(item: song.baseItem),
                subtitle: ItemFileSize(
                  item: song,
                ),
              )
          ]);
        });
  }
}
