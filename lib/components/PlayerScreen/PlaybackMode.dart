import 'package:flutter/material.dart';
import 'package:audio_service/audio_service.dart';
import 'package:get_it/get_it.dart';

import '../../services/MusicPlayerBackgroundTask.dart';

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
          if (snapshot.data!.extras!["downloadedSongJson"] == "null") {
            onlineOrOffline = "STREAMING";
          } else {
            onlineOrOffline = "DOWNLOADED";
          }

          if (snapshot.data!.extras!["shouldTranscode"] &&
              snapshot.data!.extras!["downloadedSongJson"] == "null") {
            transcodeOrDirect = "TRANSCODE";
          } else {
            transcodeOrDirect = "DIRECT";
          }

          return Text(
            "$onlineOrOffline\n$transcodeOrDirect",
            style: Theme.of(context).textTheme.caption,
          );
        } else if (snapshot.hasError) {
          return Text(
            "STATUS ERROR",
            style: Theme.of(context).textTheme.caption,
          );
        } else {
          return Text(
            "NO ITEM",
            style: Theme.of(context).textTheme.caption,
          );
        }
      },
    );
  }
}
