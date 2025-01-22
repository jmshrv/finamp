import 'package:finamp/components/confirmation_prompt_dialog.dart';
import 'package:finamp/components/global_snackbar.dart';
import 'package:finamp/models/finamp_models.dart';
import 'package:finamp/services/downloads_service.dart';
import 'package:finamp/services/jellyfin_api_helper.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

Future<void> askBeforeDeleteDownloadFromDevice(
    BuildContext context, DownloadStub stub) async {
  String type = stub.baseItemType.name;
  await showDialog(
      context: context,
      builder: (context) => ConfirmationPromptDialog(
          promptText: AppLocalizations.of(context)!
              .deleteFromTargetDialogText("", "device", type),
          confirmButtonText: AppLocalizations.of(context)!
              .deleteFromTargetConfirmButton("device"),
          abortButtonText: AppLocalizations.of(context)!.genericCancel,
          onConfirmed: () {
            GetIt.instance<DownloadsService>().deleteDownload(stub: stub)
              .then((_) => GlobalSnackbar
                .message((cntxt) => AppLocalizations.of(context)!
                      .itemDeletedSnackbar("server", type)
                ))
              .catchError((err)=>GlobalSnackbar.error(err));
          },
          onAborted: () {},
          centerText: true));
}

Future<void> askBeforeDeleteDownloadFromServer(
    BuildContext context, DownloadStub stub, {bool popIt = false}) async {
  DownloadItemStatus status =
      GetIt.instance<DownloadsService>().getStatus(stub, null);
  String type = stub.baseItemType.name;

  String deleteType = status.isRequired
      ? "canDelete"
      : (status != DownloadItemStatus.notNeeded
          ? "cantDelete"
          : "notDownloaded");

  await showDialog(
      context: context,
      builder: (context) => ConfirmationPromptDialog(
          promptText: AppLocalizations.of(context)!
              .deleteFromTargetDialogText(deleteType, "server", type),
          confirmButtonText: AppLocalizations.of(context)!
              .deleteFromTargetConfirmButton("server"),
          abortButtonText: AppLocalizations.of(context)!.genericCancel,
          onConfirmed: () {
            GetIt.instance<JellyfinApiHelper>()
              .deleteItem(stub.id)
              .then((_) {
                GlobalSnackbar.message(
                  (cntxt) {
                    if (popIt) {
                      Navigator.of(cntxt).pop();
                    }
                    return AppLocalizations.of(context)!
                      .itemDeletedSnackbar("server", type);
                    },
                  isConfirmation: true);
                  if (status.isRequired) {
                    GetIt.instance<DownloadsService>()
                    .deleteDownload(stub: stub)
                    .then((_) {
                      GlobalSnackbar.message(
                        (_) => AppLocalizations.of(context)!
                            .itemDeletedSnackbar("device", type));
                    })
                    .catchError((err) {
                      GlobalSnackbar.error(err);
                    });
                  }

              
            }).catchError((err) {
              GlobalSnackbar.error(err);
            });
          },
          onAborted: () {},
          centerText: true));
}
