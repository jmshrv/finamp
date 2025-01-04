import 'package:finamp/services/finamp_settings_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get_it/get_it.dart';

import '../../models/finamp_models.dart';
import '../../services/downloads_service.dart';
import '../album_image.dart';
import '../confirmation_prompt_dialog.dart';
import 'item_file_size.dart';

class DownloadedItemsList extends StatefulWidget {
  const DownloadedItemsList({Key? key}) : super(key: key);

  @override
  State<DownloadedItemsList> createState() => _DownloadedItemsListState();
}

class _DownloadedItemsListState extends State<DownloadedItemsList> {
  final DownloadsService downloadsService = GetIt.instance<DownloadsService>();

  @override
  Widget build(BuildContext context) {
    var items = downloadsService.getUserDownloaded();
    return ListTileTheme(
      // Manually handle padding in leading/trailing icons
      horizontalTitleGap: 0,
      child: SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            DownloadStub album = items.elementAt(index);
            return ExpansionTile(
              key: PageStorageKey(album.id),
              leading: Padding(
                padding: const EdgeInsets.only(right: 16),
                child: AlbumImage(item: album.baseItem),
              ),
              title: Text(album.baseItem?.name ?? album.name),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if ((!(album.baseItemType == BaseItemDtoType.album ||
                          album.baseItemType == BaseItemDtoType.song)) &&
                      !FinampSettingsHelper.finampSettings.isOffline)
                    IconButton(
                      icon: const Icon(Icons.sync),
                      onPressed: () {
                        downloadsService.resync(album, null);
                      },
                    ),
                  IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () => showDialog(
                      context: context,
                      builder: (context) => ConfirmationPromptDialog(
                        promptText:
                            AppLocalizations.of(context)!.deleteDownloadsPrompt(
                          album.name,
                          album.baseItemType.idString ?? "",
                        ),
                        confirmButtonText: AppLocalizations.of(context)!
                            .deleteDownloadsConfirmButtonText,
                        abortButtonText: AppLocalizations.of(context)!
                            .genericCancel,
                        onConfirmed: () async {
                          await downloadsService.deleteDownload(stub: album);
                          if (mounted) {
                            setState(() {});
                          }
                        },
                        onAborted: () {},
                      ),
                    ),
                  ),
                ],
              ),
              subtitle: ItemFileSize(
                stub: album,
              ),
              tilePadding: const EdgeInsets.symmetric(horizontal: 4.0),
              children: [
                DownloadedChildrenList(
                  parent: album,
                )
              ],
            );
          },
          childCount: items.length,
        ),
      ),
    );
  }
}

class DownloadedChildrenList extends StatefulWidget {
  const DownloadedChildrenList({super.key, required this.parent});

  final DownloadStub parent;

  @override
  State<DownloadedChildrenList> createState() => _DownloadedChildrenListState();
}

class _DownloadedChildrenListState extends State<DownloadedChildrenList> {
  final downloadsService = GetIt.instance<DownloadsService>();

  @override
  Widget build(BuildContext context) {
    var items = downloadsService.getVisibleChildren(widget.parent);
    return Column(children: [
      //TODO use a list builder here
      for (final song in items)
        ListTile(
          title: Text(song.baseItem?.name ?? song.name),
          leading: Padding(
            padding: const EdgeInsets.only(right: 16),
            child: AlbumImage(item: song.baseItem),
          ),
          subtitle: ItemFileSize(
            stub: song,
          ),
        )
    ]);
  }
}
