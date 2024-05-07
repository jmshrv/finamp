import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../models/jellyfin_models.dart';
import 'global_snackbar.dart';

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
      buttonPadding: const EdgeInsets.all(0.0),
      contentPadding: const EdgeInsets.all(0.0),
      insetPadding: const EdgeInsets.all(32.0),
      actionsPadding: const EdgeInsets.all(0.0),
      actionsAlignment: MainAxisAlignment.spaceAround,
      actionsOverflowAlignment: OverflowBarAlignment.center,
      actionsOverflowDirection: VerticalDirection.up,
      title: Text(
        promptText,
        style: const TextStyle(fontSize: 18),
      ),
      actions: [
        Container(
          constraints: const BoxConstraints(
            maxWidth: 150.0,
          ),
          child: TextButton(
            child: Text(
              abortButtonText,
              textAlign: TextAlign.center,
            ),
            onPressed: () {
              Navigator.of(context).pop();
              onAborted?.call();
            },
          ),
        ),
        Container(
          constraints: const BoxConstraints(
            maxWidth: 150.0,
          ),
          child: TextButton(
            child: Text(
              confirmButtonText,
              textAlign: TextAlign.center,
              softWrap: true,
            ),
            onPressed: () {
              Navigator.of(context).pop(); // Close the dialog
              onConfirmed?.call();
            },
          ),
        ),
      ],
    );
  }
}
