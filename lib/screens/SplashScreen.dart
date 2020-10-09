import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../services/JellyfinApiData.dart';
import '../screens/ServerSelector.dart';
import '../screens/UserSelector.dart';
import '../screens/MusicScreen.dart';
import '../screens/ViewSelector.dart';

class SplashScreen extends StatefulWidget {
  SplashScreen({Key key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  List<Future> splashScreenFutures;
  JellyfinApiData jellyfinApiData = GetIt.instance<JellyfinApiData>();

  @override
  void initState() {
    super.initState();
    splashScreenFutures = [
      jellyfinApiData.getBaseUrl(),
      jellyfinApiData.getCurrentUser(),
      jellyfinApiData.getView()
    ];
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Future.wait(splashScreenFutures),
      builder: (context, snapshot) {
        // snapshot.data[0]: baseUrl
        // snapshot.data[1]: getCurrentUser
        // snapshot.data[2]: getView
        if (snapshot.hasData) {
          if (snapshot.data[0] == null) {
            print("No saved base URL. Going to server selector.");
            return ServerSelector();
          } else if (snapshot.data[1] == null) {
            print("No saved user. Going to user selector.");
            return UserSelector();
          } else if (snapshot.data[2] == null) {
            print("No saved view. Going to view selector.");
            return ViewSelector();
          } else {
            print("Base URL, user, and view exist. Going to music screen.");
            return MusicScreen();
          }
        } else {
          return Scaffold();
        }
      },
    );
  }
}
