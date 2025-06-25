import 'package:collection/collection.dart';
import 'package:finamp/components/AddToPlaylistScreen/playlist_actions_menu.dart';
import 'package:finamp/components/themed_bottom_sheet.dart';
import 'package:finamp/models/finamp_models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_sticky_header/flutter_sticky_header.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:flutter_vibrate/flutter_vibrate.dart';
import 'package:get_it/get_it.dart';
import 'package:hive/hive.dart';

import '../../models/jellyfin_models.dart';
import '../../services/favorite_provider.dart';
import '../../services/feedback_helper.dart';
import '../../services/finamp_settings_helper.dart';
import '../../services/jellyfin_api_helper.dart';
import '../../services/theme_provider.dart';

const serverSharingPanelRouteName = "/server-sharing-panel";

Future<void> showServerSharingPanel({required BuildContext context, FinampTheme? themeProvider}) async {
  final isOffline = FinampSettingsHelper.finampSettings.isOffline;
  final jellyfinApiHelper = GetIt.instance<JellyfinApiHelper>();

  FeedbackHelper.feedback(FeedbackType.selection);

  await showThemedBottomSheet(
    context: context,
    usePlayerTheme: true,
    routeName: serverSharingPanelRouteName,
    minDraggableHeight: 0.2,
    buildSlivers: (context) {
      final menuEntries = [
        Consumer(
          builder: (context, ref, child) {
            FinampSettings? finampSettings = ref.watch(finampSettingsProvider).value;
            return Text(
              "Server Sharing ${finampSettings?.serverSharingEnabled ?? false ? "Enabled" : "Disabled"}",
              style: TextStyle(
                color: Theme.of(context).textTheme.bodyLarge!.color!,
                fontSize: 18,
                fontWeight: FontWeight.w400,
              ),
            );
          },
        ),
        const Divider(),
        Consumer(
          builder: (context, ref, child) {
            final finampSettings = ref.watch(finampSettingsProvider).value;
            // button for toggling server sharing
            return ToggleableListTile(
              title: "Enable Server Sharing",
              leading: const Icon(TablerIcons.share, size: 36.0),
              positiveIcon: TablerIcons.check,
              negativeIcon: TablerIcons.x,
              initialState: (finampSettings?.serverSharingEnabled ?? false),
              enabled: !isOffline,
              onToggle: (bool currentState) async {
                FinampSettings finampSettingsTemp = FinampSettingsHelper.finampSettings;
                if (currentState) {
                  finampSettingsTemp.serverSharingEnabled = !currentState;
                } else {
                  finampSettingsTemp.serverSharingEnabled = !currentState;
                }
                await Hive.box<FinampSettings>("FinampSettings").put("FinampSettings", finampSettingsTemp);
                return finampSettingsTemp.serverSharingEnabled;
              },
            );
          },
        ),
      ];

      var menu = [
        SliverStickyHeader(
          header: Padding(
            padding: const EdgeInsets.only(top: 6.0, bottom: 16.0),
            child: Center(
              child: Text(
                AppLocalizations.of(context)!.addRemoveFromPlaylist,
                style: TextStyle(
                  color: Theme.of(context).textTheme.bodyLarge!.color!,
                  fontSize: 18,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          ),
          sliver: MenuMask(height: 36.0, child: SliverList(delegate: SliverChildListDelegate.fixed(menuEntries))),
        ),
        const SliverPadding(padding: EdgeInsets.only(bottom: 100.0)),
      ];
      var stackHeight = MediaQuery.sizeOf(context).height * 0.5;
      return (stackHeight, menu);
    },
    themeProvider: themeProvider,
  );
}
