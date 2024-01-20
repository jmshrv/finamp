import 'package:finamp/models/jellyfin_models.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:hive/hive.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../models/finamp_models.dart';
import '../../services/downloads_helper.dart';
import '../../services/finamp_settings_helper.dart';
import '../../services/jellyfin_api_helper.dart';
import '../../services/queue_service.dart';
import '../album_image.dart';
import '../error_snackbar.dart';

class QueueRestoreTile extends StatelessWidget {
  const QueueRestoreTile({Key? key, required this.info}) : super(key: key);

  final FinampStorableQueueInfo info;

  @override
  Widget build(BuildContext context) {
    final queuesBox = Hive.box<FinampStorableQueueInfo>("Queues");
    final downloadsHelper = GetIt.instance<DownloadsHelper>();
    final jellyfinApiHelper = GetIt.instance<JellyfinApiHelper>();
    final queueService = GetIt.instance<QueueService>();
    int remainingSongs = info.songCount - info.previousTracks.length;
    Future<BaseItemDto?> track;
    if (info.currentTrack == null) {
      track = Future.value(null);
    } else if (FinampSettingsHelper.finampSettings.isOffline) {
      track = Future.value(
          downloadsHelper.getDownloadedSong(info.currentTrack!)?.song);
    } else {
      track = jellyfinApiHelper
          .getItemById(info.currentTrack!)
          .then((x) => x, onError: (_) => null);
    }

    return ListTile(
      title: Text(AppLocalizations.of(context)!.queueRestoreTitle(
          DateTime.fromMillisecondsSinceEpoch(info.creation))),
      leading: FutureBuilder<BaseItemDto?>(
          future: track,
          builder: (context, snapshot) => AlbumImage(item: snapshot.data)),
      isThreeLine: true,
      //dense: true,
      subtitle: FutureBuilder<BaseItemDto?>(
          future: track,
          initialData: null,
          builder: (context, snapshot) => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: ((snapshot.data?.name == null)
                      ? <Text>[]
                      : [
                          // exclude subtitle line 1 if song name is null
                          Text(
                              AppLocalizations.of(context)!
                                  .queueRestoreSubtitle1(snapshot.data!.name!),
                              overflow: TextOverflow.ellipsis)
                        ]) +
                  [
                    Text(AppLocalizations.of(context)!
                        .queueRestoreSubtitle2(info.songCount, remainingSongs))
                  ])),
      trailing: IconButton(
          icon: const Icon(Icons.arrow_circle_right_outlined),
          onPressed: () {
            var latest = queuesBox.get("latest");
            if (latest != null && latest.songCount != 0) {
              queuesBox.put(latest.creation.toString(), latest);
            }
            BuildContext parentContext = Navigator.of(context).context;
            queueService
                .loadSavedQueue(info)
                .catchError((x) => errorSnackbar(x, parentContext));
            Navigator.of(context).popUntil(
                (route) => route.isFirst && !route.willHandlePopInternally);
          }),
    );
  }
}
