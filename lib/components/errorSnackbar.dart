import 'package:flutter/material.dart';

/// Snackbar with error icon for displaying errors
ScaffoldFeatureController<SnackBar, SnackBarClosedReason> errorSnackbar(
    dynamic error, BuildContext context) {
  return Scaffold.of(context).showSnackBar(
    SnackBar(
      content: Text("An error has occurred."),
      action: SnackBarAction(
        label: "MORE",
        onPressed: () => showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text("Error"),
            content: Text(error.toString()),
            actions: [
              FlatButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text("Close"),
              )
            ],
          ),
        ),
      ),
    ),
  );
}
