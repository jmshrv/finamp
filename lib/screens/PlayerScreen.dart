import 'package:finamp/components/AlbumImage.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'dart:io' show Platform;

import '../models/JellyfinModels.dart';
import '../services/JellyfinApiData.dart';
import '../components/printDuration.dart';

class PlayerScreen extends StatelessWidget {
  const PlayerScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final BaseItemDto item = ModalRoute.of(context).settings.arguments;
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              FractionallySizedBox(
                  widthFactor: 0.75, child: AlbumImage(item: item)),
              Column(
                children: [
                  Column(
                    children: [
                      Text(
                        item.name,
                        style: Theme.of(context).textTheme.headline6,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        textAlign: TextAlign.center,
                      ),
                      Padding(padding: EdgeInsets.symmetric(vertical: 2)),
                      Text(
                        item.albumArtist,
                        style: Theme.of(context).textTheme.caption,
                      )
                    ],
                  ),
                ],
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("00:00"),
                    Expanded(
                      child: Slider(
                        value: 5,
                        onChanged: (value) {},
                        max: 10,
                      ),
                    ),
                    Text(printDuration(
                      Duration(microseconds: (item.runTimeTicks ~/ 10)),
                    )),
                  ],
                ),
              ),
              Row(
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
                  IconButton(
                      icon: Icon(Icons.skip_next),
                      onPressed: () {},
                      iconSize: 36),
                  IconButton(
                    icon: Icon(Icons.loop),
                    onPressed: () {},
                    iconSize: 20,
                  ),
                ],
              ),
              IconButton(
                  iconSize: 36,
                  icon: Icon(
                    Icons.keyboard_arrow_down,
                    color: Colors.grey,
                  ),
                  onPressed: () => Navigator.of(context).pop())
            ],
          ),
        ),
      ),
    );
  }
}
