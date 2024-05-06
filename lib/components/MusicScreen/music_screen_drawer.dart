import 'dart:io';

import 'package:finamp/screens/playback_history_screen.dart';
import 'package:finamp/screens/player_screen.dart';
import 'package:finamp/screens/queue_restore_screen.dart';
import 'package:finamp/services/finamp_settings_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:get_it/get_it.dart';
import 'package:window_manager/window_manager.dart';

import '../../screens/downloads_screen.dart';
import '../../screens/logs_screen.dart';
import '../../screens/settings_screen.dart';
import '../../services/finamp_user_helper.dart';
import 'offline_mode_switch_list_tile.dart';
import 'view_list_tile.dart';

class MusicScreenDrawer extends StatelessWidget {
  const MusicScreenDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final finampUserHelper = GetIt.instance<FinampUserHelper>();
    return Drawer(
      surfaceTintColor: Colors.white,
      child: ListTileTheme(
        // Shrink trailing padding from 24 to 8
        contentPadding: const EdgeInsetsDirectional.only(start: 16.0, end: 8.0),
        // Manually handle padding in leading/trailing icons
        horizontalTitleGap: 0,
        child: CustomScrollView(
          slivers: [
            SliverList(
              delegate: SliverChildListDelegate.fixed(
                [
                  DrawerHeader(
                      child: Stack(
                    children: [
                      Align(
                        alignment: Alignment.topCenter,
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Image.asset(
                            'images/finamp_cropped.png',
                            width: 56,
                            height: 56,
                          ),
                        ),
                      ),
                      Align(
                          alignment:
                              Alignment.bottomCenter - const Alignment(0, 0.2),
                          child: Text(
                            AppLocalizations.of(context)!.finamp,
                            style: const TextStyle(fontSize: 20),
                          )),
                    ],
                  )),
                  ListTile(
                    leading: const Padding(
                      padding: EdgeInsets.only(right: 16),
                      child: Icon(Icons.file_download),
                    ),
                    title: Text(AppLocalizations.of(context)!.downloads),
                    onTap: () => Navigator.of(context)
                        .pushNamed(DownloadsScreen.routeName),
                  ),
                  ListTile(
                    leading: const Padding(
                      padding: EdgeInsets.only(right: 16),
                      child: Icon(TablerIcons.clock),
                    ),
                    title: Text(AppLocalizations.of(context)!.playbackHistory),
                    onTap: () => Navigator.of(context)
                        .pushNamed(PlaybackHistoryScreen.routeName),
                  ),
                  const OfflineModeSwitchListTile(),
                  const Divider(),
                ],
              ),
            ),
            // This causes an error when logging out if we show this widget
            if (finampUserHelper.currentUser != null)
              SliverList(
                delegate: SliverChildBuilderDelegate((context, index) {
                  return ViewListTile(
                      view: finampUserHelper.currentUser!.views.values
                          .elementAt(index));
                }, childCount: finampUserHelper.currentUser!.views.length),
              ),
            SliverFillRemaining(
              hasScrollBody: false,
              child: SafeArea(
                bottom: true,
                top: false,
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Divider(),
                      if (Platform.isWindows || Platform.isLinux || Platform.isMacOS)
                        Consumer(
                          builder: (context, ref, widget) {
                            final finampSettings = ref.watch(FinampSettingsHelper.finampSettingsProvider).value;
                            return SwitchListTile.adaptive(
                              title: Text("Miniplayer"),
                              secondary: const Padding(
                                padding: EdgeInsets.only(right: 16),
                                child: Icon(TablerIcons.window_minimize),
                              ),
                              activeTrackColor: Theme.of(context).brightness == Brightness.light
                                  ? Theme.of(context).primaryColor.withOpacity(0.5)
                                  : null,
                              trackOutlineColor: MaterialStateProperty.all(Colors.black26),
                              thumbColor: MaterialStateProperty.all(Theme.of(context).primaryColor),
                              value: finampSettings?.isMiniPlayer ?? false,
                              onChanged: (value) async {
                                FinampSettingsHelper.setIsMiniPlayer(value);
                                if (value) {
                                  // resize window
                                  // await WindowManager.instance.waitUntilReadyToShow()
                                  //TODO make sure this is never used to update FinampSettings.previousWindowOptions
                                  await WindowManager.instance.setTitleBarStyle(TitleBarStyle.hidden);
                                  await WindowManager.instance.setAlwaysOnTop(true);
                                  await WindowManager.instance.setSize(const Size(450, 250));
                                  // open player screen
                                  await Navigator.of(context).pushNamed(PlayerScreen.routeName);
                                } else {
                                  // resize window
                                  await WindowManager.instance.setTitleBarStyle(TitleBarStyle.normal);
                                  await WindowManager.instance.setAlwaysOnTop(false);
                                  await WindowManager.instance.setSize(const Size(1200, 800));
                                }
                              },
                            );
                          }
                        ),
                      ListTile(
                        leading: const Padding(
                          padding: EdgeInsets.only(right: 16),
                          child: Icon(Icons.warning),
                        ),
                        title: Text(AppLocalizations.of(context)!.logs),
                        onTap: () => Navigator.of(context)
                            .pushNamed(LogsScreen.routeName),
                      ),
                      ListTile(
                        leading: const Padding(
                          padding: EdgeInsets.only(right: 16),
                          child: Icon(Icons.auto_delete),
                        ),
                        title: Text(AppLocalizations.of(context)!.queuesScreen),
                        onTap: () => Navigator.of(context)
                            .pushNamed(QueueRestoreScreen.routeName),
                      ),
                      ListTile(
                        leading: const Padding(
                          padding: EdgeInsets.only(right: 16),
                          child: Icon(Icons.settings),
                        ),
                        title: Text(AppLocalizations.of(context)!.settings),
                        onTap: () => Navigator.of(context)
                            .pushNamed(SettingsScreen.routeName),
                      ),
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
