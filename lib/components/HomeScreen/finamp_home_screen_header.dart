import 'package:finamp/models/finamp_models.dart';
import 'package:finamp/models/jellyfin_models.dart';
import 'package:finamp/screens/playback_history_screen.dart';
import 'package:finamp/screens/settings_screen.dart';
import 'package:finamp/services/finamp_settings_helper.dart';
import 'package:finamp/services/finamp_user_helper.dart';
import 'package:finamp/services/jellyfin_api_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:get_it/get_it.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:simple_gesture_detector/simple_gesture_detector.dart';

class FinampHomeScreenHeader extends ConsumerWidget
    implements PreferredSizeWidget {
  FinampHomeScreenHeader({super.key});

  final finampUserHelper = GetIt.instance<FinampUserHelper>();
  final jellyfinApiHelper = GetIt.instance<JellyfinApiHelper>();

  @override
  Size get preferredSize =>
      const Size.fromHeight(kToolbarHeight * 1.25); // Standard height

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    final FinampSettings? settings = ref.watch(finampSettingsProvider).value;

    Widget connectionInfo;
    if (settings?.isOffline ?? false) {
      connectionInfo = Text.rich(
        TextSpan(
          text: 'Offline Mode',
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      );
    } else {
      connectionInfo = FutureBuilder<PublicSystemInfoResult?>(
          future: jellyfinApiHelper.loadServerPublicInfo(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Text("Connected");
            }
            final PublicSystemInfoResult serverInfo = snapshot.data!;
            return Text.rich(
              TextSpan(
                text: 'Connected to* ',
                children: [
                  TextSpan(
                    text: '${serverInfo.serverName}',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            );
          });
    }
    
    return FutureBuilder(
        future: PackageInfo.fromPlatform(),
        builder: (context, snapshot) {
          return SafeArea(
            child: Padding(
              padding: const EdgeInsets.only(left: 12.0, right: 6.0),
              child: SimpleGestureDetector(
                  onTap: () {
                    // open drawer
                    Scaffold.of(context).openDrawer();
                  },
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      SimpleGestureDetector(
                        onTap: () {
                          // open drawer
                          Scaffold.of(context).openDrawer();
                        },
                        child: SvgPicture.asset(
                          'images/finamp_cropped.svg',
                          height: 40,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              snapshot.data?.appName ?? 'Finamp',
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.w500),
                            ),
                            connectionInfo,
                          ],
                        ),
                      ),
                      Row(
                        children: [
                          IconButton(
                            icon: Icon(TablerIcons.clock),
                            iconSize: 28,
                            onPressed: () {
                              Navigator.pushNamed(
                                  context, PlaybackHistoryScreen.routeName);
                            },
                          ),
                          IconButton(
                            icon: Icon(TablerIcons.settings),
                            iconSize: 28,
                            onPressed: () {
                              Navigator.pushNamed(
                                  context, SettingsScreen.routeName);
                            },
                          ),
                        ],
                      ),
                    ],
                  )
            ),
            ),
          );
        }
    );
  }
}
