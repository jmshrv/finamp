import 'dart:async';

import 'package:finamp/components/MusicScreen/item_collection_wrapper.dart';
import 'package:finamp/l10n/app_localizations.dart';
import 'package:finamp/models/jellyfin_models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:get_it/get_it.dart';

import '../../models/finamp_models.dart';
import '../../services/downloads_service.dart';
import '../../services/finamp_settings_helper.dart';
import '../../services/jellyfin_api_helper.dart';
import '../../services/queue_service.dart';
import '../album_image.dart';
import '../global_snackbar.dart';

class QueueRestoreTile extends ConsumerWidget {
  const QueueRestoreTile({super.key, required this.info});

  final FinampStorableQueueInfo info;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final queueService = GetIt.instance<QueueService>();
    int remainingTracks = info.trackCount - info.previousTracks.length;

    BaseItemDto? track = ref.watch(trackProvider(info.currentTrack)).value;

    return ListTileTheme(
      // Do not pad between components.  leading/trailing widgets will handle spacing.
      horizontalTitleGap: 0,
      // Shrink trailing padding from 24 to 16
      contentPadding: const EdgeInsetsDirectional.only(start: 16.0, end: 16.0),
      child: ListTile(
        title: Text(info.source?.name.getLocalized(context) ?? AppLocalizations.of(context)!.unknown),
        leading: Padding(
          padding: const EdgeInsets.only(right: 16),
          child: AlbumImage(item: track),
        ),
        isThreeLine: true,
        //dense: true,
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              AppLocalizations.of(context)!.queueRestoreTitle(DateTime.fromMillisecondsSinceEpoch(info.creation)),
              style: Theme.of(context).textTheme.bodySmall,
            ),
            ...((track?.name == null)
                ? <Text>[]
                : [
                    // exclude subtitle line 1 if track name is null
                    Text(
                      AppLocalizations.of(context)!.queueRestoreSubtitle1(track!.name!),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ]),
            Text(
              AppLocalizations.of(context)!.queueRestoreSubtitle2(info.trackCount, remainingTracks),
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
        onLongPress: () => {
          if (info.source?.item != null) {openItemMenu(context: context, item: info.source!.item!, queueInfo: info)},
        },
        trailing: IconButton(
          icon: const Icon(TablerIcons.restore),
          onPressed: () {
            queueService.archiveSavedQueue();
            unawaited(queueService.loadSavedQueue(info).catchError(GlobalSnackbar.error));
            Navigator.of(context).popUntil((route) => route.isFirst && !route.willHandlePopInternally);
          },
        ),
      ),
    );
  }
}

final AutoDisposeFutureProviderFamily<BaseItemDto?, BaseItemId?> trackProvider = FutureProvider.autoDispose
    .family<BaseItemDto?, BaseItemId?>((ref, itemId) async {
      if (itemId == null) {
        return null;
      } else if (ref.watch(finampSettingsProvider.isOffline)) {
        return GetIt.instance<DownloadsService>().getTrackInfo(id: itemId).then((value) => value?.baseItem);
      } else {
        return GetIt.instance<JellyfinApiHelper>().getItemById(itemId).then((x) => x, onError: (_) => null);
      }
    });
