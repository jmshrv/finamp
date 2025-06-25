import 'dart:async';

import 'package:finamp/components/MusicScreen/item_collection_wrapper.dart';
import 'package:finamp/models/jellyfin_models.dart';
import 'package:flutter/material.dart';
import 'package:finamp/l10n/app_localizations.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:get_it/get_it.dart';

import '../../models/finamp_models.dart';
import '../../services/downloads_service.dart';
import '../../services/finamp_settings_helper.dart';
import '../../services/jellyfin_api_helper.dart';
import '../../services/queue_service.dart';
import '../album_image.dart';
import '../global_snackbar.dart';

class QueueRestoreTile extends StatelessWidget {
  const QueueRestoreTile({super.key, required this.info});

  final FinampStorableQueueInfo info;

  @override
  Widget build(BuildContext context) {
    final isarDownloader = GetIt.instance<DownloadsService>();
    final jellyfinApiHelper = GetIt.instance<JellyfinApiHelper>();
    final queueService = GetIt.instance<QueueService>();
    int remainingTracks = info.trackCount - info.previousTracks.length;
    Future<BaseItemDto?> track;
    if (info.currentTrack == null) {
      track = Future.value(null);
    } else if (FinampSettingsHelper.finampSettings.isOffline) {
      track = isarDownloader.getTrackInfo(id: info.currentTrack!).then((value) => value?.baseItem);
    } else {
      track = jellyfinApiHelper.getItemById(info.currentTrack!).then((x) => x, onError: (_) => null);
    }

    return ListTileTheme(
      // Do not pad between components.  leading/trailing widgets will handle spacing.
      horizontalTitleGap: 0,
      // Shrink trailing padding from 24 to 16
      contentPadding: const EdgeInsetsDirectional.only(start: 16.0, end: 16.0),
      child: ListTile(
        title: Text(info.source?.name.getLocalized(context) ?? AppLocalizations.of(context)!.unknown),
        leading: Padding(
          padding: const EdgeInsets.only(right: 16),
          child: FutureBuilder<BaseItemDto?>(
            future: track,
            builder: (context, snapshot) => AlbumImage(item: snapshot.data),
          ),
        ),
        isThreeLine: true,
        //dense: true,
        subtitle: FutureBuilder<BaseItemDto?>(
          future: track,
          initialData: null,
          builder: (context, snapshot) => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                AppLocalizations.of(context)!.queueRestoreTitle(DateTime.fromMillisecondsSinceEpoch(info.creation)),
                style: Theme.of(context).textTheme.bodySmall,
              ),
              ...((snapshot.data?.name == null)
                  ? <Text>[]
                  : [
                      // exclude subtitle line 1 if track name is null
                      Text(
                        AppLocalizations.of(context)!.queueRestoreSubtitle1(snapshot.data!.name!),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ]),
              Text(
                AppLocalizations.of(context)!.queueRestoreSubtitle2(info.trackCount, remainingTracks),
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
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
