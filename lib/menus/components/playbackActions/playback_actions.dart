import 'dart:io';

import 'package:finamp/components/global_snackbar.dart';
import 'package:finamp/l10n/app_localizations.dart';
import 'package:finamp/menus/components/playbackActions/playback_action.dart';
import 'package:finamp/models/finamp_models.dart';
import 'package:finamp/models/jellyfin_models.dart';
import 'package:finamp/services/finamp_settings_helper.dart';
import 'package:finamp/services/item_helper.dart';
import 'package:finamp/services/queue_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:get_it/get_it.dart';

Map<String, Widget> getPlaybackActionPages({
  required BuildContext context,
  required PlayableItem item,
  bool popContext = true,
  bool compactLayout = false,
  BaseItemDto? genreFilter,
}) {
  final queueService = GetIt.instance<QueueService>();
  final ref = GetIt.instance<ProviderContainer>();
  final BaseItemDtoType? itemType = item is BaseItemDto ? BaseItemDtoType.fromItem(item) : null;
  final preferNextUpPrepending = ref.read(finampSettingsProvider.preferNextUpPrepending);

  return {
    // New Queue
    AppLocalizations.of(context)!.playbackActionPageNewQueue: Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        if (itemType != BaseItemDtoType.genre)
          PlayPlaybackAction(
            item: item,
            popContext: popContext,
            compactLayout: compactLayout,
            genreFilter: genreFilter,
          ),
        ShufflePlaybackAction(
          item: item,
          itemType: itemType,
          popContext: popContext,
          compactLayout: compactLayout,
          genreFilter: genreFilter,
        ),
        if (itemType == BaseItemDtoType.artist || itemType == BaseItemDtoType.genre)
          ShuffleAlbumsPlaybackAction(
            item: item,
            itemType: itemType,
            popContext: popContext,
            compactLayout: compactLayout,
            genreFilter: genreFilter,
          ),
      ],
    ),
    // Next
    if (queueService.getQueue().nextUp.isNotEmpty || preferNextUpPrepending)
      AppLocalizations.of(context)!.playbackActionPageNext: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (itemType != BaseItemDtoType.genre)
            PlayNextPlaybackAction(
              item: item,
              popContext: popContext,
              compactLayout: compactLayout,
              genreFilter: genreFilter,
            ),
          ShuffleNextPlaybackAction(
            item: item,
            itemType: itemType,
            popContext: popContext,
            compactLayout: compactLayout,
            genreFilter: genreFilter,
          ),
          if (itemType == BaseItemDtoType.artist || itemType == BaseItemDtoType.genre)
            ShuffleAlbumsNextPlaybackAction(
              item: item,
              itemType: itemType,
              popContext: popContext,
              compactLayout: compactLayout,
              genreFilter: genreFilter,
            ),
        ],
      ),
    // Append to Next Up
    if (queueService.getQueue().nextUp.isNotEmpty || !preferNextUpPrepending)
      AppLocalizations.of(context)!.playbackActionPageNextUp: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (itemType != BaseItemDtoType.genre)
            AddToNextUpPlaybackAction(
              item: item,
              popContext: popContext,
              compactLayout: compactLayout,
              genreFilter: genreFilter,
            ),
          ShuffleToNextUpPlaybackAction(
            item: item,
            itemType: itemType,
            popContext: popContext,
            compactLayout: compactLayout,
            genreFilter: genreFilter,
          ),
          if (itemType == BaseItemDtoType.artist || itemType == BaseItemDtoType.genre)
            ShuffleAlbumsToNextUpPlaybackAction(
              item: item,
              itemType: itemType,
              popContext: popContext,
              compactLayout: compactLayout,
              genreFilter: genreFilter,
            ),
        ],
      ),
    // Append to Queue
    AppLocalizations.of(context)!.playbackActionPageAppendToQueue: Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        if (itemType != BaseItemDtoType.genre)
          AddToQueuePlaybackAction(
            item: item,
            popContext: popContext,
            compactLayout: compactLayout,
            genreFilter: genreFilter,
          ),
        ShuffleToQueuePlaybackAction(
          item: item,
          itemType: itemType,
          popContext: popContext,
          compactLayout: compactLayout,
          genreFilter: genreFilter,
        ),
        if (itemType == BaseItemDtoType.artist || itemType == BaseItemDtoType.genre)
          ShuffleAlbumsToQueuePlaybackAction(
            item: item,
            itemType: itemType,
            popContext: popContext,
            compactLayout: compactLayout,
            genreFilter: genreFilter,
          ),
      ],
    ),
  };
}

class PlayPlaybackAction extends ConsumerWidget {
  const PlayPlaybackAction({
    super.key,
    required this.item,
    this.popContext = true,
    this.compactLayout = false,
    this.genreFilter,
  });

  final PlayableItem item;
  final bool popContext;
  final bool compactLayout;
  final BaseItemDto? genreFilter;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final queueService = GetIt.instance<QueueService>();
    return PlaybackAction(
      icon: TablerIcons.player_play,
      label: AppLocalizations.of(context)!.playButtonLabel,
      compactLayout: compactLayout,
      onPressed: () async {
        await queueService.startPlayback(
          items: await loadChildTracks(item: item, genreFilter: genreFilter),
          source: QueueItemSource.fromPlayableItem(item),
          order: FinampPlaybackOrder.linear,
        );

        if (popContext) {
          Navigator.pop(context);
        }
      },
      iconColor: Theme.of(context).textTheme.bodyMedium?.color ?? Colors.white,
    );
  }
}

class PlayNextPlaybackAction extends ConsumerWidget {
  const PlayNextPlaybackAction({
    super.key,
    required this.item,
    this.popContext = true,
    this.compactLayout = false,
    this.genreFilter,
  });

  final PlayableItem item;
  final bool popContext;
  final bool compactLayout;
  final BaseItemDto? genreFilter;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final queueService = GetIt.instance<QueueService>();
    final preferNextUpPrepending = ref.read(finampSettingsProvider.preferNextUpPrepending);

    return Visibility(
      visible: queueService.getQueue().nextUp.isNotEmpty || preferNextUpPrepending,
      child: PlaybackAction(
        enabled: !(Platform.isWindows || Platform.isLinux),
        icon: TablerIcons.corner_right_down,
        label: AppLocalizations.of(context)!.playNext,
        compactLayout: compactLayout,
        onPressed: () async {
          await queueService.addNext(
            items: await loadChildTracks(item: item, genreFilter: genreFilter),
            source: QueueItemSource.fromPlayableItem(item, type: QueueItemSourceType.nextUpAlbum),
          );

          GlobalSnackbar.message(
            (scaffold) => AppLocalizations.of(scaffold)!.confirmPlayNext(BaseItemDtoType.fromPlayableItem(item).name),
            isConfirmation: true,
          );

          if (popContext) {
            Navigator.pop(context);
          }
        },
        iconColor: Theme.of(context).textTheme.bodyMedium?.color ?? Colors.white,
      ),
    );
  }
}

class AddToNextUpPlaybackAction extends ConsumerWidget {
  const AddToNextUpPlaybackAction({
    super.key,
    required this.item,
    this.popContext = true,
    this.compactLayout = false,
    this.genreFilter,
  });

  final PlayableItem item;
  final bool popContext;
  final bool compactLayout;
  final BaseItemDto? genreFilter;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final queueService = GetIt.instance<QueueService>();
    final preferNextUpPrepending = ref.read(finampSettingsProvider.preferNextUpPrepending);

    return Visibility(
      visible: queueService.getQueue().nextUp.isNotEmpty || !preferNextUpPrepending,
      child: PlaybackAction(
        enabled: !(Platform.isWindows || Platform.isLinux),
        icon: TablerIcons.corner_right_down_double,
        label: AppLocalizations.of(context)!.addToNextUp,
        compactLayout: compactLayout,
        onPressed: () async {
          await queueService.addToNextUp(
            items: await loadChildTracks(item: item, genreFilter: genreFilter),
            source: QueueItemSource.fromPlayableItem(item, type: QueueItemSourceType.nextUpAlbum),
          );

          GlobalSnackbar.message(
            (scaffold) =>
                AppLocalizations.of(scaffold)!.confirmAddToNextUp(BaseItemDtoType.fromPlayableItem(item).name),
            isConfirmation: true,
          );

          if (popContext) {
            Navigator.pop(context);
          }
        },
        iconColor: Theme.of(context).textTheme.bodyMedium?.color ?? Colors.white,
      ),
    );
  }
}

class AddToQueuePlaybackAction extends ConsumerWidget {
  const AddToQueuePlaybackAction({
    super.key,
    required this.item,
    this.popContext = true,
    this.compactLayout = false,
    this.genreFilter,
  });

  final PlayableItem item;
  final bool popContext;
  final bool compactLayout;
  final BaseItemDto? genreFilter;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final queueService = GetIt.instance<QueueService>();

    return PlaybackAction(
      icon: TablerIcons.playlist,
      label: AppLocalizations.of(context)!.addToQueue,
      compactLayout: compactLayout,
      onPressed: () async {
        await queueService.addToQueue(
          items: await loadChildTracks(item: item, genreFilter: genreFilter),
          source: QueueItemSource.fromPlayableItem(item),
        );

        GlobalSnackbar.message(
          (scaffold) => AppLocalizations.of(scaffold)!.confirmAddToQueue(BaseItemDtoType.fromPlayableItem(item).name),
          isConfirmation: true,
        );

        if (popContext) {
          Navigator.pop(context);
        }
      },
      iconColor: Theme.of(context).textTheme.bodyMedium?.color ?? Colors.white,
    );
  }
}

class ShufflePlaybackAction extends ConsumerWidget {
  const ShufflePlaybackAction({
    super.key,
    required this.item,
    this.itemType,
    this.popContext = true,
    this.compactLayout = false,
    this.genreFilter,
  });

  final PlayableItem item;
  final BaseItemDtoType? itemType;
  final bool popContext;
  final bool compactLayout;
  final BaseItemDto? genreFilter;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final queueService = GetIt.instance<QueueService>();

    return PlaybackAction(
      icon: TablerIcons.arrows_shuffle,
      label: (itemType == BaseItemDtoType.genre)
          ? AppLocalizations.of(context)!.shuffleSome
          : AppLocalizations.of(context)!.shuffleButtonLabel,
      compactLayout: compactLayout,
      onPressed: () async {
        await queueService.startPlayback(
          items: await loadChildTracks(item: item, genreFilter: genreFilter),
          source: QueueItemSource.fromPlayableItem(item),
          order: FinampPlaybackOrder.shuffled,
        );

        if (popContext) {
          Navigator.pop(context);
        }
      },
      iconColor: Theme.of(context).textTheme.bodyMedium?.color ?? Colors.white,
    );
  }
}

class ShuffleNextPlaybackAction extends ConsumerWidget {
  const ShuffleNextPlaybackAction({
    super.key,
    required this.item,
    this.itemType,
    this.popContext = true,
    this.compactLayout = false,
    this.genreFilter,
  });

  final PlayableItem item;
  final BaseItemDtoType? itemType;
  final bool popContext;
  final bool compactLayout;
  final BaseItemDto? genreFilter;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final queueService = GetIt.instance<QueueService>();
    final preferNextUpPrepending = ref.read(finampSettingsProvider.preferNextUpPrepending);

    return Visibility(
      visible: queueService.getQueue().nextUp.isNotEmpty || preferNextUpPrepending,
      child: PlaybackAction(
        enabled: !(Platform.isWindows || Platform.isLinux),
        icon: TablerIcons.corner_right_down,
        addShuffleIcon: true,
        label: (itemType == BaseItemDtoType.genre)
            ? AppLocalizations.of(context)!.shuffleSomeNext
            : AppLocalizations.of(context)!.shuffleNext,
        compactLayout: compactLayout,
        onPressed: () async {
          await queueService.addNext(
            items: await loadChildTracks(item: item, genreFilter: genreFilter),
            source: QueueItemSource.fromPlayableItem(item, type: QueueItemSourceType.nextUpAlbum),
            order: FinampPlaybackOrder.shuffled,
          );

          GlobalSnackbar.message((scaffold) => AppLocalizations.of(scaffold)!.confirmShuffleNext, isConfirmation: true);

          if (popContext) {
            Navigator.pop(context);
          }
        },
        iconColor: Theme.of(context).textTheme.bodyMedium?.color ?? Colors.white,
      ),
    );
  }
}

class ShuffleToNextUpPlaybackAction extends ConsumerWidget {
  const ShuffleToNextUpPlaybackAction({
    super.key,
    required this.item,
    this.itemType,
    this.popContext = true,
    this.compactLayout = false,
    this.genreFilter,
  });

  final PlayableItem item;
  final BaseItemDtoType? itemType;
  final bool popContext;
  final bool compactLayout;
  final BaseItemDto? genreFilter;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final queueService = GetIt.instance<QueueService>();
    final preferNextUpPrepending = ref.read(finampSettingsProvider.preferNextUpPrepending);

    return Visibility(
      visible: queueService.getQueue().nextUp.isNotEmpty || !preferNextUpPrepending,
      child: PlaybackAction(
        enabled: !(Platform.isWindows || Platform.isLinux),
        icon: TablerIcons.corner_right_down_double,
        addShuffleIcon: true,
        label: (itemType == BaseItemDtoType.genre)
            ? AppLocalizations.of(context)!.shuffleSomeToNextUp
            : AppLocalizations.of(context)!.shuffleToNextUp,
        compactLayout: compactLayout,
        onPressed: () async {
          await queueService.addToNextUp(
            items: await loadChildTracks(item: item, genreFilter: genreFilter),
            source: QueueItemSource.fromPlayableItem(item, type: QueueItemSourceType.nextUpAlbum),
            order: FinampPlaybackOrder.shuffled,
          );

          GlobalSnackbar.message(
            (scaffold) => AppLocalizations.of(scaffold)!.confirmShuffleToNextUp,
            isConfirmation: true,
          );

          if (popContext) {
            Navigator.pop(context);
          }
        },
        iconColor: Theme.of(context).textTheme.bodyMedium?.color ?? Colors.white,
      ),
    );
  }
}

class ShuffleToQueuePlaybackAction extends ConsumerWidget {
  const ShuffleToQueuePlaybackAction({
    super.key,
    required this.item,
    this.itemType,
    this.popContext = true,
    this.compactLayout = false,
    this.genreFilter,
  });

  final PlayableItem item;
  final BaseItemDtoType? itemType;
  final bool popContext;
  final bool compactLayout;
  final BaseItemDto? genreFilter;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final queueService = GetIt.instance<QueueService>();

    return PlaybackAction(
      icon: TablerIcons.playlist,
      addShuffleIcon: true,
      label: (itemType == BaseItemDtoType.genre)
          ? AppLocalizations.of(context)!.shuffleSomeToQueue
          : AppLocalizations.of(context)!.shuffleToQueue,
      compactLayout: compactLayout,
      onPressed: () async {
        await queueService.addToQueue(
          items: await loadChildTracks(item: item, genreFilter: genreFilter),
          source: QueueItemSource.fromPlayableItem(item),
          order: FinampPlaybackOrder.shuffled,
        );

        GlobalSnackbar.message(
          (scaffold) => AppLocalizations.of(scaffold)!.confirmShuffleToQueue,
          isConfirmation: true,
        );

        if (popContext) {
          Navigator.pop(context);
        }
      },
      iconColor: Theme.of(context).textTheme.bodyMedium?.color ?? Colors.white,
    );
  }
}

class ShuffleAlbumsPlaybackAction extends ConsumerWidget {
  const ShuffleAlbumsPlaybackAction({
    super.key,
    required this.item,
    this.itemType,
    this.popContext = true,
    this.compactLayout = false,
    this.genreFilter,
  });

  final PlayableItem item;
  final BaseItemDtoType? itemType;
  final bool popContext;
  final bool compactLayout;
  final BaseItemDto? genreFilter;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final queueService = GetIt.instance<QueueService>();

    return PlaybackAction(
      icon: TablerIcons.arrows_shuffle,
      label: (itemType == BaseItemDtoType.genre)
          ? AppLocalizations.of(context)!.shuffleSomeAlbums
          : AppLocalizations.of(context)!.shuffleAlbums,
      compactLayout: compactLayout,
      onPressed: () async {
        await queueService.startPlayback(
          items: groupItems(
            items: await loadChildTracks(
              item: item,
              genreFilter: genreFilter,
              shuffleGenreAlbums: itemType == BaseItemDtoType.genre,
            ),
            groupListBy: (element) => element.albumId?.toString(),
            manuallyShuffle: true,
          ),
          source: QueueItemSource.fromPlayableItem(item, type: QueueItemSourceType.nextUpAlbum),
        );

        if (popContext) {
          Navigator.pop(context);
        }
      },
      iconColor: Theme.of(context).textTheme.bodyMedium?.color ?? Colors.white,
    );
  }
}

class ShuffleAlbumsNextPlaybackAction extends ConsumerWidget {
  const ShuffleAlbumsNextPlaybackAction({
    super.key,
    required this.item,
    this.itemType,
    this.popContext = true,
    this.compactLayout = false,
    this.genreFilter,
  });

  final PlayableItem item;
  final BaseItemDtoType? itemType;
  final bool popContext;
  final bool compactLayout;
  final BaseItemDto? genreFilter;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final queueService = GetIt.instance<QueueService>();
    final preferNextUpPrepending = ref.read(finampSettingsProvider.preferNextUpPrepending);

    return Visibility(
      visible: queueService.getQueue().nextUp.isNotEmpty || preferNextUpPrepending,
      child: PlaybackAction(
        enabled: !(Platform.isWindows || Platform.isLinux),
        icon: TablerIcons.corner_right_down,
        addShuffleIcon: true,
        label: (itemType == BaseItemDtoType.genre)
            ? AppLocalizations.of(context)!.shuffleSomeAlbumsNext
            : AppLocalizations.of(context)!.shuffleAlbumsNext,
        compactLayout: compactLayout,
        onPressed: () async {
          await queueService.addNext(
            items: groupItems(
              items: await loadChildTracks(
                item: item,
                genreFilter: genreFilter,
                shuffleGenreAlbums: itemType == BaseItemDtoType.genre,
              ),
              groupListBy: (element) => element.albumId?.toString(),
              manuallyShuffle: true,
            ),
            source: QueueItemSource.fromPlayableItem(item, type: QueueItemSourceType.nextUpAlbum),
          );

          GlobalSnackbar.message((scaffold) => AppLocalizations.of(scaffold)!.confirmShuffleNext, isConfirmation: true);

          if (popContext) {
            Navigator.pop(context);
          }
        },
        iconColor: Theme.of(context).textTheme.bodyMedium?.color ?? Colors.white,
      ),
    );
  }
}

class ShuffleAlbumsToNextUpPlaybackAction extends ConsumerWidget {
  const ShuffleAlbumsToNextUpPlaybackAction({
    super.key,
    required this.item,
    this.itemType,
    this.popContext = true,
    this.compactLayout = false,
    this.genreFilter,
  });

  final PlayableItem item;
  final BaseItemDtoType? itemType;
  final bool popContext;
  final bool compactLayout;
  final BaseItemDto? genreFilter;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final queueService = GetIt.instance<QueueService>();
    final preferNextUpPrepending = ref.read(finampSettingsProvider.preferNextUpPrepending);

    return Visibility(
      visible: queueService.getQueue().nextUp.isNotEmpty || !preferNextUpPrepending,
      child: PlaybackAction(
        enabled: !(Platform.isWindows || Platform.isLinux),
        icon: TablerIcons.corner_right_down_double,
        addShuffleIcon: true,
        label: (itemType == BaseItemDtoType.genre)
            ? AppLocalizations.of(context)!.shuffleSomeAlbumsToNextUp
            : AppLocalizations.of(context)!.shuffleAlbumsToNextUp,
        compactLayout: compactLayout,
        onPressed: () async {
          await queueService.addToNextUp(
            items: groupItems(
              items: await loadChildTracks(
                item: item,
                genreFilter: genreFilter,
                shuffleGenreAlbums: itemType == BaseItemDtoType.genre,
              ),
              groupListBy: (element) => element.albumId?.toString(),
              manuallyShuffle: true,
            ),
            source: QueueItemSource.fromPlayableItem(item, type: QueueItemSourceType.nextUpAlbum),
          );

          GlobalSnackbar.message(
            (scaffold) => AppLocalizations.of(scaffold)!.confirmShuffleToNextUp,
            isConfirmation: true,
          );

          if (popContext) {
            Navigator.pop(context);
          }
        },
        iconColor: Theme.of(context).textTheme.bodyMedium?.color ?? Colors.white,
      ),
    );
  }
}

class ShuffleAlbumsToQueuePlaybackAction extends ConsumerWidget {
  const ShuffleAlbumsToQueuePlaybackAction({
    super.key,
    required this.item,
    this.itemType,
    this.popContext = true,
    this.compactLayout = false,
    this.genreFilter,
  });

  final PlayableItem item;
  final BaseItemDtoType? itemType;
  final bool popContext;
  final bool compactLayout;
  final BaseItemDto? genreFilter;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final queueService = GetIt.instance<QueueService>();

    return PlaybackAction(
      icon: TablerIcons.playlist,
      addShuffleIcon: true,
      label: (itemType == BaseItemDtoType.genre)
          ? AppLocalizations.of(context)!.shuffleSomeAlbumsToQueue
          : AppLocalizations.of(context)!.shuffleAlbumsToQueue,
      compactLayout: compactLayout,
      onPressed: () async {
        await queueService.addToQueue(
          items: groupItems(
            items: await loadChildTracks(
              item: item,
              genreFilter: genreFilter,
              shuffleGenreAlbums: itemType == BaseItemDtoType.genre,
            ),
            groupListBy: (element) => element.albumId?.toString(),
            manuallyShuffle: true,
          ),
          source: QueueItemSource.fromPlayableItem(item),
        );

        GlobalSnackbar.message(
          (scaffold) => AppLocalizations.of(scaffold)!.confirmShuffleToQueue,
          isConfirmation: true,
        );

        if (popContext) {
          Navigator.pop(context);
        }
      },
      iconColor: Theme.of(context).textTheme.bodyMedium?.color ?? Colors.white,
    );
  }
}
