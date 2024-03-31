import 'dart:io';
import 'dart:math';

import 'package:balanced_text/balanced_text.dart';
import 'package:finamp/color_schemes.g.dart';
import 'package:finamp/components/PlayerScreen/player_screen_appbar_title.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_to_airplay/flutter_to_airplay.dart';
import 'package:flutter_vibrate/flutter_vibrate.dart';
import 'package:get_it/get_it.dart';
import 'package:simple_gesture_detector/simple_gesture_detector.dart';

import '../components/PlayerScreen/control_area.dart';
import '../components/PlayerScreen/player_split_screen_scaffold.dart';
import '../components/PlayerScreen/queue_button.dart';
import '../components/PlayerScreen/queue_list.dart';
import '../components/PlayerScreen/song_info.dart';
import '../components/finamp_app_bar_button.dart';
import '../models/finamp_models.dart';
import '../services/finamp_settings_helper.dart';
import '../services/player_screen_theme_provider.dart';
import '../services/queue_service.dart';
import 'blurred_player_screen_background.dart';

const _toolbarHeight = 52.0;

class PlayerScreen extends ConsumerWidget {
  const PlayerScreen({super.key});

  static const routeName = "/nowplaying";

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final imageTheme =
        ref.watch(playerScreenThemeProvider(Theme.of(context).brightness));
    final queueService = GetIt.instance<QueueService>();

    return AnimatedTheme(
      duration: const Duration(milliseconds: 1000),
      data: ThemeData(
        colorScheme: imageTheme.copyWith(
          brightness: Theme.of(context).brightness,
        ),
        iconTheme: Theme.of(context).iconTheme.copyWith(
              color: imageTheme.primary,
            ),
      ),
      child: StreamBuilder<FinampQueueInfo?>(
          stream: queueService.getQueueStream(),
          initialData: queueService.getQueue(),
          builder: (context, snapshot) {
            if (snapshot.hasData &&
                snapshot.data!.saveState == SavedQueueState.loading) {
              return buildLoadingScreen(context, null);
            } else if (snapshot.hasData &&
                snapshot.data!.saveState == SavedQueueState.failed) {
              return buildLoadingScreen(context, queueService.retryQueueLoad);
            } else if (snapshot.hasData &&
                snapshot.data!.currentTrack != null) {
              return const _PlayerScreenContent();
            } else {
              return const SizedBox.shrink();
            }
          }),
    );
  }
}

Widget buildLoadingScreen(BuildContext context, Function()? retryCallback) {
  double imageSize = min(MediaQuery.of(context).size.width,
          MediaQuery.of(context).size.height) /
      2;

  return SimpleGestureDetector(
    onTap: retryCallback,
    child: Scaffold(
      backgroundColor: Color.alphaBlend(
          Theme.of(context).brightness == Brightness.dark
              ? IconTheme.of(context).color!.withOpacity(0.35)
              : IconTheme.of(context).color!.withOpacity(0.5),
          Theme.of(context).brightness == Brightness.dark
              ? Colors.black
              : Colors.white),
      // Required for sleep timer input
      resizeToAvoidBottomInset: false,
      extendBodyBehindAppBar: true,
      body: SafeArea(
        minimum: const EdgeInsets.only(top: _toolbarHeight),
        child: SizedBox.expand(
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
            const Spacer(),
            (retryCallback != null)
                ? Icon(
                    Icons.refresh,
                    size: imageSize,
                  )
                : SizedBox(
                    width: imageSize,
                    height: imageSize,
                    child: const CircularProgressIndicator.adaptive()),
            const Spacer(),
            BalancedText(
                (retryCallback != null)
                    ? AppLocalizations.of(context)!.queueRetryMessage
                    : AppLocalizations.of(context)!.queueLoadingMessage,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 20,
                  height: 26 / 20,
                )),
            const Spacer(flex: 2),
          ]),
        ),
      ),
    ),
  );
}

class _PlayerScreenContent extends StatelessWidget {
  const _PlayerScreenContent({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SimpleGestureDetector(
      onVerticalSwipe: (direction) {
        if (!FinampSettingsHelper.finampSettings.disableGesture) {
          if (direction == SwipeDirection.down) {
            Navigator.of(context).pop();
          } else if (direction == SwipeDirection.up) {
            showQueueBottomSheet(context);
          }
        }
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
          toolbarHeight: _toolbarHeight,
          title: const PlayerScreenAppBarTitle(),
          leading: usingPlayerSplitScreen
              ? null
              : FinampAppBarButton(
                  onPressed: () => Navigator.of(context).pop(),
                ),
          actions: [
            if (Platform.isIOS)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: AirPlayRoutePickerView(
                  tintColor: IconTheme.of(context).color ?? Colors.white,
                  activeTintColor: jellyfinBlueColor,
                  onShowPickerView: () =>
                      Vibrate.feedback(FeedbackType.selection),
                ),
              ),
          ],
        ),
        // Required for sleep timer input
        resizeToAvoidBottomInset: false, extendBodyBehindAppBar: true,
        body: Stack(
          children: [
            if (FinampSettingsHelper.finampSettings.showCoverAsPlayerBackground)
              const BlurredPlayerScreenBackground(),
            const SafeArea(
              minimum: EdgeInsets.only(top: _toolbarHeight),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Flexible(flex: 100, fit: FlexFit.tight, child: SongInfo()),
                  // Flexible(
                  //     flex: 40, fit: FlexFit.loose, child: ControlArea()),
                  ControlArea(),
                  Flexible(flex: 10, child: SizedBox.shrink()),
                  QueueButton(),
                  Flexible(flex: 2, child: SizedBox.shrink()),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
