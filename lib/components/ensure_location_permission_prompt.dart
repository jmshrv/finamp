import 'dart:io';

import 'package:finamp/components/confirmation_prompt_dialog.dart';
import 'package:finamp/components/global_snackbar.dart';
import 'package:finamp/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

Future<bool> _infoPrompt(BuildContext context) async {
  bool userIsOkay = false;
  await showDialog(
        context: context,
        builder: (_) => ConfirmationPromptDialog(
            promptText: "In order to use the auto-switching feature, Finamp needs precise location permission so it can read the current WiFi network's name.",
            confirmButtonText: "Okay",
            abortButtonText: AppLocalizations.of(context)!.genericCancel,
            onConfirmed: () {
              userIsOkay = true;
            },
            onAborted: () {
              // already false
            },
            centerText: true));
  return userIsOkay;
}

Future<bool> _confirmPrompt(BuildContext context) async {
  bool userIsSure = false;
  await showDialog(
    context: context,
    builder: (_) => ConfirmationPromptDialog(
      promptText: "Without location permission the automatic URL switching feature cant be enabled since it wont work anyway.\nIf you like to use this feature you must enable location permissions manually.",
      confirmButtonText: "I understand",
      abortButtonText: null,
      onConfirmed: () => userIsSure = true,
      onAborted: () {
        // already false
      },
      centerText: true,));
  return userIsSure;
}

Future<bool> ensureLocationPermissions(BuildContext context) async {
  // Desktop doesnt need permissions
  if (!(Platform.isAndroid || Platform.isIOS)) return true;

  PermissionStatus permission = await Permission.locationWhenInUse.status;

  // Permission wasnt requested yet
  if (permission.isDenied) {
    // Sorta simulate the ios dialog info text thing
    if (Platform.isAndroid && !await _infoPrompt(context) ) return false;
    permission = await Permission.locationWhenInUse.request();
  }

  if (permission.isGranted) return true;

  // confirm the user doesn't want to grant permissions.
  // Inform the user that they must enable location manually
  await _confirmPrompt(context);

  GlobalSnackbar.error("Location Permission is denied but required for this feature");
  return false;
}
