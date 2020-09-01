import 'package:flutter/material.dart';

/// Snackbar with error icon for displaying errors
ScaffoldFeatureController<SnackBar, SnackBarClosedReason> errorSnackbar(
    dynamic error, BuildContext context) {
  return Scaffold.of(context).showSnackBar(
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
          Text(error.toString())
        ],
      ),
    ),
  );
}
