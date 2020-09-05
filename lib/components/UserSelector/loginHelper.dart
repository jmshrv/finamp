import 'package:flutter/material.dart';

import '../../services/JellyfinAPI.dart';
import '../errorSnackbar.dart';

/// Function to handle logging in for Widgets, including a snackbar for errors.
Future loginHelper(
    {@required JellyfinAPI jellyfinApiProvider,
    @required String username,
    String password,
    @required BuildContext context}) async {
  try {
    await jellyfinApiProvider.authenticateViaName(
        username: username, password: password);
    // If authenticateViaName succeeds, we can just move on to the music home page.
    // pushNamedAndRemoveUntil is used to clear the route history.
    Navigator.of(context)
        .pushNamedAndRemoveUntil("/music", ModalRoute.withName("/"));
  } catch (e) {
    errorSnackbar(e, context);
  }
}
