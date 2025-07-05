import 'package:balanced_text/balanced_text.dart';
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
import 'package:progress_border/progress_border.dart';

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
            final serverSharingEnabled = ref.read(finampSettingsProvider.serverSharingEnabled);
            // button for toggling server sharing
            return ToggleableListTile(
              leading: Padding(
                padding: const EdgeInsets.only(left: 8.0, top: 8.0, bottom: 8.0),
                child: const Icon(TablerIcons.access_point, size: 36.0),
              ),
              title: serverSharingEnabled ? "Sharing Server Address" : "Not Sharing",
              subtitle: serverSharingEnabled ? "Ends in 45s" : "Tap to Share",
              trailing: Container(
                // width: 60.0,
                // height: 40.0,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20.0),
                  border: ProgressBorder.all(
                    color:
                        ref.watch(finampSettingsProvider.serverSharingEnabled) &&
                            !MediaQuery.of(context).disableAnimations
                        ? IconTheme.of(context).color!.withAlpha(128)
                        : Colors.transparent,
                    width: 4,
                    clockwise: false,
                    progress: 0.75, //TODO Placeholder for progress, move to timer that is independent of menu
                  ),
                ),
                child: SwitchTheme(
                  data: SwitchThemeData(
                    thumbColor: MaterialStateProperty.all(Theme.of(context).colorScheme.primary),
                    trackColor: MaterialStateProperty.all(Theme.of(context).colorScheme.primary.withOpacity(0.3)),
                    overlayColor: MaterialStateProperty.all(Colors.transparent),
                    trackOutlineColor: MaterialStateProperty.all(
                      Theme.of(context).colorScheme.primary.withOpacity(0.3),
                    ),
                  ),
                  child: Switch.adaptive(
                    value: serverSharingEnabled,
                    onChanged: (value) {
                      FinampSetters.setServerSharingEnabled(value);
                    },
                    padding: const EdgeInsets.symmetric(horizontal: 0.0, vertical: -8.0),
                  ),
                ),
              ),
              initialState: serverSharingEnabled,
              onToggle: (bool currentState) async {
                if (!currentState && isOffline) {
                  await showDialog<ConfirmationPromptDialog>(
                    context: context,
                    builder: (context) => ConfirmationPromptDialog(
                      promptText:
                          "Are you sure you want to enable server sharing even though you're in Offline Mode? This will cause Finamp to send data over the local network.*",
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
          sliver: MenuMask(
            height: ServerSharingPanelHeader.defaultHeight,
            child: SliverList(delegate: SliverChildListDelegate.fixed(menuEntries)),
          ),
        ),
        SliverPadding(
          padding: EdgeInsets.only(left: 32.0, right: 32.0, top: 16.0),
          sliver: SliverList(
            delegate: SliverChildListDelegate.fixed([
              BalancedText(
                "Sharing your server can be useful to set up new clients that are not on the same local network as your Jellyfin server, i.e. hotel TVs, your PC at work, or a new client on your phone while you're on the go.",
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 24.0),
              BalancedText(
                "It works by listening to server discovery requests by other clients on the local network, and then replying to those requests with the configured address of your Jellyfin server.",
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodySmall,
              ),
              const SizedBox(height: 4.0),
              BalancedText(
                "Essentially, Finamp is pretending to be a Jellyfin server, redirecting all clients to your actual server. This means any device on your local network could ask for your server's address, and Finamp will reply.",
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ]),
          ),
        ),
        SliverPadding(padding: EdgeInsets.only(bottom: 40.0)),
      ];
      var stackHeight = MediaQuery.sizeOf(context).height * 0.45;
      return (stackHeight, menu);
    },
  );
}

class ServerSharingPanelHeader extends StatelessWidget {
  const ServerSharingPanelHeader({super.key});

  static const defaultHeight = MenuMaskHeight(36.0);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 6.0, bottom: 16.0),
      child: Center(
        child: Text(
          "Local Network Server Sharing*",
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
