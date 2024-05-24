import 'dart:io';

import 'package:finamp/services/queue_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get_it/get_it.dart';

import '../../screens/splash_screen.dart';
import '../../services/finamp_settings_helper.dart';
import '../../services/jellyfin_api_helper.dart';
import '../../services/music_player_background_task.dart';
import '../global_snackbar.dart';

class LogoutListTile extends StatefulWidget {
  const LogoutListTile({Key? key}) : super(key: key);

  @override
  State<LogoutListTile> createState() => _LogoutListTileState();
}

class _LogoutListTileState extends State<LogoutListTile> {
  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(
        Icons.logout,
        color:
            FinampSettingsHelper.finampSettings.isOffline ? null : Colors.red,
      ),
      title: Text(
        AppLocalizations.of(context)!.logOut,
        style: FinampSettingsHelper.finampSettings.isOffline
            ? null
            : const TextStyle(
                color: Colors.red,
              ),
      ),
      subtitle: FinampSettingsHelper.finampSettings.isOffline
          ? Text(AppLocalizations.of(context)!.notAvailableInOfflineMode)
          : Text(
              AppLocalizations.of(context)!.downloadedSongsWillNotBeDeleted,
              style: const TextStyle(color: Colors.red),
            ),
      enabled: !FinampSettingsHelper.finampSettings.isOffline,
      onTap: () {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text(AppLocalizations.of(context)!.areYouSure),
            actions: [
              TextButton(
                child:
                    Text(MaterialLocalizations.of(context).cancelButtonLabel),
                onPressed: () => Navigator.of(context).pop(),
              ),
              TextButton(
                child: Text(MaterialLocalizations.of(context).okButtonLabel),
                onPressed: () async {
                  try {
                    final audioHandler =
                        GetIt.instance<MusicPlayerBackgroundTask>();
                    final queueService = GetIt.instance<QueueService>();

                    // We don't want audio to be playing after we log out.
                    // We check if the audio service is running on iOS because
                    // stop() never completes if the service is not running.
                    if (!Platform.isIOS ||
                        (audioHandler.playbackState.valueOrNull?.playing ??
                            false)) {
                      await queueService.stopPlayback();
                    }

                    final jellyfinApiHelper =
                        GetIt.instance<JellyfinApiHelper>();

                    await jellyfinApiHelper
                        .logoutCurrentUser()
                        .onError((_, __) {});

                    if (!mounted) return;

                    await Navigator.of(context).pushNamedAndRemoveUntil(
                        SplashScreen.routeName, (route) => false);
                  } catch (e) {
                    GlobalSnackbar.error(e);
                    return;
                  }
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
