import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../models/jellyfin_models.dart';
import '../services/downloads_helper.dart';
import 'error_snackbar.dart';

class ConfirmationPromptDialog extends AlertDialog {
  const ConfirmationPromptDialog({
    Key? key,
    required this.promptText,
    required this.confirmButtonText,
    required this.abortButtonText,
    required this.onConfirmed,
    required this.onAborted,
  }) : super(key: key);

  final String promptText;
  final String confirmButtonText;
  final String abortButtonText;
  final void Function()? onConfirmed;
  final void Function()? onAborted;

  
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(promptText),
      actions: [
        TextButton(
          child: Text(abortButtonText),
          onPressed: () {
            Navigator.of(context).pop();
            onAborted?.call();
          },
        ),
        TextButton(
          child: Text(confirmButtonText),
          onPressed: () {
            Navigator.of(context).pop(); // Close the dialog
            onConfirmed?.call();
          },
        ),
      ],
    );
  }
}
