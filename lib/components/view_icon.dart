import 'package:flutter/material.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';

class ViewIcon extends StatelessWidget {
  const ViewIcon({
    super.key,
    required this.collectionType,
    this.color,
  });

  final String? collectionType;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    switch (collectionType) {
      case "movies":
        return Icon(
          Icons.movie,
          color: color,
        );
      case "tvshows":
        return Icon(
          Icons.tv,
          color: color,
        );
      case "music":
        return Icon(
          Icons.music_note,
          color: color,
        );
      case "games":
        return Icon(
          Icons.games,
          color: color,
        );
      case "books":
        return Icon(
          Icons.book,
          color: color,
        );
      case "musicvideos":
        return Icon(
          Icons.music_video,
          color: color,
        );
      case "homevideos":
        return Icon(
          Icons.videocam,
          color: color,
        );
      case "livetv":
        return Icon(
          Icons.live_tv,
          color: color,
        );
      case "channels":
        return Icon(
          Icons.settings_remote,
          color: color,
        );
      case "playlists":
        return Icon(
          TablerIcons.playlist,
          color: color,
        );
      default:
        return Icon(
          Icons.warning,
          color: color,
        );
    }
  }
}
