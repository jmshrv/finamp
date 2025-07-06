import 'package:balanced_text/balanced_text.dart';
import 'package:finamp/components/confirmation_prompt_dialog.dart';
import 'package:finamp/components/themed_bottom_sheet.dart';
import 'package:finamp/menus/playlist_actions_menu.dart';
import 'package:finamp/services/feedback_helper.dart';
import 'package:finamp/services/finamp_settings_helper.dart';
import 'package:finamp/services/server_discovery_emulation_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_sticky_header/flutter_sticky_header.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:get_it/get_it.dart';

const serverSharingPanelRouteName = "/server-sharing-panel";

Future<void> showServerSharingPanel({required BuildContext context}) async {
  FeedbackHelper.feedback(FeedbackType.selection);

  await showThemedBottomSheet(
    context: context,
    routeName: serverSharingPanelRouteName,
    minDraggableHeight: 0.4,
    buildSlivers: (context) {
      final menuEntries = [ServerSharingMenuControls()];

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
                "Sharing your server address can be useful to set up new clients that are not on the same local network as your Jellyfin server, i.e. hotel TVs, your PC at work, or a new client on your phone while you're on the go.",
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 24.0),
              BalancedText(
                "It works by listening to server discovery requests by other clients on the local network, and then replying to those requests with the configured address of your Jellyfin server.\nIf you have both a local and public address configured, Finamp will provide both to the requesting client.",
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ]),
          ),
        ),
        SliverPadding(padding: EdgeInsets.only(bottom: 40.0)),
      ];
      var stackHeight = MediaQuery.sizeOf(context).height * 0.4;
      return (stackHeight, menu);
    },
  );
}

class ServerSharingMenuControls extends ConsumerStatefulWidget {
  const ServerSharingMenuControls({super.key});

  @override
  _ServerSharingMenuControlsState createState() => _ServerSharingMenuControlsState();
}

class _ServerSharingMenuControlsState extends ConsumerState<ServerSharingMenuControls> {
  final serverDiscoveryEmulationService = GetIt.instance<ServerDiscoveryEmulationService>();

  late bool serverSharingEnabled;
  late Key toggleableListTileKey;

  @override
  void initState() {
    super.initState();
    serverSharingEnabled = false;
    toggleableListTileKey = UniqueKey();

    AppLifecycleListener(
      onRestart: () {},
      onHide: () {
        // If the app is hidden, we stop advertising the server
        toggleServerSharing(forceTo: false);
      },
      onShow: () {},
      onPause: () {},
    );
  }

  @override
  void dispose() {
    serverSharingEnabled = false;
    serverDiscoveryEmulationService.dispose();
    toggleableListTileKey = UniqueKey();
    super.dispose();
  }

  void toggleServerSharing({bool? forceTo}) {
    if (forceTo == false || (forceTo == null && serverSharingEnabled)) {
      serverDiscoveryEmulationService.dispose();
    } else {
      serverDiscoveryEmulationService.advertiseServer();
    }
    if (mounted) {
      setState(() {
        serverSharingEnabled = serverDiscoveryEmulationService.isSharing;
        toggleableListTileKey = UniqueKey();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isOffline = ref.watch(finampSettingsProvider.isOffline);

    return ToggleableListTile(
      key: toggleableListTileKey,
      leading: Padding(
        padding: const EdgeInsets.only(left: 8.0, top: 8.0, bottom: 8.0),
        child: const Icon(TablerIcons.access_point, size: 36.0),
      ),
      title: serverSharingEnabled ? "Sharing Server" : "Not Sharing",
      subtitle: serverSharingEnabled ? "Tap to Stop" : "Tap to Share",
      trailing: Switch.adaptive(
        value: serverSharingEnabled,
        onChanged: (value) {
          toggleServerSharing(forceTo: value);
        },
        padding: const EdgeInsets.symmetric(horizontal: 0.0, vertical: -8.0),
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
              onConfirmed: () => toggleServerSharing(),
              onAborted: () {},
            ),
          );
          return serverSharingEnabled;
        } else {
          toggleServerSharing();
        }
        return !currentState;
      },
    );
  }
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
