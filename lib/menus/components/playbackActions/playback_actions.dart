import 'dart:io';

import 'package:finamp/components/global_snackbar.dart';
import 'package:finamp/l10n/app_localizations.dart';
import 'package:finamp/menus/components/playbackActions/playback_action.dart';
import 'package:finamp/models/finamp_models.dart';
import 'package:finamp/models/jellyfin_models.dart';
import 'package:finamp/services/item_helper.dart';
import 'package:finamp/services/queue_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:get_it/get_it.dart';

Map<String, Widget> getCommonPlaybackActionPages({
  required BuildContext context,
  required PlayableItem item,
  bool popContext = true,
  BaseItemDto? genreFilter,
}) {
  final queueService = GetIt.instance<QueueService>();

  return {
    AppLocalizations.of(context)!.playbackActionPagePlay: Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        PlayPlaybackAction(item: item, popContext: popContext, genreFilter: genreFilter),
        if (queueService.getQueue().nextUp.isNotEmpty)
          PlayNextPlaybackAction(item: item, popContext: popContext, genreFilter: genreFilter),
        AddToNextUpPlaybackAction(item: item, popContext: popContext, genreFilter: genreFilter),
        AddToQueuePlaybackAction(item: item, popContext: popContext, genreFilter: genreFilter),
      ],
    ),
    // Shuffle
    AppLocalizations.of(context)!.playbackActionPageShuffle: Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        ShufflePlaybackAction(item: item, popContext: popContext, genreFilter: genreFilter),
        if (queueService.getQueue().nextUp.isNotEmpty)
          ShuffleNextPlaybackAction(item: item, popContext: popContext, genreFilter: genreFilter),
        ShuffleToNextUpPlaybackAction(item: item, popContext: popContext, genreFilter: genreFilter),
        ShuffleToQueuePlaybackAction(item: item, popContext: popContext, genreFilter: genreFilter),
      ],
    ),
  };
}

Map<String, Widget> getPlaybackActionPages({
  required BuildContext context,
  required PlayableItem item,
  bool popContext = true,
  BaseItemDto? genreFilter,
}) {
  final queueService = GetIt.instance<QueueService>();
  return switch (item) {
    AlbumDisc() => getCommonPlaybackActionPages(
      context: context,
      item: item,
      popContext: popContext,
      genreFilter: genreFilter,
    ),
    BaseItemDto() => switch (BaseItemDtoType.fromItem(item)) {
      BaseItemDtoType.artist => {
        ...getCommonPlaybackActionPages(context: context, item: item, popContext: popContext, genreFilter: genreFilter),
        AppLocalizations.of(context)!.playbackActionPageShuffleAlbums: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ShuffleAlbumsAction(baseItem: item, popContext: popContext, genreFilter: genreFilter),
            if (queueService.getQueue().nextUp.isNotEmpty)
              ShuffleAlbumsNextPlaybackAction(baseItem: item, popContext: popContext, genreFilter: genreFilter),
            ShuffleAlbumsToNextUpPlaybackAction(baseItem: item, popContext: popContext, genreFilter: genreFilter),
            ShuffleAlbumsToQueuePlaybackAction(baseItem: item, popContext: popContext, genreFilter: genreFilter),
          ],
        ),
      },
      _ => getCommonPlaybackActionPages(context: context, item: item, popContext: popContext, genreFilter: genreFilter),
    },
  };
}

class PlayPlaybackAction extends ConsumerWidget {
  const PlayPlaybackAction({super.key, required this.item, this.popContext = true, this.genreFilter});

  final PlayableItem item;
  final bool popContext;
  final BaseItemDto? genreFilter;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final queueService = GetIt.instance<QueueService>();
    return PlaybackAction(
      icon: TablerIcons.player_play,
      label: AppLocalizations.of(context)!.playButtonLabel,
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
  const PlayNextPlaybackAction({super.key, required this.item, this.popContext = true, this.genreFilter});

  final PlayableItem item;
  final bool popContext;
  final BaseItemDto? genreFilter;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final queueService = GetIt.instance<QueueService>();
    return Visibility(
      visible: queueService.getQueue().nextUp.isNotEmpty,
      child: PlaybackAction(
        enabled: !(Platform.isWindows || Platform.isLinux),
        icon: TablerIcons.corner_right_down,
        label: AppLocalizations.of(context)!.playNext,
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
  const AddToNextUpPlaybackAction({super.key, required this.item, this.popContext = true, this.genreFilter});

  final PlayableItem item;
  final bool popContext;
  final BaseItemDto? genreFilter;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final queueService = GetIt.instance<QueueService>();
    return PlaybackAction(
      enabled: !(Platform.isWindows || Platform.isLinux),
      icon: TablerIcons.corner_right_down_double,
      label: AppLocalizations.of(context)!.addToNextUp,
      onPressed: () async {
        await queueService.addToNextUp(
          items: await loadChildTracks(item: item, genreFilter: genreFilter),
          source: QueueItemSource.fromPlayableItem(item, type: QueueItemSourceType.nextUpAlbum),
        );

        GlobalSnackbar.message(
          (scaffold) => AppLocalizations.of(scaffold)!.confirmAddToNextUp(BaseItemDtoType.fromPlayableItem(item).name),
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

class AddToQueuePlaybackAction extends ConsumerWidget {
  const AddToQueuePlaybackAction({super.key, required this.item, this.popContext = true, this.genreFilter});

  final PlayableItem item;
  final bool popContext;
  final BaseItemDto? genreFilter;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final queueService = GetIt.instance<QueueService>();
    return PlaybackAction(
      icon: TablerIcons.playlist,
      label: AppLocalizations.of(context)!.addToQueue,
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
  const ShufflePlaybackAction({super.key, required this.item, this.popContext = true, this.genreFilter});

  final PlayableItem item;
  final bool popContext;
  final BaseItemDto? genreFilter;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final queueService = GetIt.instance<QueueService>();
    return PlaybackAction(
      icon: TablerIcons.arrows_shuffle,
      label: AppLocalizations.of(context)!.shuffleButtonLabel,
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
  const ShuffleNextPlaybackAction({super.key, required this.item, this.popContext = true, this.genreFilter});

  final PlayableItem item;
  final bool popContext;
  final BaseItemDto? genreFilter;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final queueService = GetIt.instance<QueueService>();
    return Visibility(
      visible: queueService.getQueue().nextUp.isNotEmpty,
      child: PlaybackAction(
        enabled: !(Platform.isWindows || Platform.isLinux),
        icon: TablerIcons.corner_right_down,
        label: AppLocalizations.of(context)!.shuffleNext,
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
  const ShuffleToNextUpPlaybackAction({super.key, required this.item, this.popContext = true, this.genreFilter});

  final PlayableItem item;
  final bool popContext;
  final BaseItemDto? genreFilter;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final queueService = GetIt.instance<QueueService>();
    return PlaybackAction(
      enabled: !(Platform.isWindows || Platform.isLinux),
      icon: TablerIcons.corner_right_down_double,
      label: AppLocalizations.of(context)!.shuffleToNextUp,
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
    );
  }
}

class ShuffleToQueuePlaybackAction extends ConsumerWidget {
  const ShuffleToQueuePlaybackAction({super.key, required this.item, this.popContext = true, this.genreFilter});

  final PlayableItem item;
  final bool popContext;
  final BaseItemDto? genreFilter;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final queueService = GetIt.instance<QueueService>();
    return PlaybackAction(
      icon: TablerIcons.playlist,
      label: AppLocalizations.of(context)!.shuffleToQueue,
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

class ShuffleAlbumsAction extends ConsumerWidget {
  const ShuffleAlbumsAction({super.key, required this.baseItem, this.popContext = true, this.genreFilter});

  final BaseItemDto baseItem;
  final bool popContext;
  final BaseItemDto? genreFilter;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final queueService = GetIt.instance<QueueService>();
    return PlaybackAction(
      icon: TablerIcons.arrows_shuffle,
      label: AppLocalizations.of(context)!.shuffleAlbums,
      onPressed: () async {
        await queueService.startPlayback(
          items: groupItems(
            items: await loadChildTracks(item: baseItem, genreFilter: genreFilter),
            groupListBy: (element) => element.albumId?.toString(),
            manuallyShuffle: true,
          ),
          source: QueueItemSource.fromBaseItem(baseItem, type: QueueItemSourceType.nextUpAlbum),
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
  const ShuffleAlbumsNextPlaybackAction({super.key, required this.baseItem, this.popContext = true, this.genreFilter});

  final BaseItemDto baseItem;
  final bool popContext;
  final BaseItemDto? genreFilter;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final queueService = GetIt.instance<QueueService>();
    return Visibility(
      visible: queueService.getQueue().nextUp.isNotEmpty,
      child: PlaybackAction(
        enabled: !(Platform.isWindows || Platform.isLinux),
        icon: TablerIcons.corner_right_down,
        label: AppLocalizations.of(context)!.shuffleAlbumsNext,
        onPressed: () async {
          await queueService.addNext(
            items: groupItems(
              items: await loadChildTracks(item: baseItem, genreFilter: genreFilter),
              groupListBy: (element) => element.albumId?.toString(),
              manuallyShuffle: true,
            ),
            source: QueueItemSource.fromBaseItem(baseItem, type: QueueItemSourceType.nextUpAlbum),
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
  const ShuffleAlbumsToNextUpPlaybackAction({super.key, required this.baseItem, this.popContext = true, this.genreFilter});

  final BaseItemDto baseItem;
  final bool popContext;
  final BaseItemDto? genreFilter;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final queueService = GetIt.instance<QueueService>();
    return PlaybackAction(
      enabled: !(Platform.isWindows || Platform.isLinux),
      icon: TablerIcons.corner_right_down_double,
      label: AppLocalizations.of(context)!.shuffleAlbumsToNextUp,
      onPressed: () async {
        await queueService.addToNextUp(
          items: groupItems(
            items: await loadChildTracks(item: baseItem, genreFilter: genreFilter),
            groupListBy: (element) => element.albumId?.toString(),
            manuallyShuffle: true,
          ),
          source: QueueItemSource.fromBaseItem(baseItem, type: QueueItemSourceType.nextUpAlbum),
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
    );
  }
}

class ShuffleAlbumsToQueuePlaybackAction extends ConsumerWidget {
  const ShuffleAlbumsToQueuePlaybackAction({super.key, required this.baseItem, this.popContext = true, this.genreFilter});

  final BaseItemDto baseItem;
  final bool popContext;
  final BaseItemDto? genreFilter;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final queueService = GetIt.instance<QueueService>();
    return PlaybackAction(
      icon: TablerIcons.playlist,
      label: AppLocalizations.of(context)!.shuffleAlbumsToQueue,
      onPressed: () async {
        await queueService.addToQueue(
          items: groupItems(
            items: await loadChildTracks(item: baseItem, genreFilter: genreFilter),
            groupListBy: (element) => element.albumId?.toString(),
            manuallyShuffle: true,
          ),
          source: QueueItemSource.fromBaseItem(baseItem),
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
