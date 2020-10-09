import 'package:flutter/material.dart';

/// Creates some text that shows the song's name and the artist.
class SongName extends StatelessWidget {
  const SongName({Key key, @required this.songName, @required this.artist})
      : super(key: key);

  final String songName;
  final String artist;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          songName,
          style: Theme.of(context).textTheme.headline6,
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
          textAlign: TextAlign.center,
        ),
        Padding(padding: EdgeInsets.symmetric(vertical: 2)),
        Text(
          artist,
          style: Theme.of(context).textTheme.caption,
        )
      ],
    );
  }
}
