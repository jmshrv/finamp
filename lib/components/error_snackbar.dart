import 'package:chopper/chopper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

/// Snackbar with error icon for displaying errors
ScaffoldFeatureController<SnackBar, SnackBarClosedReason> errorSnackbar(
    dynamic error, BuildContext context) {
  return ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(AppLocalizations.of(context)!.anErrorHasOccured),
      action: SnackBarAction(
        label: MaterialLocalizations.of(context).moreButtonTooltip,
        onPressed: () => showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text(AppLocalizations.of(context)!.error),
            content: Text(_errorText(error, context)),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text(MaterialLocalizations.of(context).closeButtonLabel),
              )
            ],
          ),
        ),
      ),
    ),
  );
}

String _errorText(dynamic error, BuildContext context) {
  if (error.runtimeType == Response) {
    error = error as Response;

    if (error.statusCode == 401) {
      return AppLocalizations.of(context)!
          .responseError401(error.error.toString(), error.statusCode);
    } else {
      return AppLocalizations.of(context)!
          .responseError(error.error.toString(), error.statusCode);
    }
  } else {
    return error.toString();
  }
}
