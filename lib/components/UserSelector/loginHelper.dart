import 'package:flutter/material.dart';

import '../../services/JellyfinAPI.dart';

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
    Scaffold.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(
              Icons.error,
              color: Colors.red,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 8),
            ),
            Text(e.toString())
          ],
        ),
      ),
    );
  }
}
