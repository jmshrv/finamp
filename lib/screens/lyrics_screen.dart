import 'dart:async';
import 'dart:io';

import 'package:finamp/color_schemes.g.dart';
import 'package:finamp/components/PlayerScreen/player_screen_appbar_title.dart';
import 'package:finamp/extensions/string.dart';
import 'package:finamp/l10n/app_localizations.dart';
import 'package:finamp/models/finamp_models.dart';
import 'package:finamp/models/jellyfin_models.dart';
import 'package:finamp/services/current_track_metadata_provider.dart';
import 'package:finamp/services/feedback_helper.dart';
import 'package:finamp/services/music_player_background_task.dart';
import 'package:finamp/services/progress_state_stream.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:flutter_to_airplay/flutter_to_airplay.dart';
import 'package:get_it/get_it.dart';
import 'package:scroll_to_index/scroll_to_index.dart';
import 'package:simple_gesture_detector/simple_gesture_detector.dart';

import '../components/PlayerScreen/control_area.dart';
import '../components/PlayerScreen/player_screen_album_image.dart';
import '../components/PlayerScreen/queue_list.dart';
import '../components/PlayerScreen/track_name_content.dart';
import '../components/finamp_app_bar_button.dart';
import '../services/finamp_settings_helper.dart';
import '../services/theme_provider.dart';
import 'blurred_player_screen_background.dart';
import 'player_screen.dart';

class LyricsScreen extends StatelessWidget {
  const LyricsScreen({super.key});

  static const routeName = "/lyrics";

  @override
  Widget build(BuildContext context) {
    return PlayerScreenTheme(child: const _LyricsScreenContent());
  }
}

class _LyricsScreenContent extends ConsumerStatefulWidget {
  const _LyricsScreenContent();

  @override
  ConsumerState<_LyricsScreenContent> createState() => _LyricsScreenContentState();
}

class _LyricsScreenContentState extends ConsumerState<_LyricsScreenContent> {
  @override
  Widget build(BuildContext context) {
    double toolbarHeight = 53;
    int maxLines = 2;

    var controller = PlayerHideableController();

    return SimpleGestureDetector(
      onVerticalSwipe: (direction) {
        if (direction == SwipeDirection.up) {
          // This should never actually be called until widget finishes build and controller is initialized
          if (!FinampSettingsHelper.finampSettings.disableGesture ||
              !controller.shouldShow(PlayerHideable.bottomActions)) {
            showQueueBottomSheet(context, ref);
          }
        }
      },
      onHorizontalSwipe: (direction) {
        if (direction == SwipeDirection.right) {
          if (!FinampSettingsHelper.finampSettings.disableGesture) {
            Navigator.of(context).pop();
          }
        }
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          // Disable tint/shadow when content is scrolled under the app bar
          scrolledUnderElevation: 0.0,
          centerTitle: true,
          toolbarHeight: toolbarHeight,
          title: PlayerScreenAppBarTitle(maxLines: maxLines),
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
                  onShowPickerView: () => FeedbackHelper.feedback(FeedbackType.selection),
                ),
              ),
          ],
        ),
        // Required for sleep timer input
        resizeToAvoidBottomInset: false,
        extendBodyBehindAppBar: true,
        body: Stack(
          children: [
            if (ref.watch(finampSettingsProvider.useCoverAsBackground)) const BlurredPlayerScreenBackground(),
            SafeArea(
              minimum: EdgeInsets.only(top: toolbarHeight),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  controller.setSize(
                    Size(constraints.maxWidth, constraints.maxHeight),
                    MediaQuery.orientationOf(context),
                    ref,
                  );
                  if (controller.useLandscape) {
                    return const LyricsView();
                  } else {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        const Expanded(child: LyricsView()),
                        SimpleGestureDetector(
                          onVerticalSwipe: (direction) {
                            if (direction == SwipeDirection.up) {
                              // This should never actually be called until widget finishes build and controller is initialized
                              if (!FinampSettingsHelper.finampSettings.disableGesture) {
                                showQueueBottomSheet(context, ref);
                              }
                            }
                          },
                          child: Column(
                            children: [
                              TrackNameContent(controller),
                              ControlArea(controller),
                              const SizedBox(height: 12),
                            ],
                          ),
                        ),
                      ],
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class LyricsView extends ConsumerStatefulWidget {
  const LyricsView({super.key});

  @override
  ConsumerState createState() => _LyricsViewState();
}

class _LyricsViewState extends ConsumerState<LyricsView> with WidgetsBindingObserver {
  late AutoScrollController autoScrollController;
  StreamSubscription<ProgressState>? progressStateStreamSubscription;
  Duration? currentPosition;
  int? currentLineIndex;
  int? previousLineIndex;

  bool isAutoScrollEnabled = true;

  bool _isVisible = true;
  bool _isSynchronizedLyrics = false;

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    autoScrollController = AutoScrollController(
      suggestedRowHeight: 72,
      viewportBoundaryGetter: () => Rect.fromLTRB(0, 0, 0, MediaQuery.of(context).padding.bottom),
      axis: Axis.vertical,
    );

    autoScrollController.addListener(() {
      var position = autoScrollController.position;
      if (position.userScrollDirection != ScrollDirection.idle && _isSynchronizedLyrics && isAutoScrollEnabled) {
        setState(() {
          isAutoScrollEnabled = false;
        });
      }
    });

    super.initState();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    _isVisible = [AppLifecycleState.resumed, AppLifecycleState.inactive].contains(state);
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
    final audioHandler = GetIt.instance<MusicPlayerBackgroundTask>();

    final metadata = ref.watch(currentTrackMetadataProvider).unwrapPrevious();
    final finampSettings = ref.watch(finampSettingsProvider).value;

    //!!! use unwrapPrevious() to prevent getting previous values. If we don't have the lyrics for the current track yet, we want to show the loading state, and not the lyrics for the previous track
    _isSynchronizedLyrics = metadata.valueOrNull?.lyrics?.lyrics?.first.start != null;

    Widget getEmptyState({required String message, required IconData icon}) {
      return Center(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ConstrainedBox(
                  constraints: BoxConstraints(maxHeight: constraints.maxHeight - 180),
                  child: (finampSettings?.showLyricsScreenAlbumPrelude ?? true)
                      ? const PlayerScreenAlbumImage()
                      : SizedBox(),
                ),
                const SizedBox(height: 24),
                Icon(icon, size: 32, color: Theme.of(context).textTheme.headlineMedium!.color),
                const SizedBox(height: 12),
                Text(message, style: TextStyle(color: Theme.of(context).textTheme.headlineMedium!.color, fontSize: 16)),
              ],
            );
          },
        ),
      );
    }

    if ((metadata.isLoading && !metadata.hasValue) || metadata.isRefreshing) {
      return getEmptyState(message: "Loading lyrics...", icon: TablerIcons.microphone_2);
    } else if (!metadata.hasValue ||
        metadata.value == null ||
        metadata.value!.hasLyrics && metadata.value!.lyrics == null && !metadata.isLoading) {
      return getEmptyState(message: "Couldn't load lyrics!", icon: TablerIcons.microphone_2_off);
    } else if (!metadata.value!.hasLyrics) {
      return getEmptyState(message: "No lyrics available.", icon: TablerIcons.microphone_2_off);
    } else {
      // We have lyrics that we can display
      final lyricLines = metadata.value!.lyrics!.lyrics ?? [];

      progressStateStreamSubscription?.cancel();
      progressStateStreamSubscription = progressStateStream.listen((state) async {
        currentPosition = state.position;
        final currentMicros = state.position.inMicroseconds;

        if (!_isSynchronizedLyrics || !_isVisible) {
          return;
        }

        // Find the closest line to the current position, clamping to the first and last lines
        int closestLineIndex = -1;
        for (int i = 0; i < lyricLines.length; i++) {
          closestLineIndex = i;
          final line = lyricLines[i];
          if (line.startMicros > currentMicros) {
            closestLineIndex = i - 1;
            break;
          }
        }

        currentLineIndex = closestLineIndex;
        if (currentLineIndex! != previousLineIndex) {
          setState(() {}); // Rebuild to update the current line
          if (autoScrollController.hasClients && isAutoScrollEnabled) {
            int clampedIndex = currentLineIndex ?? 0;
            if (clampedIndex >= lyricLines.length) {
              clampedIndex = lyricLines.length - 1;
            }
            if (clampedIndex < 0) {
              await autoScrollController.scrollToIndex(
                -1,
                preferPosition: AutoScrollPosition.middle,
                duration: MediaQuery.of(context).disableAnimations
                    ? const Duration(
                        milliseconds: 1,
                      ) // there's an assertion in the library forbidding a duration of 0, so we use 1ms instead to get instant scrolling
                    : const Duration(milliseconds: 300),
              );
            } else {
              unawaited(
                autoScrollController.scrollToIndex(
                  clampedIndex.clamp(0, lyricLines.length - 1),
                  preferPosition: AutoScrollPosition.middle,
                  duration: MediaQuery.of(context).disableAnimations
                      ? const Duration(
                          milliseconds: 1,
                        ) // there's an assertion in the library forbidding a duration of 0, so we use 1ms instead to get instant scrolling
                      : const Duration(milliseconds: 300),
                ),
              );
            }
          }
          previousLineIndex = currentLineIndex;
        }
      });

      return LayoutBuilder(
        builder: (context, constraints) {
          return Padding(
            padding: const EdgeInsets.only(left: 20.0, right: 12.0),
            child: Stack(
              children: [
                LyricsListMask(
                  child: ListView.builder(
                    controller: autoScrollController,
                    itemCount: lyricLines.length,
                    itemBuilder: (context, index) {
                      final currentMicros = currentPosition?.inMicroseconds ?? 0;
                      final line = lyricLines[index];
                      final nextLine = index < lyricLines.length - 1 ? lyricLines[index + 1] : null;

                      final isCurrentLine =
                          currentMicros >= line.startMicros &&
                          (nextLine == null || currentMicros < nextLine.startMicros);

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          if (index == 0)
                            AutoScrollTag(
                              key: const ValueKey(-1),
                              controller: autoScrollController,
                              index: -1,
                              child: (finampSettings?.showLyricsScreenAlbumPrelude ?? true)
                                  ? SizedBox(
                                      height: constraints.maxHeight * 0.65,
                                      child: Center(
                                        child: SizedBox(
                                          height: constraints.maxHeight * 0.55,
                                          child: const PlayerScreenAlbumImage(),
                                        ),
                                      ),
                                    )
                                  : SizedBox(height: constraints.maxHeight * 0.2),
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
                                await audioHandler.seek(Duration(microseconds: line.startMicros));
                                setState(() {
                                  isAutoScrollEnabled = true;
                                });
                                if (previousLineIndex != null) {
                                  unawaited(
                                    autoScrollController.scrollToIndex(
                                      previousLineIndex!,
                                      preferPosition: AutoScrollPosition.middle,
                                      duration: MediaQuery.of(context).disableAnimations
                                          ? const Duration(
                                              milliseconds: 1,
                                            ) // there's an assertion in the library forbidding a duration of 0, so we use 1ms instead to get instant scrolling
                                          : const Duration(milliseconds: 500),
                                    ),
                                  );
                                }
                              },
                            ),
                          ),
                          if (index == lyricLines.length - 1) SizedBox(height: constraints.maxHeight * 0.2),
                        ],
                      );
                    },
                  ),
                ),
                if (_isSynchronizedLyrics)
                  Positioned(
                    bottom: 24,
                    right: 0,
                    child: EnableAutoScrollButton(
                      autoScrollEnabled: isAutoScrollEnabled,
                      onEnableAutoScroll: () {
                        setState(() {
                          isAutoScrollEnabled = true;
                        });
                        if (previousLineIndex != null) {
                          unawaited(
                            autoScrollController.scrollToIndex(
                              previousLineIndex!,
                              preferPosition: AutoScrollPosition.middle,
                              duration: MediaQuery.of(context).disableAnimations
                                  ? const Duration(
                                      milliseconds: 1,
                                    ) // there's an assertion in the library forbidding a duration of 0, so we use 1ms instead to get instant scrolling
                                  : const Duration(milliseconds: 500),
                            ),
                          );
                        }
                        FeedbackHelper.feedback(FeedbackType.heavy);
                      },
                    ),
                  ),
              ],
            ),
          );
        },
      );
    }
  }
}

class _LyricLine extends ConsumerWidget {
  final LyricLine line;
  final bool isCurrentLine;
  final VoidCallback? onTap;

  const _LyricLine({required this.line, required this.isCurrentLine, this.onTap});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final finampSettings = ref.watch(finampSettingsProvider).value;

    final isSynchronized = line.start != null;
    final showTimestamp = isSynchronized && !line.text.isNullOrBlank && (finampSettings?.showLyricsTimestamps ?? true);
    final lowlightLine = isSynchronized && !isCurrentLine;

    return GestureDetector(
      onTap: isSynchronized ? onTap : null,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: isSynchronized ? 10.0 : 6.0),
        child: Text.rich(
          textAlign: lyricsAlignmentToTextAlign(finampSettings?.lyricsAlignment ?? LyricsAlignment.start),
          softWrap: true,
          TextSpan(
            children: [
              if (showTimestamp)
                WidgetSpan(
                  alignment: PlaceholderAlignment.bottom,
                  child: Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: Text(
                      "${Duration(microseconds: line.startMicros).inMinutes}:${(Duration(microseconds: line.startMicros).inSeconds % 60).toString().padLeft(2, '0')}",
                      style: TextStyle(
                        color: lowlightLine ? Colors.grey : Theme.of(context).textTheme.bodyLarge!.color,
                        fontSize: 16,
                        height:
                            1.75 * (lyricsFontSizeToSize(finampSettings?.lyricsFontSize ?? LyricsFontSize.medium) / 26),
                      ),
                    ),
                  ),
                ),
              TextSpan(
                text: line.text ?? "<missing lyric line>",
                style: TextStyle(
                  color: lowlightLine ? Colors.grey : Theme.of(context).textTheme.bodyLarge!.color,
                  fontWeight: lowlightLine || !isSynchronized ? FontWeight.normal : FontWeight.w500,
                  // Keep text width consistent across the different weights
                  letterSpacing: lowlightLine || !isSynchronized ? 0.05 : -0.045,
                  fontSize:
                      lyricsFontSizeToSize(finampSettings?.lyricsFontSize ?? LyricsFontSize.medium) *
                      (isSynchronized ? 1.0 : 0.75),
                  height: 1.25,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class LyricsListMask extends StatelessWidget {
  const LyricsListMask({super.key, required this.child});

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
          stops: const [0.0, 0.05, 0.10, 0.90, 0.95, 1.0],
        ).createShader(bounds);
      },
      child: child,
    );
  }
}

class EnableAutoScrollButton extends StatelessWidget {
  final bool autoScrollEnabled;
  final VoidCallback? onEnableAutoScroll;

  const EnableAutoScrollButton({super.key, required this.autoScrollEnabled, this.onEnableAutoScroll});

  @override
  Widget build(BuildContext context) {
    return !autoScrollEnabled
        ? FloatingActionButton.extended(
            onPressed: () {
              FeedbackHelper.feedback(FeedbackType.heavy);
              onEnableAutoScroll?.call();
            },
            backgroundColor: IconTheme.of(context).color!.withOpacity(0.70),
            shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(16.0))),
            icon: Icon(TablerIcons.arrow_bar_to_up, size: 28.0, color: Colors.white.withOpacity(0.9)),
            label: Text(
              AppLocalizations.of(context)!.enableAutoScroll,
              style: TextStyle(color: Colors.white.withOpacity(0.9), fontSize: 14.0, fontWeight: FontWeight.w500),
            ),
          )
        : const SizedBox.shrink();
  }
}

TextAlign lyricsAlignmentToTextAlign(LyricsAlignment alignment) {
  switch (alignment) {
    case LyricsAlignment.start:
      return TextAlign.start;
    case LyricsAlignment.center:
      return TextAlign.center;
    case LyricsAlignment.end:
      return TextAlign.end;
  }
}

int lyricsFontSizeToSize(LyricsFontSize fontSize) {
  switch (fontSize) {
    case LyricsFontSize.small:
      return 20;
    case LyricsFontSize.medium:
      return 26;
    case LyricsFontSize.large:
      return 32;
  }
}
