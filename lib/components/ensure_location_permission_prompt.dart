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
            promptText: AppLocalizations.of(context)!.requestLocationPermissionInfoDialog,
            confirmButtonText: AppLocalizations.of(context)!.confirm,
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

Future<void> _confirmPrompt(BuildContext context) async {
  await showDialog(
    context: context,
    builder: (_) => ConfirmationPromptDialog(
      promptText: AppLocalizations.of(context)!.requestLocationPermissionEnsureDialog,
      confirmButtonText: AppLocalizations.of(context)!.confirm,
      abortButtonText: null,
      onConfirmed: () => {},
      onAborted: () {},
      centerText: true));
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

  // Inform the user that they must enable location manually
  await _confirmPrompt(context);

  GlobalSnackbar.message((context) => AppLocalizations.of(context)!.requestLocationPermissionErrorMessage);
  return false;
}
