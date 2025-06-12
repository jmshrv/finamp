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
      onPressed: () async {
        await queueService.startPlayback(
          items: await loadChildTracks(
                baseItem: baseItem,
              ) ??
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
      iconColor: Theme.of(context).textTheme.bodyMedium?.color ?? Colors.white,
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
        onPressed: () async {
          await queueService.addNext(
            items: await loadChildTracks(
                  baseItem: baseItem,
                ) ??
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
        iconColor:
            Theme.of(context).textTheme.bodyMedium?.color ?? Colors.white,
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
      onPressed: () async {
        await queueService.addToNextUp(
          items: await loadChildTracks(
                baseItem: baseItem,
              ) ??
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
      iconColor: Theme.of(context).textTheme.bodyMedium?.color ?? Colors.white,
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
      onPressed: () async {
        await queueService.addToQueue(
          items: await loadChildTracks(
                baseItem: baseItem,
              ) ??
              [],
          source: QueueItemSource.fromBaseItem(baseItem),
        );

        GlobalSnackbar.message(
            (scaffold) => AppLocalizations.of(scaffold)!
                .confirmAddToQueue(BaseItemDtoType.fromItem(baseItem).name),
            isConfirmation: true);
        Navigator.pop(context);
      },
      iconColor: Theme.of(context).textTheme.bodyMedium?.color ?? Colors.white,
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
      onPressed: () async {
        await queueService.startPlayback(
          items: await loadChildTracks(
                baseItem: baseItem,
              ) ??
              [],
          source: QueueItemSource.fromBaseItem(baseItem),
          order: FinampPlaybackOrder.shuffled,
        );

        Navigator.pop(context);
      },
      iconColor: Theme.of(context).textTheme.bodyMedium?.color ?? Colors.white,
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
        onPressed: () async {
          await queueService.addNext(
            items: (await loadChildTracks(
                  baseItem: baseItem,
                ) ??
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
        iconColor:
            Theme.of(context).textTheme.bodyMedium?.color ?? Colors.white,
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
      onPressed: () async {
        await queueService.addToNextUp(
          items: (await loadChildTracks(
                baseItem: baseItem,
              ) ??
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
      iconColor: Theme.of(context).textTheme.bodyMedium?.color ?? Colors.white,
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
      onPressed: () async {
        await queueService.addToQueue(
          items: (await loadChildTracks(
                baseItem: baseItem,
              ) ??
              [])
            ..shuffle(),
          source: QueueItemSource.fromBaseItem(baseItem),
        );

        GlobalSnackbar.message(
            (scaffold) => AppLocalizations.of(scaffold)!.confirmShuffleToQueue,
            isConfirmation: true);
        Navigator.pop(context);
      },
      iconColor: Theme.of(context).textTheme.bodyMedium?.color ?? Colors.white,
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
      onPressed: () async {
        await queueService.startPlayback(
          items: (await loadChildTracks(
                baseItem: baseItem,
                groupListBy: (element) => element.albumId?.toString(),
                manuallyShuffle: true,
              ) ??
              []),
          source: QueueItemSource.fromBaseItem(baseItem,
              type: QueueItemSourceType.nextUpAlbum),
        );

        Navigator.pop(context);
      },
      iconColor: Theme.of(context).textTheme.bodyMedium?.color ?? Colors.white,
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
        onPressed: () async {
          await queueService.addNext(
            items: (await loadChildTracks(
                  baseItem: baseItem,
                  groupListBy: (element) => element.albumId?.toString(),
                  manuallyShuffle: true,
                ) ??
                []),
            source: QueueItemSource.fromBaseItem(baseItem,
                type: QueueItemSourceType.nextUpAlbum),
          );

          GlobalSnackbar.message(
              (scaffold) => AppLocalizations.of(scaffold)!.confirmShuffleNext,
              isConfirmation: true);
          Navigator.pop(context);
        },
        iconColor:
            Theme.of(context).textTheme.bodyMedium?.color ?? Colors.white,
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
      onPressed: () async {
        await queueService.addToNextUp(
          items: (await loadChildTracks(
                baseItem: baseItem,
                groupListBy: (element) => element.albumId?.toString(),
                manuallyShuffle: true,
              ) ??
              []),
          source: QueueItemSource.fromBaseItem(baseItem,
              type: QueueItemSourceType.nextUpAlbum),
        );

        GlobalSnackbar.message(
            (scaffold) => AppLocalizations.of(scaffold)!.confirmShuffleToNextUp,
            isConfirmation: true);
        Navigator.pop(context);
      },
      iconColor: Theme.of(context).textTheme.bodyMedium?.color ?? Colors.white,
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
      onPressed: () async {
        await queueService.addToQueue(
          items: (await loadChildTracks(
                baseItem: baseItem,
                groupListBy: (element) => element.albumId?.toString(),
                manuallyShuffle: true,
              ) ??
              []),
          source: QueueItemSource.fromBaseItem(baseItem),
        );

        GlobalSnackbar.message(
            (scaffold) => AppLocalizations.of(scaffold)!.confirmShuffleToQueue,
            isConfirmation: true);
        Navigator.pop(context);
      },
      iconColor: Theme.of(context).textTheme.bodyMedium?.color ?? Colors.white,
    );
  }
}
