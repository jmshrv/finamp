import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:logging/logging.dart';

import 'dart:math';

import 'screens/ServerSelector.dart';
import 'screens/UserSelector.dart';
import 'screens/MusicScreen.dart';
import 'screens/ViewSelector.dart';
import 'screens/AlbumScreen.dart';
import 'screens/PlayerScreen.dart';
import 'screens/SplashScreen.dart';
import 'services/JellyfinApiData.dart';

void main() {
  _setupLogging();
  _setupJellyfinApiData();
  runApp(Finamp());
}

void _setupLogging() {
  Logger.root.level = Level.ALL;
  Logger.root.onRecord.listen((event) =>
      print("[${event.level.name}] ${event.time}: ${event.message}"));
}

void _setupJellyfinApiData() {
  GetIt.instance.registerLazySingleton(() => JellyfinApiData());
}

class Finamp extends StatelessWidget {
  const Finamp({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const Color accentColor = Color(0xFF00A4DC);
    const Color raisedDarkColor = Color(0xFF202020);
    return AudioServiceWidget(
      // This gesture detector is for dismissing the keyboard by tapping on the screen
      child: GestureDetector(
        onTap: () {
          FocusScopeNode currentFocus = FocusScope.of(context);

          if (!currentFocus.hasPrimaryFocus &&
              currentFocus.focusedChild != null) {
            FocusManager.instance.primaryFocus.unfocus();
          }
        },
        child: MaterialApp(
          routes: {
            "/": (context) => SplashScreen(),
            "/login/serverSelector": (context) => ServerSelector(),
            "/login/userSelector": (context) => UserSelector(),
            "/settings/views": (context) => ViewSelector(),
            "/music": (context) => MusicScreen(),
            "/music/albumscreen": (context) => AlbumScreen(),
            "/nowplaying": (context) => PlayerScreen()
          },
          initialRoute: "/",
          darkTheme: ThemeData(
            primarySwatch: generateMaterialColor(accentColor),
            brightness: Brightness.dark,
            scaffoldBackgroundColor: Color(0xFF101010),
            appBarTheme: AppBarTheme(
              color: raisedDarkColor,
            ),
            cardColor: raisedDarkColor,
            accentColor: accentColor,
            bottomNavigationBarTheme: BottomNavigationBarThemeData(
              backgroundColor: raisedDarkColor,
            ),
          ),
          themeMode: ThemeMode.dark,
        ),
      ),
    );
  }
}

MaterialColor generateMaterialColor(Color color) {
  return MaterialColor(color.value, {
    50: tintColor(color, 0.9),
    100: tintColor(color, 0.8),
    200: tintColor(color, 0.6),
    300: tintColor(color, 0.4),
    400: tintColor(color, 0.2),
    500: color,
    600: shadeColor(color, 0.1),
    700: shadeColor(color, 0.2),
    800: shadeColor(color, 0.3),
    900: shadeColor(color, 0.4),
  });
}

int tintValue(int value, double factor) =>
    max(0, min((value + ((255 - value) * factor)).round(), 255));

Color tintColor(Color color, double factor) => Color.fromRGBO(
    tintValue(color.red, factor),
    tintValue(color.green, factor),
    tintValue(color.blue, factor),
    1);

int shadeValue(int value, double factor) =>
    max(0, min(value - (value * factor).round(), 255));

Color shadeColor(Color color, double factor) => Color.fromRGBO(
    shadeValue(color.red, factor),
    shadeValue(color.green, factor),
    shadeValue(color.blue, factor),
    1);
