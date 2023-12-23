import 'dart:async';

import 'package:chopper/chopper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

// Maybe use a global key for scaffoldMessenger+context?
final globalErrorStream = StreamController.broadcast();

@Deprecated("Use globalErrorStream.add(dynamic error) instead")
void errorSnackbar(dynamic error, BuildContext context) =>
    globalErrorStream.add(error);

class ErrorSnackbarBuilder extends StatelessWidget {
  const ErrorSnackbarBuilder({required this.child, Key? key})
      : super(key: key);

  final Widget child;

  @override
  Widget build(BuildContext context) {
    globalErrorStream.stream.listen((event) {
      // If the error event wants a build context, it is handling localization.
      // Show it directly on the snackbar with no additional explanation.
      if (event is String Function(BuildContext)) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(event(context)),
          ),
        );
      } else {
        String errorText;
        if (event is Response) {
          if (event.statusCode == 401) {
            errorText = AppLocalizations.of(context)!
                .responseError401(event.error.toString(), event.statusCode);
          } else {
            errorText = AppLocalizations.of(context)!
                .responseError(event.error.toString(), event.statusCode);
          }
        } else {
          errorText = event.toString();
        }
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppLocalizations.of(context)!.anErrorHasOccured),
            action: SnackBarAction(
              label: MaterialLocalizations.of(context).moreButtonTooltip,
              onPressed: () => showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text(AppLocalizations.of(context)!.error),
                  content: Text(errorText),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child:
                      Text(MaterialLocalizations.of(context).closeButtonLabel),
                    )
                  ],
                ),
              ),
            ),
          ),
        );
      }
    });
    return child;
  }
}
