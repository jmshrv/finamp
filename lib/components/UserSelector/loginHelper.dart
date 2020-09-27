import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../errorSnackbar.dart';
import '../../services/JellyfinApiData.dart';

/// Function to handle logging in for Widgets, including a snackbar for errors.
Future loginHelper(
    {@required String username,
    String password,
    @required BuildContext context}) async {
  JellyfinApiData jellyfinApiData = GetIt.instance<JellyfinApiData>();

  try {
    if (password == null) {
      await jellyfinApiData.authenticateViaName(username: username);
    } else {
      await jellyfinApiData.authenticateViaName(
        username: username,
        password: password,
      );
    }
    Navigator.of(context).pushNamed("/settings/views");
  } catch (e) {
    errorSnackbar(e, context);

    // We return null here to stop the function from continuing.
    return null;
  }
}
