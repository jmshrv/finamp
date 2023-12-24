import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
import 'package:hive/hive.dart';
import 'package:logging/logging.dart';

import '../../services/finamp_settings_helper.dart';
import '../../services/finamp_user_helper.dart';
import '../../models/jellyfin_models.dart';
import '../../models/finamp_models.dart';
import '../../services/isar_downloads.dart';
import '../global_snackbar.dart';
import 'download_dialog.dart';
import '../confirmation_prompt_dialog.dart';

class DownloadButton extends ConsumerWidget {
  const DownloadButton({
    Key? key,
    required this.item,
  }) : super(key: key);

  final DownloadStub item;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isarDownloads = GetIt.instance<IsarDownloads>();
    Logger("hmm").severe("checking required for ${item.name}");
    var isRequired = ref.watch(isarDownloads.statusProvider((item,null))
        .select((value) => value.isRequired));


    return ValueListenableBuilder<Box<FinampSettings>>(
      valueListenable: FinampSettingsHelper.finampSettingsListener,
      builder: (context, box, child) {
        bool? isOffline = box.get("FinampSettings")?.isOffline;

        return IconButton(
          icon: isRequired
              ? const Icon(Icons.delete)
              : const Icon(Icons.file_download),
          // If offline, we don't allow the user to delete items.
          // If we did, we'd have to implement listeners for MusicScreenTabView so that the user can't delete a parent, go back, and select the same parent.
          // If they did, AlbumScreen would show an error since the item no longer exists.
          // Also, the user could delete the parent and immediately redownload it, which will either cause unwanted network usage or cause more errors because the user is offline.
          onPressed: isOffline ?? false
              ? null
              : () {
                  if (isRequired) {
                    showDialog(
                      context: context,
                      builder: (context) => ConfirmationPromptDialog(
                        promptText: AppLocalizations.of(context)!
                            .deleteDownloadsPrompt(
                                item.baseItem?.name ?? "", item.type.name),
                        confirmButtonText: AppLocalizations.of(context)!
                            .deleteDownloadsConfirmButtonText,
                        abortButtonText: AppLocalizations.of(context)!
                            .deleteDownloadsAbortButtonText,
                        onConfirmed: () async {
                          final messenger = ScaffoldMessenger.of(context);
                          final text =
                              AppLocalizations.of(context)!.downloadsDeleted;
                          try {
                            await isarDownloads.deleteDownload(stub: item);
                            messenger
                                .showSnackBar(SnackBar(content: Text(text)));
                          } catch (error) {
                            GlobalSnackbar.error(error);
                          }
                        },
                        onAborted: () {},
                      ),
                    );
                    // .whenComplete(() => checkIfDownloaded());
                  } else {
                    if (FinampSettingsHelper
                            .finampSettings.downloadLocationsMap.length ==
                        1) {
                      isarDownloads.addDownload(
                          stub: item,
                          downloadLocation: FinampSettingsHelper.finampSettings
                              .downloadLocationsMap.values.first);
                    } else {
                      showDialog(
                        context: context,
                        builder: (context) => DownloadDialog(
                          item: item,
                        ),
                      );
                    }
                  }
                },
        );
      },
    );
  }
}
