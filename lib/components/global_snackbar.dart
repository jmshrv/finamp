import 'package:chopper/chopper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:logging/logging.dart';

@Deprecated("Use GlobalSnackbar.error(dynamic error) instead")
void errorSnackbar(dynamic error, BuildContext context) =>
    GlobalSnackbar.error(error);

class GlobalSnackbar {
  static final GlobalKey<ScaffoldMessengerState> materialAppScaffoldKey =
      LabeledGlobalKey("MaterialApp Scaffold");
  static final GlobalKey<NavigatorState> materialAppNavigatorKey =
      LabeledGlobalKey("MaterialApp Navigator");

  static final _logger = Logger("GlobalSnackbar");

  // TODO calls to this could happen in downloader callback or sync methods before app stats up.
  // We need to handle that - just log, or queue for app somehow?

  static void showPrebuilt(SnackBar snackbar) {
    assert(materialAppScaffoldKey.currentState != null &&
        materialAppNavigatorKey.currentContext!.mounted);
    materialAppScaffoldKey.currentState!.showSnackBar(snackbar);
  }

  static void show(SnackBar Function(BuildContext scaffold) snackbar) {
    assert(materialAppScaffoldKey.currentState != null &&
        materialAppNavigatorKey.currentContext!.mounted);
    materialAppScaffoldKey.currentState!
        .showSnackBar(snackbar(materialAppNavigatorKey.currentContext!));
  }

  static void message(String Function(BuildContext scaffold) message) {
    assert(materialAppScaffoldKey.currentState != null &&
        materialAppNavigatorKey.currentContext!.mounted);
    materialAppScaffoldKey.currentState!.showSnackBar(
      SnackBar(
        content: Text(message(materialAppNavigatorKey.currentContext!)),
      ),
    );
  }

  static void error(dynamic event) {
    assert(materialAppScaffoldKey.currentState != null &&
        materialAppNavigatorKey.currentContext!.mounted);
    _logger.info("Displaying error: $event");
    BuildContext context = materialAppNavigatorKey.currentContext!;
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
    materialAppScaffoldKey.currentState!.showSnackBar(
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
}
