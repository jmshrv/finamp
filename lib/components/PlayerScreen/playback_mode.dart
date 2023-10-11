import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:audio_service/audio_service.dart';
import 'package:get_it/get_it.dart';

import '../../services/music_player_background_task.dart';

class PlaybackMode extends StatelessWidget {
  const PlaybackMode({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final audioHandler = GetIt.instance<MusicPlayerBackgroundTask>();

    return StreamBuilder<MediaItem?>(
      stream: audioHandler.mediaItem,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          late String onlineOrOffline;
          late String transcodeOrDirect;
          if (snapshot.data!.extras!["downloadedSongJson"] == null) {
            onlineOrOffline = AppLocalizations.of(context)!.streaming;
          } else {
            onlineOrOffline = AppLocalizations.of(context)!.downloaded;
          }

          if (snapshot.data!.extras!["shouldTranscode"] &&
              snapshot.data!.extras!["downloadedSongJson"] == null) {
            transcodeOrDirect = AppLocalizations.of(context)!.transcode;
          } else {
            transcodeOrDirect = AppLocalizations.of(context)!.direct;
          }

          return Text(
            "$onlineOrOffline\n$transcodeOrDirect",
            style: Theme.of(context).textTheme.bodySmall,
          );
        } else if (snapshot.hasError) {
          return Text(
            AppLocalizations.of(context)!.statusError,
            style: Theme.of(context).textTheme.bodySmall,
          );
        } else {
          return Text(
            AppLocalizations.of(context)!.noItem.toUpperCase(),
            style: Theme.of(context).textTheme.bodySmall,
          );
        }
      },
    );
  }
}
