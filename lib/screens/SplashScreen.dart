import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../services/JellyfinApiData.dart';
import '../screens/UserSelector.dart';
import '../screens/MusicScreen.dart';
import '../screens/ViewSelector.dart';

class SplashScreen extends StatelessWidget {
  SplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    JellyfinApiData jellyfinApiData = GetIt.instance<JellyfinApiData>();

    if (jellyfinApiData.currentUser == null) {
      print("No saved user. Going to server selector.");
      return UserSelector();
    } else if (jellyfinApiData.currentUser!.view == null) {
      print("No saved view. Going to view selector.");
      return ViewSelector();
    } else {
      print("User and view exist. Going to music screen.");
      return MusicScreen();
    }
  }
}
