import 'package:flutter/material.dart';

class ViewIcon extends StatelessWidget {
  const ViewIcon({Key? key, required this.collectionType}) : super(key: key);

  final String? collectionType;

  @override
  Widget build(BuildContext context) {
    switch (collectionType) {
      case "movies":
        return Icon(Icons.movie);
      case "tvshows":
        return Icon(Icons.tv);
      case "music":
        return Icon(Icons.music_note);
      case "games":
        return Icon(Icons.games);
      case "books":
        return Icon(Icons.book);
      case "musicvideos":
        return Icon(Icons.music_video);
      case "homevideos":
        return Icon(Icons.videocam);
      case "livetv":
        return Icon(Icons.live_tv);
      case "channels":
        return Icon(Icons.settings_remote);
      case "playlists":
        return Icon(Icons.queue_music);
      default:
        return Icon(Icons.warning);
    }
  }
}
