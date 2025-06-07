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

Map<String, Widget> getPlaybackActionPages({
  required BuildContext context,
  required BaseItemDto baseItem,
}) {
  final queueService = GetIt.instance<QueueService>();
  switch (BaseItemDtoType.fromItem(baseItem)) {
    //TODO add case for custom (artists) options
    case BaseItemDtoType.artist:
      return {
        AppLocalizations.of(context)!.playbackActionPagePlay: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            PlayPlaybackAction(baseItem: baseItem),
            if (queueService.getQueue().nextUp.isNotEmpty)
              PlayNextPlaybackAction(baseItem: baseItem),
            AddToNextUpPlaybackAction(baseItem: baseItem),
            AddToQueuePlaybackAction(baseItem: baseItem),
          ],
        ),
        AppLocalizations.of(context)!.playbackActionPageShuffle: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ShufflePlaybackAction(baseItem: baseItem),
            if (queueService.getQueue().nextUp.isNotEmpty)
              ShuffleNextPlaybackAction(baseItem: baseItem),
            ShuffleToNextUpPlaybackAction(baseItem: baseItem),
            ShuffleToQueuePlaybackAction(baseItem: baseItem),
          ],
        ),
        AppLocalizations.of(context)!.playbackActionPageShuffleAlbums: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ShuffleAlbumsAction(baseItem: baseItem),
            if (queueService.getQueue().nextUp.isNotEmpty)
              ShuffleAlbumsNextPlaybackAction(baseItem: baseItem),
            ShuffleAlbumsToNextUpPlaybackAction(baseItem: baseItem),
            ShuffleAlbumsToQueuePlaybackAction(baseItem: baseItem),
          ],
        ),
      };
    default:
      return {
        AppLocalizations.of(context)!.playbackActionPagePlay: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            PlayPlaybackAction(baseItem: baseItem),
            if (queueService.getQueue().nextUp.isNotEmpty)
              PlayNextPlaybackAction(baseItem: baseItem),
            AddToNextUpPlaybackAction(baseItem: baseItem),
            AddToQueuePlaybackAction(baseItem: baseItem),
          ],
        ),
        // Shuffle
        AppLocalizations.of(context)!.playbackActionPageShuffle: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ShufflePlaybackAction(baseItem: baseItem),
            if (queueService.getQueue().nextUp.isNotEmpty)
              ShuffleNextPlaybackAction(baseItem: baseItem),
            ShuffleToNextUpPlaybackAction(baseItem: baseItem),
            ShuffleToQueuePlaybackAction(baseItem: baseItem),
          ],
        ),
      };
      break;
  }
}

class PlayPlaybackAction extends ConsumerWidget {
  const PlayPlaybackAction({
    super.key,
    required this.baseItem,
  });

  final BaseItemDto baseItem;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final queueService = GetIt.instance<QueueService>();
    return PlaybackAction(
      icon: TablerIcons.player_play,
      label: AppLocalizations.of(context)!.playButtonLabel,
      onPressed: (WidgetRef ref) async {
        await queueService.startPlayback(
          items: await ref.watch(loadChildTracksProvider(
                baseItem: baseItem,
              ).future) ??
              [],
          source: QueueItemSource.fromBaseItem(baseItem),
          order: FinampPlaybackOrder.linear,
        );

        GlobalSnackbar.message(
            (scaffold) => AppLocalizations.of(scaffold)!
                .confirmPlayNext(BaseItemDtoType.fromItem(baseItem).name),
            isConfirmation: true);
        Navigator.pop(context);
      },
      iconColor: Theme.of(context).colorScheme.primary,
    );
  }
}

class PlayNextPlaybackAction extends ConsumerWidget {
  const PlayNextPlaybackAction({
    super.key,
    required this.baseItem,
  });

  final BaseItemDto baseItem;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final queueService = GetIt.instance<QueueService>();
    return Visibility(
      visible: queueService.getQueue().nextUp.isNotEmpty,
      child: PlaybackAction(
        icon: TablerIcons.corner_right_down,
        label: AppLocalizations.of(context)!.playNext,
        onPressed: (WidgetRef ref) async {
          await queueService.addNext(
            items: await ref.watch(loadChildTracksProvider(
                  baseItem: baseItem,
                ).future) ??
                [],
            source: QueueItemSource.fromBaseItem(baseItem,
                type: QueueItemSourceType.nextUpAlbum),
          );

          GlobalSnackbar.message(
              (scaffold) => AppLocalizations.of(scaffold)!
                  .confirmPlayNext(BaseItemDtoType.fromItem(baseItem).name),
              isConfirmation: true);
          Navigator.pop(context);
        },
        iconColor: Theme.of(context).colorScheme.primary,
      ),
    );
  }
}

class AddToNextUpPlaybackAction extends ConsumerWidget {
  const AddToNextUpPlaybackAction({
    super.key,
    required this.baseItem,
  });

  final BaseItemDto baseItem;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final queueService = GetIt.instance<QueueService>();
    return PlaybackAction(
      icon: TablerIcons.corner_right_down_double,
      label: AppLocalizations.of(context)!.addToNextUp,
      onPressed: (WidgetRef ref) async {
        await queueService.addToNextUp(
          items: await ref.watch(loadChildTracksProvider(
                baseItem: baseItem,
              ).future) ??
              [],
          source: QueueItemSource.fromBaseItem(baseItem,
              type: QueueItemSourceType.nextUpAlbum),
        );

        GlobalSnackbar.message(
            (scaffold) => AppLocalizations.of(scaffold)!
                .confirmAddToNextUp(BaseItemDtoType.fromItem(baseItem).name),
            isConfirmation: true);
        Navigator.pop(context);
      },
      iconColor: Theme.of(context).colorScheme.primary,
    );
  }
}

class AddToQueuePlaybackAction extends ConsumerWidget {
  const AddToQueuePlaybackAction({
    super.key,
    required this.baseItem,
  });

  final BaseItemDto baseItem;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final queueService = GetIt.instance<QueueService>();
    return PlaybackAction(
      icon: TablerIcons.playlist,
      label: AppLocalizations.of(context)!.addToQueue,
      onPressed: (WidgetRef ref) async {
        await queueService.addToQueue(
          items: await ref.watch(loadChildTracksProvider(
                baseItem: baseItem,
              ).future) ??
              [],
          source: QueueItemSource.fromBaseItem(baseItem),
        );

        GlobalSnackbar.message(
            (scaffold) => AppLocalizations.of(scaffold)!
                .confirmAddToQueue(BaseItemDtoType.fromItem(baseItem).name),
            isConfirmation: true);
        Navigator.pop(context);
      },
      iconColor: Theme.of(context).colorScheme.primary,
    );
  }
}

class ShufflePlaybackAction extends ConsumerWidget {
  const ShufflePlaybackAction({
    super.key,
    required this.baseItem,
  });

  final BaseItemDto baseItem;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final queueService = GetIt.instance<QueueService>();
    return PlaybackAction(
      icon: TablerIcons.arrows_shuffle,
      label: AppLocalizations.of(context)!.shuffleButtonLabel,
      onPressed: (WidgetRef ref) async {
        await queueService.startPlayback(
          items: await ref.watch(loadChildTracksProvider(
                baseItem: baseItem,
              ).future) ??
              [],
          source: QueueItemSource.fromBaseItem(baseItem),
          order: FinampPlaybackOrder.shuffled,
        );

        Navigator.pop(context);
      },
      iconColor: Theme.of(context).colorScheme.primary,
    );
  }
}

class ShuffleNextPlaybackAction extends ConsumerWidget {
  const ShuffleNextPlaybackAction({
    super.key,
    required this.baseItem,
  });

  final BaseItemDto baseItem;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final queueService = GetIt.instance<QueueService>();
    return Visibility(
      visible: queueService.getQueue().nextUp.isNotEmpty,
      child: PlaybackAction(
        icon: TablerIcons.corner_right_down,
        label: AppLocalizations.of(context)!.shuffleNext,
        onPressed: (WidgetRef ref) async {
          await queueService.addNext(
            items: (await ref.watch(loadChildTracksProvider(
                  baseItem: baseItem,
                ).future) ??
                [])
              ..shuffle(),
            source: QueueItemSource.fromBaseItem(baseItem,
                type: QueueItemSourceType.nextUpAlbum),
          );

          GlobalSnackbar.message(
              (scaffold) => AppLocalizations.of(scaffold)!.confirmShuffleNext,
              isConfirmation: true);
          Navigator.pop(context);
        },
        iconColor: Theme.of(context).colorScheme.primary,
      ),
    );
  }
}

class ShuffleToNextUpPlaybackAction extends ConsumerWidget {
  const ShuffleToNextUpPlaybackAction({
    super.key,
    required this.baseItem,
  });

  final BaseItemDto baseItem;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final queueService = GetIt.instance<QueueService>();
    return PlaybackAction(
      icon: TablerIcons.corner_right_down_double,
      label: AppLocalizations.of(context)!.shuffleToNextUp,
      onPressed: (WidgetRef ref) async {
        await queueService.addToNextUp(
          items: (await ref.watch(loadChildTracksProvider(
                baseItem: baseItem,
              ).future) ??
              [])
            ..shuffle(),
          source: QueueItemSource.fromBaseItem(baseItem,
              type: QueueItemSourceType.nextUpAlbum),
        );

        GlobalSnackbar.message(
            (scaffold) => AppLocalizations.of(scaffold)!.confirmShuffleToNextUp,
            isConfirmation: true);
        Navigator.pop(context);
      },
      iconColor: Theme.of(context).colorScheme.primary,
    );
  }
}

class ShuffleToQueuePlaybackAction extends ConsumerWidget {
  const ShuffleToQueuePlaybackAction({
    super.key,
    required this.baseItem,
  });

  final BaseItemDto baseItem;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final queueService = GetIt.instance<QueueService>();
    return PlaybackAction(
      icon: TablerIcons.playlist,
      label: AppLocalizations.of(context)!.shuffleToQueue,
      onPressed: (WidgetRef ref) async {
        await queueService.addToQueue(
          items: (await ref.watch(loadChildTracksProvider(
                baseItem: baseItem,
              ).future) ??
              [])
            ..shuffle(),
          source: QueueItemSource.fromBaseItem(baseItem),
        );

        GlobalSnackbar.message(
            (scaffold) => AppLocalizations.of(scaffold)!.confirmShuffleToQueue,
            isConfirmation: true);
        Navigator.pop(context);
      },
      iconColor: Theme.of(context).colorScheme.primary,
    );
  }
}

class ShuffleAlbumsAction extends ConsumerWidget {
  const ShuffleAlbumsAction({
    super.key,
    required this.baseItem,
  });

  final BaseItemDto baseItem;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final queueService = GetIt.instance<QueueService>();
    return PlaybackAction(
      icon: TablerIcons.arrows_shuffle,
      label: AppLocalizations.of(context)!.shuffleAlbums,
      onPressed: (WidgetRef ref) async {
        await queueService.startPlayback(
          items: (await ref.watch(loadChildTracksProvider(
                baseItem: baseItem,
                groupListBy: (element) => element.albumId?.toString(),
                manuallyShuffle: true,
              ).future) ??
              []),
          source: QueueItemSource.fromBaseItem(baseItem,
              type: QueueItemSourceType.nextUpAlbum),
        );

        Navigator.pop(context);
      },
      iconColor: Theme.of(context).colorScheme.primary,
    );
  }
}

class ShuffleAlbumsNextPlaybackAction extends ConsumerWidget {
  const ShuffleAlbumsNextPlaybackAction({
    super.key,
    required this.baseItem,
  });

  final BaseItemDto baseItem;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final queueService = GetIt.instance<QueueService>();
    return Visibility(
      visible: queueService.getQueue().nextUp.isNotEmpty,
      child: PlaybackAction(
        icon: TablerIcons.corner_right_down,
        label: AppLocalizations.of(context)!.shuffleAlbumsNext,
        onPressed: (WidgetRef ref) async {
          await queueService.addNext(
            items: (await ref.watch(loadChildTracksProvider(
                  baseItem: baseItem,
                  groupListBy: (element) => element.albumId?.toString(),
                  manuallyShuffle: true,
                ).future) ??
                []),
            source: QueueItemSource.fromBaseItem(baseItem,
                type: QueueItemSourceType.nextUpAlbum),
          );

          GlobalSnackbar.message(
              (scaffold) => AppLocalizations.of(scaffold)!.confirmShuffleNext,
              isConfirmation: true);
          Navigator.pop(context);
        },
        iconColor: Theme.of(context).colorScheme.primary,
      ),
    );
  }
}

class ShuffleAlbumsToNextUpPlaybackAction extends ConsumerWidget {
  const ShuffleAlbumsToNextUpPlaybackAction({
    super.key,
    required this.baseItem,
  });

  final BaseItemDto baseItem;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final queueService = GetIt.instance<QueueService>();
    return PlaybackAction(
      icon: TablerIcons.corner_right_down_double,
      label: AppLocalizations.of(context)!.shuffleAlbumsToNextUp,
      onPressed: (WidgetRef ref) async {
        await queueService.addToNextUp(
          items: (await ref.watch(loadChildTracksProvider(
                baseItem: baseItem,
                groupListBy: (element) => element.albumId?.toString(),
                manuallyShuffle: true,
              ).future) ??
              []),
          source: QueueItemSource.fromBaseItem(baseItem,
              type: QueueItemSourceType.nextUpAlbum),
        );

        GlobalSnackbar.message(
            (scaffold) => AppLocalizations.of(scaffold)!.confirmShuffleToNextUp,
            isConfirmation: true);
        Navigator.pop(context);
      },
      iconColor: Theme.of(context).colorScheme.primary,
    );
  }
}

class ShuffleAlbumsToQueuePlaybackAction extends ConsumerWidget {
  const ShuffleAlbumsToQueuePlaybackAction({
    super.key,
    required this.baseItem,
  });

  final BaseItemDto baseItem;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final queueService = GetIt.instance<QueueService>();
    return PlaybackAction(
      icon: TablerIcons.playlist,
      label: AppLocalizations.of(context)!.shuffleAlbumsToQueue,
      onPressed: (WidgetRef ref) async {
        await queueService.addToQueue(
          items: (await ref.watch(loadChildTracksProvider(
                baseItem: baseItem,
                groupListBy: (element) => element.albumId?.toString(),
                manuallyShuffle: true,
              ).future) ??
              []),
          source: QueueItemSource.fromBaseItem(baseItem),
        );

        GlobalSnackbar.message(
            (scaffold) => AppLocalizations.of(scaffold)!.confirmShuffleToQueue,
            isConfirmation: true);
        Navigator.pop(context);
      },
      iconColor: Theme.of(context).colorScheme.primary,
    );
  }
}
