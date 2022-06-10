import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../services/FinampUserHelper.dart';
import '../screens/UserSelector.dart';
import '../screens/MusicScreen.dart';
import '../screens/ViewSelector.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({Key? key}) : super(key: key);

  static const routeName = "/";

  @override
  Widget build(BuildContext context) {
    final _finampUserHelper = GetIt.instance<FinampUserHelper>();

    if (_finampUserHelper.currentUser == null) {
      return const UserSelector();
    } else if (_finampUserHelper.currentUser!.currentView == null) {
      return const ViewSelector();
    } else {
      return const MusicScreen();
    }
  }
}
