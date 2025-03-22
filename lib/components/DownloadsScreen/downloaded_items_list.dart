import 'package:finamp/components/delete_prompts.dart';
import 'package:finamp/services/finamp_settings_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
import 'package:isar/isar.dart';

import '../../models/finamp_models.dart';
import '../../services/downloads_service.dart';
import '../album_image.dart';
import 'item_file_size.dart';

enum DownloadsScreenItemType {
  artists,
  albums,
  playlists,
  genres,
  tracks,
}

class DownloadedItemsTitle extends StatelessWidget {
  const DownloadedItemsTitle({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.only(left: 16, top: 8, right: 16),
        child: Text(
          title,
          style: Theme.of(context).textTheme.headlineSmall,
        ),
      ),
    );
  }
}

class DownloadedItemsList extends ConsumerStatefulWidget {
  const DownloadedItemsList({super.key, required this.type});

  final DownloadsScreenItemType type;

  @override
  ConsumerState<DownloadedItemsList> createState() =>
      _DownloadedItemTypeListState();
}

class _DownloadedItemTypeListState extends ConsumerState<DownloadedItemsList> {
  final _downloadsService = GetIt.instance<DownloadsService>();
  late final Query<DownloadStub> _query;
  late final AutoDisposeStreamProvider<List<DownloadStub>> _itemsProvider;

  @override
  void initState() {
    super.initState();
    switch (widget.type) {
      case DownloadsScreenItemType.artists:
        _query = _downloadsService
            .queryUserDownloadedCollection(BaseItemDtoType.artist);
        break;
      case DownloadsScreenItemType.albums:
        _query = _downloadsService
            .queryUserDownloadedCollection(BaseItemDtoType.album);
        break;
      case DownloadsScreenItemType.playlists:
        _query = _downloadsService
            .queryUserDownloadedCollection(BaseItemDtoType.playlist);
        break;
      case DownloadsScreenItemType.genres:
        _query = _downloadsService
            .queryUserDownloadedCollection(BaseItemDtoType.genre);
        break;
      case DownloadsScreenItemType.tracks:
        _query = _downloadsService.queryUserDownloadedTracks();
        break;
    }

    _itemsProvider = StreamProvider.autoDispose((ref) {
      return _query.watch(fireImmediately: true);
    });
  }

  @override
  Widget build(BuildContext context) {
    return ref.watch(_itemsProvider).when(
          data: (items) => SliverList(
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
                              stub.baseItemType == BaseItemDtoType.track)) &&
                          !FinampSettingsHelper.finampSettings.isOffline)
                        IconButton(
                          icon: const Icon(Icons.sync),
                          onPressed: () {
                            _downloadsService.resync(stub, null);
                          },
                        ),
                      IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () => askBeforeDeleteDownloadFromDevice(
                                  context, stub, refresh: () {
                                setState(() {});
                              })),
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
      //TODO use a list builder here
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
