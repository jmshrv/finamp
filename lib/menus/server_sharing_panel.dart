import 'package:finamp/components/confirmation_prompt_dialog.dart';
import 'package:finamp/components/themed_bottom_sheet.dart';
import 'package:finamp/l10n/app_localizations.dart';
import 'package:finamp/menus/playlist_actions_menu.dart';
import 'package:finamp/models/finamp_models.dart';
import 'package:finamp/services/feedback_helper.dart';
import 'package:finamp/services/finamp_settings_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_sticky_header/flutter_sticky_header.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';


const serverSharingPanelRouteName = "/server-sharing-panel";

Future<void> showServerSharingPanel({required BuildContext context}) async {
  final isOffline = FinampSettingsHelper.finampSettings.isOffline;

  FeedbackHelper.feedback(FeedbackType.selection);

  await showThemedBottomSheet(
    context: context,
    routeName: serverSharingPanelRouteName,
    minDraggableHeight: 0.2,
    buildSlivers: (context) {
      final menuEntries = [
        Consumer(
          builder: (context, ref, child) {
            FinampSettings? finampSettings = ref.watch(finampSettingsProvider).value;
            return Text(
              "Server Sharing ${finampSettings?.serverSharingEnabled ?? false ? "Enabled" : "Disabled"}*",
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
            final serverSharingEnabled = ref.read(finampSettingsProvider.serverSharingEnabled);
            // button for toggling server sharing
            return ToggleableListTile(
              title: "${serverSharingEnabled ? "Disable" : "Enable"} Server Sharing*",
              leading: const Icon(TablerIcons.share, size: 36.0),
              positiveIcon: TablerIcons.check,
              negativeIcon: TablerIcons.x,
              initialState: serverSharingEnabled,
              onToggle: (bool currentState) async {
                if (!currentState && isOffline) {
                  await showDialog<ConfirmationPromptDialog>(
                    context: context,
                    builder: (context) => ConfirmationPromptDialog(
                      promptText: "Are you sure you want to enable server sharing even though you're in Offline Mode? This will cause Finamp to send data over the local network.*",
                      confirmButtonText: "Enable*",
                      abortButtonText: MaterialLocalizations.of(context).cancelButtonLabel,
                      onConfirmed: () => FinampSetters.setServerSharingEnabled(!currentState),
                      onAborted: () {},
                    ),
                  );
                  return FinampSettingsHelper.finampSettings.serverSharingEnabled;
                } else {
                  FinampSetters.setServerSharingEnabled(!currentState);
                }
                return !currentState;
              },
            );
          },
        ),
      ];

      var menu = [
        SliverStickyHeader(
          header: ServerSharingPanelHeader(),
          sliver: MenuMask(height: ServerSharingPanelHeader.defaultHeight, child: SliverList(delegate: SliverChildListDelegate.fixed(menuEntries))),
        ),
        const SliverPadding(padding: EdgeInsets.only(bottom: 100.0)),
      ];
      var stackHeight = MediaQuery.sizeOf(context).height * 0.5;
      return (stackHeight, menu);
    },
  );
}

class ServerSharingPanelHeader extends StatelessWidget {
  const ServerSharingPanelHeader({
    super.key,
  });

  static const defaultHeight = MenuMaskHeight(36.0);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 6.0, bottom: 16.0),
      child: Center(
        child: Text(
          "Server Sharing*",
          style: TextStyle(
            color: Theme.of(context).textTheme.bodyLarge!.color!,
            fontSize: 18,
            fontWeight: FontWeight.w400,
          ),
        ),
      ),
    );
  }
}
