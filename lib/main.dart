import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'dart:math';

import 'screens/ServerSelector.dart';
import 'screens/UserSelector.dart';
import 'screens/MusicScreen.dart';

import 'services/JellyfinAPI.dart';

void main() {
  runApp(MultiProvider(
    providers: [Provider<JellyfinAPI>(create: (_) => JellyfinAPI())],
    child: Finamp(),
  ));
}

class Finamp extends StatelessWidget {
  const Finamp({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);

        if (!currentFocus.hasPrimaryFocus &&
            currentFocus.focusedChild != null) {
          FocusManager.instance.primaryFocus.unfocus();
        }
      },
      child: MaterialApp(
        routes: {
          "/login/serverSelector": (context) => ServerSelector(),
          "/login/userSelector": (context) => UserSelector(),
          "/music": (context) => MusicScreen()
        },
        initialRoute: "/login/serverSelector",
        darkTheme: ThemeData(
          primarySwatch: generateMaterialColor(Color(0xFF00A4DC)),
          brightness: Brightness.dark,
          scaffoldBackgroundColor: Color(0xFF101010),
          appBarTheme: AppBarTheme(
            color: Color(0xFF202020),
          ),
          cardColor: Color(0xFF202020),
        ),
        themeMode: ThemeMode.dark,
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
