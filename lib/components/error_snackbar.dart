import 'package:chopper/chopper.dart';
import 'package:flutter/material.dart';

/// Snackbar with error icon for displaying errors
ScaffoldFeatureController<SnackBar, SnackBarClosedReason> errorSnackbar(
    dynamic error, BuildContext context) {
  return ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: const Text("An error has occurred."),
      action: SnackBarAction(
        label: "MORE",
        onPressed: () => showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text("Error"),
            content: Text(_errorText(error)),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text("CLOSE"),
              )
            ],
          ),
        ),
      ),
    ),
  );
}

String _errorText(dynamic error) {
  if (error.runtimeType == Response) {
    if (error.statusCode == 401) {
      return "${error.error.toString()} Status code ${error.statusCode}. This probably means that you used the wrong username/password, or your client is no longer authenticated.";
    } else {
      return "${error.error.toString()} Status code ${error.statusCode}.";
    }
  } else {
    return error.toString();
  }
}
