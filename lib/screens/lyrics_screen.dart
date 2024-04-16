import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:finamp/color_schemes.g.dart';
import 'package:finamp/components/PlayerScreen/player_screen_appbar_title.dart';
import 'package:finamp/models/jellyfin_models.dart';
import 'package:finamp/services/current_track_metadata_provider.dart';
import 'package:finamp/services/feedback_helper.dart';
import 'package:finamp/services/progress_state_stream.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_to_airplay/flutter_to_airplay.dart';
import 'package:flutter_vibrate/flutter_vibrate.dart';
import 'package:scroll_to_index/scroll_to_index.dart';
import 'package:simple_gesture_detector/simple_gesture_detector.dart';

import '../components/PlayerScreen/control_area.dart';
import '../components/PlayerScreen/player_screen_album_image.dart';
import '../components/PlayerScreen/queue_button.dart';
import '../components/PlayerScreen/queue_list.dart';
import '../components/PlayerScreen/song_name_content.dart';
import '../components/finamp_app_bar_button.dart';
import '../services/finamp_settings_helper.dart';
import '../services/player_screen_theme_provider.dart';
import 'blurred_player_screen_background.dart';
import 'player_screen.dart';

class LyricsScreen extends ConsumerWidget {
  const LyricsScreen({Key? key}) : super(key: key);

  static const routeName = "/lyrics";

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final imageTheme =
        ref.watch(playerScreenThemeProvider(Theme.of(context).brightness));

    final metadata = ref.watch(currentTrackMetadataProvider).value;

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
      child: const _LyricsScreenContent(),
    );
  }
}

class _LyricsScreenContent extends StatelessWidget {
  const _LyricsScreenContent({
    super.key,
  });

  @override
  Widget build(BuildContext context) {

    double toolbarHeight = 53;
    int maxLines = 2;

    var controller = PlayerHideableController();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        toolbarHeight: toolbarHeight,
        title: PlayerScreenAppBarTitle(
          maxLines: maxLines,
        ),
        leading: FinampAppBarButton(
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
                    FeedbackHelper.feedback(FeedbackType.selection),
              ),
            ),
        ],
      ),
      // Required for sleep timer input
      resizeToAvoidBottomInset: false, extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          if (FinampSettingsHelper.finampSettings.useCoverAsBackground)
            const BlurredPlayerScreenBackground(),
          SafeArea(
            minimum: EdgeInsets.only(top: toolbarHeight),
            child: LayoutBuilder(builder: (context, constraints) {
              if (MediaQuery.of(context).orientation == Orientation.landscape) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Expanded(
                      child: Column(
                        children: [
                          const Spacer(flex: 4),
                          SongNameContent(controller),
                          const Spacer(flex: 4),
                          ControlArea(controller),
                          if (controller
                              .shouldShow(PlayerHideable.queueButton))
                            const Spacer(flex: 10),
                          if (controller
                              .shouldShow(PlayerHideable.queueButton))
                            const QueueButton(),
                          const Spacer(
                            flex: 4,
                          ),
                        ],
                      ),
                    ),
                    ConstrainedBox(
                      constraints: BoxConstraints(
                          maxWidth: controller.getTarget().width),
                      child: const _LyricsView(),
                    ),
                  ],
                );
              } else {
                controller.updateLayoutPortrait(Size(constraints.maxWidth, constraints.maxHeight));
                return Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    const Expanded(
                      child: _LyricsView(),
                    ),
                    SongNameContent(controller),
                    ControlArea(controller),
                    if (controller.shouldShow(PlayerHideable.queueButton))
                      const QueueButton(),
                    if (!controller.shouldShow(PlayerHideable.queueButton))
                      const SizedBox(
                        height: 5,
                      )
                  ],
                );
              }
            }),
          ),
        ],
      ),
    );
  }
}

class _LyricsView extends ConsumerStatefulWidget {
  const _LyricsView();

  @override
  _LyricsViewState createState() => _LyricsViewState();
}

class _LyricsViewState extends ConsumerState<_LyricsView> {

  late AutoScrollController autoScrollController;
  StreamSubscription<ProgressState>? progressStateStreamSubscription;
  Duration? currentPosition;
  int? currentLineIndex;
  int? previousLineIndex;

  @override
  void initState() {
    autoScrollController = AutoScrollController(
      suggestedRowHeight: 72,
      viewportBoundaryGetter: () =>
          Rect.fromLTRB(0, 0, 0, MediaQuery.of(context).padding.bottom),
      axis: Axis.vertical);
    super.initState();
  }

  @override
  void dispose() {
    progressStateStreamSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final metadata = ref.watch(currentTrackMetadataProvider).value;

    if (metadata == null) {
      return const Text("Loading lyrics...");
    } else if (metadata.lyrics == null) {
      return const Text("No lyrics found.");
    } else {

      progressStateStreamSubscription?.cancel();
      progressStateStreamSubscription = progressStateStream.listen((state) async {
        currentPosition = state.position;

        // find the closest line to the current position, clamping to the first and last lines
        int closestLineIndex = -1;
        for (int i = 0; i < metadata.lyrics!.lyrics!.length; i++) {
          closestLineIndex = i;
          final line = metadata.lyrics!.lyrics![i];
          if ((line.start ?? 0) ~/ 10 > (currentPosition?.inMicroseconds ?? 0)) {
            closestLineIndex = i - 1;
            break;
          }
        }

        currentLineIndex = closestLineIndex;
        if (currentLineIndex! != previousLineIndex) {
          setState(() {}); // Rebuild to update the current line
          if (autoScrollController.hasClients) {
            int clampedIndex = currentLineIndex ?? 0;
            if (clampedIndex >= metadata.lyrics!.lyrics!.length) {
              clampedIndex = metadata.lyrics!.lyrics!.length - 1;
            }
            // print("currentPosition: ${currentPosition?.inMicroseconds}, currentLineIndex: $currentLineIndex, line: ${metadata.lyrics!.lyrics![clampedIndex].text}");
            if (clampedIndex < 0) {
              await autoScrollController.scrollToIndex(
                -1,
                preferPosition: AutoScrollPosition.middle,
                duration: const Duration(milliseconds: 500),
              );
            } else {
              unawaited(autoScrollController.scrollToIndex(
                clampedIndex.clamp(0, metadata.lyrics!.lyrics!.length - 1),
                preferPosition: AutoScrollPosition.middle,
                duration: const Duration(milliseconds: 500),
              ));
            }
            
          }
          if (currentLineIndex != -1) {
            previousLineIndex = currentLineIndex;
          }
        }
      });
      
      return LayoutBuilder(
        builder: (context, constraints) {

          return Padding(
            padding: const EdgeInsets.only(left: 20.0, right: 16.0),
            child: LyricsListMask(
              child: ListView.builder(
                controller: autoScrollController,
                itemCount: metadata.lyrics!.lyrics?.length ?? 0,
                itemBuilder: (context, index) {
                  final line = metadata.lyrics!.lyrics![index];
                  final nextLine = index < metadata.lyrics!.lyrics!.length - 1 ? metadata.lyrics!.lyrics![index + 1] : null;
              
                  final isCurrentLine = (currentPosition?.inMicroseconds ?? 0) >= (line.start ?? 0) ~/ 10 &&
                      (nextLine == null || (currentPosition?.inMicroseconds ?? 0) < (nextLine.start ?? 0) ~/ 10 );
                        
                  return Column(
                    children: [
                      if (index == 0)
                        AutoScrollTag(
                          key: const ValueKey(-1),
                          controller: autoScrollController,
                          index: -1,
                          child: SizedBox(
                            height: constraints.maxHeight * 0.6,
                            child: Center(
                              child: SizedBox(
                                height: constraints.maxHeight * 0.5,
                                child: const PlayerScreenAlbumImage()
                              )
                            ),
                          ),
                        ),
                      AutoScrollTag(
                        key: ValueKey(index),
                        controller: autoScrollController,
                        index: index,
                        child: _LyricLine(
                          line: line,
                          isCurrentLine: isCurrentLine,
                        ),
                      ),
                      if (index == metadata.lyrics!.lyrics!.length - 1)
                        SizedBox(height: constraints.maxHeight * 0.6),
                    ],
                  );
                },
              ),
            ),
          );
        }
      );
    }

  }
}

class _LyricLine extends StatelessWidget {

  final LyricLine line;
  final bool isCurrentLine;

  const _LyricLine({
    required this.line,
    required this.isCurrentLine,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (line.start != null)
            Text(
              "${Duration(microseconds: (line.start ?? 0) ~/ 10).inMinutes}:${(Duration(microseconds: (line.start ?? 0) ~/ 10).inSeconds % 60).toString().padLeft(2, '0')}",
              style: TextStyle(
                color: isCurrentLine ? Theme.of(context).textTheme.bodyLarge!.color : Colors.grey,
                fontSize: 16,
                height: 1.75,
              ),
            ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 12.0),
              child: Text(
                line.text ?? "<missing lyric line>",
                style: TextStyle(
                  color: isCurrentLine ? Theme.of(context).textTheme.bodyLarge!.color : Colors.grey,
                  fontWeight: isCurrentLine ? FontWeight.w500 : FontWeight.normal,
                  fontSize: 26,
                  height: 1.25,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class LyricsListMask extends StatelessWidget {
  const LyricsListMask({
    super.key,
    required this.child,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      shaderCallback: (bounds) {
        return LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.transparent,
            Colors.white.withOpacity(0.5),
            Colors.white,
            Colors.white,
            Colors.white.withOpacity(0.5),
            Colors.transparent,
          ],
          stops: const [
            0.0,
            0.05,
            0.10,
            0.90,
            0.95,
            1.0,
          ],
        ).createShader(bounds);
      },
      child: child,
    );
  }
  
}
