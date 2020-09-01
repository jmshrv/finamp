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
  } catch (e) {
    errorSnackbar(e, context);
  }
}
