import 'package:finamp/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../services/finamp_user_helper.dart';
import 'login_screen.dart';
import 'music_screen.dart';
import 'view_selector.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  static const routeName = "/";

  @override
  Widget build(BuildContext context) {
    final finampUserHelper = GetIt.instance<FinampUserHelper>();

    if (finampUserHelper.currentUser == null) {
      return const LoginScreen();
    } else if (finampUserHelper.currentUser!.currentView == null) {
      return const ViewSelector();
    } else {
      return const HomeScreen();
    }
  }
}
