import 'package:finamp/screens/queue_restore_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get_it/get_it.dart';

import '../../services/finamp_user_helper.dart';
import '../../screens/downloads_screen.dart';
import '../../screens/logs_screen.dart';
import '../../screens/settings_screen.dart';
import 'offline_mode_switch_list_tile.dart';
import 'view_list_tile.dart';

class MusicScreenDrawer extends StatelessWidget {
  const MusicScreenDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final finampUserHelper = GetIt.instance<FinampUserHelper>();
    return Drawer(
      surfaceTintColor: Colors.white,
      child: Scrollbar(
        child: CustomScrollView(
          slivers: [
            SliverList(
              delegate: SliverChildListDelegate.fixed(
                [
                  DrawerHeader(
                      child: Stack(
                    children: [
                      const Align(
                        alignment: Alignment.topCenter,
                        child: CircleAvatar(
                          backgroundColor: Colors.transparent,
                          backgroundImage: AssetImage(
                            'images/finamp.png',
                          ),
                          radius: 50.0,
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
                    leading: const Icon(Icons.file_download),
                    title: Text(AppLocalizations.of(context)!.downloads),
                    onTap: () => Navigator.of(context)
                        .pushNamed(DownloadsScreen.routeName),
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
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Divider(),
                      ListTile(
                        leading: const Icon(Icons.warning),
                        title: Text(AppLocalizations.of(context)!.logs),
                        onTap: () => Navigator.of(context)
                            .pushNamed(LogsScreen.routeName),
                      ),
                      ListTile(
                        leading: const Icon(Icons.auto_delete),
                        title: Text(AppLocalizations.of(context)!.queuesScreen),
                        onTap: () => Navigator.of(context)
                            .pushNamed(QueueRestoreScreen.routeName),
                      ),
                      ListTile(
                        leading: const Icon(Icons.settings),
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
