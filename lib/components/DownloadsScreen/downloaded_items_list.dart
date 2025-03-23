import 'package:finamp/components/delete_prompts.dart';
import 'package:finamp/services/finamp_settings_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';

import '../../models/finamp_models.dart';
import '../../services/downloads_service.dart';
import '../album_image.dart';
import 'item_file_size.dart';

class DownloadedItemsTitle extends StatelessWidget {
  const DownloadedItemsTitle({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.only(left: 16, top: 12, right: 16, bottom: 8),
        child: Text(
          title,
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}

class DownloadedItemsList extends ConsumerStatefulWidget {
  const DownloadedItemsList({super.key, required this.type});

  final DownloadsScreenCategory type;

  @override
  ConsumerState<DownloadedItemsList> createState() =>
      _DownloadedItemTypeListState();
}

class _DownloadedItemTypeListState extends ConsumerState<DownloadedItemsList> {
  final _downloadsService = GetIt.instance<DownloadsService>();

  @override
  Widget build(BuildContext context) {
    return ref
        .watch(_downloadsService.downloadedItemsProvider(widget.type))
        .when(
          data: (items) => items.isNotEmpty
              ? SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      DownloadStub stub = items.elementAt(index);
                      return ExpansionTile(
                        key: PageStorageKey(stub.id),
                        leading: AlbumImage(item: stub.baseItem),
                        title: Text(stub.baseItem?.name ?? stub.name),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if ((!(stub.baseItemType == BaseItemDtoType.album ||
                                    stub.baseItemType ==
                                        BaseItemDtoType.track)) &&
                                !FinampSettingsHelper.finampSettings.isOffline)
                              IconButton(
                                icon: const Icon(Icons.sync),
                                onPressed: () {
                                  _downloadsService.resync(stub, null);
                                },
                              ),
                            IconButton(
                              icon: const Icon(Icons.delete),
                              onPressed: () =>
                                  askBeforeDeleteDownloadFromDevice(
                                      context, stub),
                            ),
                          ],
                        ),
                        subtitle: ItemFileSize(stub: stub),
                        tilePadding: const EdgeInsets.symmetric(horizontal: 16),
                        children: [
                          if (stub.baseItemType.hasChildren)
                            DownloadedChildrenList(parent: stub)
                        ],
                      );
                    },
                    childCount: items.length,
                  ),
                )
              : SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child:
                        Text(AppLocalizations.of(context)!.noItemsDownloaded),
                  ),
                ),
          loading: () => const SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.only(top: 8, bottom: 16),
              child: Center(
                child: CircularProgressIndicator(),
              ),
            ),
          ),
          error: (error, stack) => SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Text(error.toString()),
            ),
          ),
        );
  }
}

class DownloadedChildrenList extends ConsumerStatefulWidget {
  const DownloadedChildrenList({super.key, required this.parent});

  final DownloadStub parent;

  @override
  ConsumerState<DownloadedChildrenList> createState() =>
      _DownloadedChildrenListState();
}

class _DownloadedChildrenListState
    extends ConsumerState<DownloadedChildrenList> {
  final _downloadsService = GetIt.instance<DownloadsService>();

  @override
  Widget build(BuildContext context) {
    var items = _downloadsService.getVisibleChildren(widget.parent);
    return Column(children: [
      // TODO use a list builder here
      for (final stub in items)
        ListTile(
          title: Text(stub.baseItem?.name ?? stub.name),
          leading: AlbumImage(item: stub.baseItem),
          subtitle: ItemFileSize(stub: stub),
          trailing: FutureBuilder(
            future: ref
                .watch(_downloadsService.statusProvider((stub, null)).future)
                .then((item) => item.isRequired),
            builder: (context, snapshot) {
              if (snapshot.hasData && snapshot.data!) {
                return const Icon(Icons.lock);
              }
              return const SizedBox.shrink();
            },
          ),
        )
    ]);
  }
}
