import 'package:flutter/material.dart';

class PlayerButtons extends StatelessWidget {
  const PlayerButtons({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        IconButton(
          icon: Icon(Icons.shuffle),
          onPressed: () {},
          iconSize: 20,
        ),
        IconButton(
          icon: Icon(Icons.skip_previous),
          onPressed: () {},
          iconSize: 36,
        ),
        SizedBox(
          height: 56,
          width: 56,
          child: FloatingActionButton(
            // We set a heroTag because otherwise the play button on AlbumScreenContent will do hero widget stuff
            heroTag: "PlayerScreenFAB",
            onPressed: () {},
            child: Icon(
              Icons.play_arrow,
              size: 36,
            ),
          ),
        ),
        IconButton(icon: Icon(Icons.skip_next), onPressed: () {}, iconSize: 36),
        IconButton(
          icon: Icon(Icons.loop),
          onPressed: () {},
          iconSize: 20,
        ),
      ],
    );
  }
}
