import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:finamp/color_schemes.g.dart';
import 'package:finamp/components/PlayerScreen/player_screen_appbar_title.dart';
import 'package:finamp/models/jellyfin_models.dart';
import 'package:finamp/services/current_track_metadata_provider.dart';
import 'package:finamp/services/feedback_helper.dart';
import 'package:finamp/services/metadata_provider.dart';
import 'package:finamp/services/music_player_background_task.dart';
import 'package:finamp/services/progress_state_stream.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:flutter_to_airplay/flutter_to_airplay.dart';
import 'package:flutter_vibrate/flutter_vibrate.dart';
import 'package:get_it/get_it.dart';
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
        scrolledUnderElevation: 0.0, // disable tint/shadow when content is scrolled under the app bar
        centerTitle: true,
        toolbarHeight: toolbarHeight,
        title: PlayerScreenAppBarTitle(
          maxLines: maxLines,
        ),
        leading: FinampAppBarButton(
          dismissDirection: AxisDirection.right,
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
                controller.updateLayoutLandscape(Size(constraints.maxWidth, constraints.maxHeight));
                return SimpleGestureDetector(
                  onHorizontalSwipe: (direction) {
                    if (direction == SwipeDirection.right) {
                      if (!FinampSettingsHelper.finampSettings.disableGesture) {
                        Navigator.of(context).pop();
                      }
                    }
                  },
                  child: const LyricsView()
                );
              } else {
                controller.updateLayoutPortrait(Size(constraints.maxWidth, constraints.maxHeight));
                return SimpleGestureDetector(
                  onHorizontalSwipe: (direction) {
                    if (direction == SwipeDirection.right) {
                      if (!FinampSettingsHelper.finampSettings.disableGesture) {
                        Navigator.of(context).pop();
                      }
                    }
                  },
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      const Expanded(
                        child: LyricsView(),
                      ),
                      SimpleGestureDetector(
                        onVerticalSwipe: (direction) {
                          if (direction == SwipeDirection.up) {
                            // This should never actually be called until widget finishes build and controller is initialized
                            if (!FinampSettingsHelper.finampSettings.disableGesture) {
                              showQueueBottomSheet(context);
                            }
                          }
                        },
                        child: Column(
                          children: [
                            SongNameContent(controller),
                            ControlArea(controller),
                            const SizedBox(
                              height: 12,
                            )
                          ],
                        )
                      )
                    ],
                  ),
                );
              }
            }),
          ),
        ],
      ),
    );
  }
}

class LyricsView extends ConsumerStatefulWidget {
  const LyricsView();

  @override
  _LyricsViewState createState() => _LyricsViewState();
}

class _LyricsViewState extends ConsumerState<LyricsView> with WidgetsBindingObserver {

  late AutoScrollController autoScrollController;
  StreamSubscription<ProgressState>? progressStateStreamSubscription;
  Duration? currentPosition;
  int? currentLineIndex;
  int? previousLineIndex;

  bool _isInForeground = true;

  @override
  void initState() {
    WidgetsBinding.instance!.addObserver(this);
    autoScrollController = AutoScrollController(
      suggestedRowHeight: 72,
      viewportBoundaryGetter: () =>
          Rect.fromLTRB(0, 0, 0, MediaQuery.of(context).padding.bottom),
      axis: Axis.vertical);
    super.initState();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    _isInForeground = state == AppLifecycleState.resumed;
    super.didChangeAppLifecycleState(state);
  }

  @override
  void dispose() {
    progressStateStreamSubscription?.cancel();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final metadata = ref.watch(currentTrackMetadataProvider);

    final _audioHandler = GetIt.instance<MusicPlayerBackgroundTask>();

    Widget getEmptyState({
      required String message,
      required IconData icon,
    }) {
      return Center(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ConstrainedBox(
                  constraints: BoxConstraints(
                    maxHeight: constraints.maxHeight - 180,
                  ),
                  child: const PlayerScreenAlbumImage()
                ),
                const SizedBox(height: 24),
                Icon(
                  icon,
                  size: 32,
                  color: Theme.of(context).textTheme.headlineMedium!.color,
                ),
                const SizedBox(height: 12),
                Text(
                  message,
                  style: TextStyle(
                    color: Theme.of(context).textTheme.headlineMedium!.color,
                    fontSize: 16,
                  ),
                ),
              ],
            );
          }
        ),
      );
    }

    if (metadata.isLoading || metadata.isRefreshing) {
      return getEmptyState(
        message: "Loading lyrics...",
        icon: TablerIcons.microphone_2,
      );
    } else if (metadata.value == null || metadata.value!.hasLyrics && metadata.value!.lyrics == null && !metadata.isLoading) {
      return getEmptyState(
        message: "Couldn't load lyrics!",
        icon: TablerIcons.microphone_2_off,
      );
    } else if (!metadata.value!.hasLyrics) {
      return getEmptyState(
        message: "No lyrics available.",
        icon: TablerIcons.microphone_2_off,
      );
    } else {

      progressStateStreamSubscription?.cancel();
      progressStateStreamSubscription = progressStateStream.listen((state) async {
        currentPosition = state.position;

        if (metadata.value!.lyrics!.lyrics?.first.start == null || !_isInForeground) {
          return;
        }

        // find the closest line to the current position, clamping to the first and last lines
        int closestLineIndex = -1;
        for (int i = 0; i < metadata.value!.lyrics!.lyrics!.length; i++) {
          closestLineIndex = i;
          final line = metadata.value!.lyrics!.lyrics![i];
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
            if (clampedIndex >= metadata.value!.lyrics!.lyrics!.length) {
              clampedIndex = metadata.value!.lyrics!.lyrics!.length - 1;
            }
            // print("currentPosition: ${currentPosition?.inMicroseconds}, currentLineIndex: $currentLineIndex, line: ${metadata.value!.lyrics!.lyrics![clampedIndex].text}");
            if (clampedIndex < 0) {
              await autoScrollController.scrollToIndex(
                -1,
                preferPosition: AutoScrollPosition.middle,
                duration: const Duration(milliseconds: 500),
              );
            } else {
              unawaited(autoScrollController.scrollToIndex(
                clampedIndex.clamp(0, metadata.value!.lyrics!.lyrics!.length - 1),
                preferPosition: AutoScrollPosition.middle,
                duration: const Duration(milliseconds: 500),
              ));
            }
            
          }
          previousLineIndex = currentLineIndex;
        }
      });
      
      return LayoutBuilder(
        builder: (context, constraints) {

          return Padding(
            padding: const EdgeInsets.only(left: 20.0, right: 12.0),
            child: LyricsListMask(
              child: ListView.builder(
                controller: autoScrollController,
                itemCount: metadata.value!.lyrics!.lyrics?.length ?? 0,
                itemBuilder: (context, index) {
                  final line = metadata.value!.lyrics!.lyrics![index];
                  final nextLine = index < metadata.value!.lyrics!.lyrics!.length - 1 ? metadata.value!.lyrics!.lyrics![index + 1] : null;
              
                  final isCurrentLine = (currentPosition?.inMicroseconds ?? 0) >= (line.start ?? 0) ~/ 10 &&
                      (nextLine == null || (currentPosition?.inMicroseconds ?? 0) < (nextLine.start ?? 0) ~/ 10 );
                        
                  return Column(
                    children: [
                      if (index == 0)
                        AutoScrollTag(
                          key: const ValueKey(-1),
                          controller: autoScrollController,
                          index: -1,
                          child: GestureDetector(
                            onTap: () async {
                              // Seek to the start of the song
                              await _audioHandler.seek(Duration.zero);
                            },
                            child: SizedBox(
                              height: constraints.maxHeight * 0.65,
                              child: Center(
                                child: SizedBox(
                                  height: constraints.maxHeight * 0.55,
                                  child: const PlayerScreenAlbumImage()
                                )
                              ),
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
                          onTap: () async {
                            // Seek to the start of the line
                            await _audioHandler.seek(Duration(microseconds: (line.start ?? 0) ~/ 10));
                          } 
                        ),
                      ),
                      if (index == metadata.value!.lyrics!.lyrics!.length - 1)
                        SizedBox(height: constraints.maxHeight * 0.2),
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
  final VoidCallback? onTap;

  const _LyricLine({
    required this.line,
    required this.isCurrentLine,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {

    final lowlightLine = !isCurrentLine && line.start != null;
    final isSynchronized = line.start != null;
    
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: isSynchronized ? 10.0 : 6.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (line.start != null)
              Text(
                "${Duration(microseconds: (line.start ?? 0) ~/ 10).inMinutes}:${(Duration(microseconds: (line.start ?? 0) ~/ 10).inSeconds % 60).toString().padLeft(2, '0')}",
                style: TextStyle(
                  color: lowlightLine ? Colors.grey : Theme.of(context).textTheme.bodyLarge!.color,
                  fontSize: 16,
                  height: 1.75,
                ),
              ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 12.0),
                child: Text(
                  line.text ?? "<missing lyric line>",
                  textAlign: TextAlign.start,
                  style: TextStyle(
                    color: lowlightLine ? Colors.grey : Theme.of(context).textTheme.bodyLarge!.color,
                    fontWeight: lowlightLine || !isSynchronized ? FontWeight.normal : FontWeight.w500,
                    letterSpacing: lowlightLine || !isSynchronized ? 0.05 : -0.045, // keep text width consistent across the different weights
                    fontSize: isSynchronized ? 26 : 20,
                    height: 1.25,
                  ),
                ),
              ),
            ),
          ],
        ),
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