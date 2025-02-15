import 'dart:async';

import 'package:chopper/chopper.dart';
import 'package:finamp/services/feedback_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_vibrate/flutter_vibrate.dart';
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

  static final List<Function> _queue = [];

  static Timer? _timer;

  /// It is possible for some GlobalSnackbar methods to be called before app
  /// startup completes.  If this happens, we delay executing the function
  /// until the MaterialApp has been set up.
  static void _enqueue(Function func) {
    if (materialAppScaffoldKey.currentState != null &&
        (materialAppNavigatorKey.currentContext?.mounted ?? false)) {
      // Schedule snackbar creation for as soon as possible outside of build()
      SchedulerBinding.instance.scheduleTask(() => func(), Priority.touch);
    } else {
      _queue.add(func);
      _timer ??= Timer.periodic(const Duration(seconds: 1), (timer) {
        if (materialAppScaffoldKey.currentState != null &&
            (materialAppNavigatorKey.currentContext?.mounted ?? false)) {
          timer.cancel();
          _timer = null;
          for (var queuedFunc in _queue) {
            queuedFunc();
          }
          _queue.clear();
        }
      });
    }
  }

  /// Show a snackbar to the user using the local context
  static void showPrebuilt(SnackBar snackbar) =>
      _enqueue(() => _showPrebuilt(snackbar));
  static void _showPrebuilt(SnackBar snackbar) {
    materialAppScaffoldKey.currentState!.showSnackBar(snackbar);
  }

  /// Show a snackbar to the user using the global context
  static void show(SnackBar Function(BuildContext scaffold) snackbar) =>
      _enqueue(() => _show(snackbar));
  static void _show(SnackBar Function(BuildContext scaffold) snackbar) {
    materialAppScaffoldKey.currentState!
        .showSnackBar(snackbar(materialAppNavigatorKey.currentContext!));
  }

  /// Show a localized message to the user using the global context
  static void message(
    String Function(BuildContext scaffold) message, {
    bool isConfirmation = false,
  }) =>
      _enqueue(() => _message(message, isConfirmation));
  static void _message(
      String Function(BuildContext scaffold) message, bool isConfirmation) {
    var text = message(materialAppNavigatorKey.currentContext!);
    _logger.info("Displaying message: $text");
    materialAppScaffoldKey.currentState!.showSnackBar(
      SnackBar(
        content: Text(text),
        duration: isConfirmation
            ? const Duration(milliseconds: 1500)
            : const Duration(seconds: 4),
      ),
    );
  }

  /// Show an unlocalized error message to the user
  static void error(dynamic event) => _enqueue(() => _error(event));
  static void _error(dynamic event) {
    _logger.warning("Displaying error: $event", event);
    if (event is Error && event.stackTrace != null) {
      _logger.warning(event.stackTrace);
    }
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
    // give immediate feedback that something went wrong
    FeedbackHelper.feedback(FeedbackType.warning);
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
        duration: const Duration(seconds: 4),
      ),
    );
  }
}
