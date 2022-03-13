import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../services/JellyfinApiData.dart';
import '../screens/UserSelector.dart';
import '../screens/MusicScreen.dart';
import '../screens/ViewSelector.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    JellyfinApiData jellyfinApiData = GetIt.instance<JellyfinApiData>();

    if (jellyfinApiData.currentUser == null) {
      return const UserSelector();
    } else if (jellyfinApiData.currentUser!.currentView == null) {
      return const ViewSelector();
    } else {
      return const MusicScreen();
    }
  }
}
