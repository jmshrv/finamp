import 'package:finamp/components/AlbumImage.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'dart:io' show Platform;

import '../models/JellyfinModels.dart';
import '../services/JellyfinApiData.dart';
import '../components/printDuration.dart';
import '../components/PlayerScreen/SongName.dart';
import '../components/PlayerScreen/ProgressSlider.dart';
import '../components/PlayerScreen/PlayerButtons.dart';
import '../components/PlayerScreen/ExitButton.dart';

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
              SongName(songName: item.name, artist: item.albumArtist),
              Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: ProgressSlider(
                    songProgress: 0,
                    songLength: item.runTimeTicks,
                  )),
              PlayerButtons(),
              ExitButton()
            ],
          ),
        ),
      ),
    );
  }
}
