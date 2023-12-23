import 'package:finamp/models/finamp_models.dart';
import 'package:finamp/screens/album_screen.dart';
import 'package:finamp/screens/artist_screen.dart';
import 'package:finamp/screens/music_screen.dart';
import 'package:finamp/services/finamp_settings_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vibrate/flutter_vibrate.dart';

void navigateToSource(BuildContext context, QueueItemSource source) async {
  switch (source.type) {
    case QueueItemSourceType.album:
    case QueueItemSourceType.nextUpAlbum:
      Navigator.of(context)
          .pushNamed(AlbumScreen.routeName, arguments: source.item);
      break;
    case QueueItemSourceType.artist:
    case QueueItemSourceType.nextUpArtist:
      Navigator.of(context)
          .pushNamed(ArtistScreen.routeName, arguments: source.item);
      break;
    case QueueItemSourceType.genre:
      Navigator.of(context)
          .pushNamed(ArtistScreen.routeName, arguments: source.item);
      break;
    case QueueItemSourceType.playlist:
    case QueueItemSourceType.nextUpPlaylist:
      Navigator.of(context)
          .pushNamed(AlbumScreen.routeName, arguments: source.item);
      break;
    case QueueItemSourceType.albumMix:
      Navigator.of(context)
          .pushNamed(AlbumScreen.routeName, arguments: source.item);
      break;
    case QueueItemSourceType.artistMix:
      Navigator.of(context)
          .pushNamed(ArtistScreen.routeName, arguments: source.item);
      break;
    case QueueItemSourceType.allSongs:
      Navigator.of(context).pushNamed(MusicScreen.routeName,
          arguments: FinampSettingsHelper.finampSettings.showTabs.entries
              .where((element) => element.value == true)
              .map((e) => e.key)
              .toList()
              .indexOf(TabContentType.songs));
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
