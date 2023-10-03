import 'package:finamp/screens/album_screen.dart';
import 'package:finamp/screens/artist_screen.dart';
import 'package:finamp/screens/music_screen.dart';
import 'package:finamp/services/finamp_settings_helper.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_vibrate/flutter_vibrate.dart';
import 'package:get_it/get_it.dart';
import 'package:audio_service/audio_service.dart';
import 'package:palette_generator/palette_generator.dart';

import '../../models/jellyfin_models.dart' as jellyfin_models;
import '../../models/finamp_models.dart';
import 'package:finamp/services/queue_service.dart';

class PlayerScreenAppBarTitle extends StatefulWidget {

  const PlayerScreenAppBarTitle({Key? key}) : super(key: key);

  @override
  State<PlayerScreenAppBarTitle> createState() => _PlayerScreenAppBarTitleState();
}

class _PlayerScreenAppBarTitleState extends State<PlayerScreenAppBarTitle> {
  final QueueService _queueService = GetIt.instance<QueueService>();

  @override
  Widget build(BuildContext context) {

    final currentTrackStream = _queueService.getCurrentTrackStream();

    return StreamBuilder<FinampQueueItem?>(
      stream: currentTrackStream,
      initialData: _queueService.getCurrentTrack(),
      builder: (context, snapshot) {
        final queueItem = snapshot.data!;

        return Baseline(
          baselineType: TextBaseline.alphabetic,
          baseline: 0,
          child: GestureDetector(
            onTap: () => navigateToSource(context, queueItem.source),
            child: Column(
              children: [
                Text(AppLocalizations.of(context)!.playingFromType(queueItem.source.type.toString()),
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w300,
                    color: Colors.white.withOpacity(0.7),
                  ),
                ),
                const Padding(padding: EdgeInsets.symmetric(vertical: 2)),
                Text(
                  queueItem.source.name.getLocalized(context),
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

void navigateToSource(BuildContext context, QueueItemSource source) async {
  
  switch (source.type) {
    case QueueItemSourceType.album:
      Navigator.of(context).pushNamed(AlbumScreen.routeName, arguments: source.item);
      break;
    case QueueItemSourceType.artist:
      Navigator.of(context).pushNamed(ArtistScreen.routeName, arguments: source.item);
      break;
    case QueueItemSourceType.genre:
      Navigator.of(context).pushNamed(ArtistScreen.routeName, arguments: source.item);
      break;
    case QueueItemSourceType.playlist:
      Navigator.of(context).pushNamed(AlbumScreen.routeName, arguments: source.item);
      break;
    case QueueItemSourceType.albumMix:
      Navigator.of(context).pushNamed(AlbumScreen.routeName, arguments: source.item);
      break;
    case QueueItemSourceType.artistMix:
      Navigator.of(context).pushNamed(ArtistScreen.routeName, arguments: source.item);
      break;
    case QueueItemSourceType.songs:
      Navigator.of(context).pushNamed(MusicScreen.routeName, arguments: FinampSettingsHelper.finampSettings.showTabs.entries
        .where((element) => element.value == true)
        .map((e) => e.key)
        .toList().indexOf(TabContentType.songs)
      );
      break;
    case QueueItemSourceType.nextUp:
      break;
    case QueueItemSourceType.formerNextUp:
      break;
    case QueueItemSourceType.unknown:
      break;
    case QueueItemSourceType.favorites:
    case QueueItemSourceType.songMix:
    case QueueItemSourceType.filteredList:
    case QueueItemSourceType.downloads:
    default:
      Vibrate.feedback(FeedbackType.warning);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Not implemented yet."),
          // action: SnackBarAction(
          //   label: "OPEN",
          //   onPressed: () {
          //     Navigator.of(context).pushNamed(
          //         "/music/albumscreen",
          //         arguments: snapshot.data![index]);
          //   },
          // ),
        ),
      );
  }
  
}
