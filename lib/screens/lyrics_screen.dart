import 'dart:async';
import 'dart:io';

import 'package:finamp/color_schemes.g.dart';
import 'package:finamp/components/PlayerScreen/player_screen_appbar_title.dart';
import 'package:finamp/models/finamp_models.dart';
import 'package:finamp/models/jellyfin_models.dart';
import 'package:finamp/services/current_track_metadata_provider.dart';
import 'package:finamp/services/feedback_helper.dart';
import 'package:finamp/services/music_player_background_task.dart';
import 'package:finamp/services/progress_state_stream.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:flutter_to_airplay/flutter_to_airplay.dart';
import 'package:flutter_vibrate/flutter_vibrate.dart';
import 'package:get_it/get_it.dart';
import 'package:scroll_to_index/scroll_to_index.dart';
import 'package:simple_gesture_detector/simple_gesture_detector.dart';

import '../components/PlayerScreen/control_area.dart';
import '../components/PlayerScreen/player_screen_album_image.dart';
import '../components/PlayerScreen/queue_list.dart';
import '../components/PlayerScreen/song_name_content.dart';
import '../components/finamp_app_bar_button.dart';
import '../services/finamp_settings_helper.dart';
import '../services/theme_provider.dart';
import 'blurred_player_screen_background.dart';
import 'player_screen.dart';

class LyricsScreen extends ConsumerWidget {
  const LyricsScreen({Key? key}) : super(key: key);

  static const routeName = "/lyrics";

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final imageTheme = ref.watch(playerScreenThemeProvider);

    return ProviderScope(
        overrides: [
          themeDataProvider.overrideWith((ref) {
            return ref.watch(playerScreenThemeDataProvider) ??
                FinampTheme.defaultTheme();
          })
        ],
        child: AnimatedTheme(
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
        ));
  }
}

class _LyricsScreenContent extends StatefulWidget {
  const _LyricsScreenContent({
    super.key,
  });

  @override
  State<_LyricsScreenContent> createState() => _LyricsScreenContentState();
}

class _LyricsScreenContentState extends State<_LyricsScreenContent> {
  @override
  Widget build(BuildContext context) {
    double toolbarHeight = 53;
    int maxLines = 2;

    var controller = PlayerHideableController();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation:
            0.0, // disable tint/shadow when content is scrolled under the app bar
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
              controller.setSize(
                  Size(constraints.maxWidth, constraints.maxHeight),
                  MediaQuery.orientationOf(context));
              if (controller.useLandscape) {
                return SimpleGestureDetector(
                    onHorizontalSwipe: (direction) {
                      if (direction == SwipeDirection.right) {
                        if (!FinampSettingsHelper
                            .finampSettings.disableGesture) {
                          Navigator.of(context).pop();
                        }
                      }
                    },
                    child: const LyricsView());
              } else {
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
                              if (!FinampSettingsHelper
                                  .finampSettings.disableGesture) {
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
                          ))
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
  const LyricsView({super.key});

  @override
  ConsumerState createState() => _LyricsViewState();
}

class _LyricsViewState extends ConsumerState<LyricsView>
    with WidgetsBindingObserver {
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
        viewportBoundaryGetter: () =>
            Rect.fromLTRB(0, 0, 0, MediaQuery.of(context).padding.bottom),
        axis: Axis.vertical);

    autoScrollController.addListener(() {
      var position = autoScrollController.position;
      if (position.userScrollDirection != ScrollDirection.idle &&
          _isSynchronizedLyrics &&
          isAutoScrollEnabled) {
        setState(() {
          isAutoScrollEnabled = false;
        });
      }
    });

    super.initState();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    _isVisible =
        [AppLifecycleState.resumed, AppLifecycleState.inactive].contains(state);
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

    //!!! use unwrapPrevious() to prevent getting previous values. If we don't have the lyrics for the current song yet, we want to show the loading state, and not the lyrics for the previous track
    _isSynchronizedLyrics =
        metadata.valueOrNull?.lyrics?.lyrics?.first.start != null;

    Widget getEmptyState({
      required String message,
      required IconData icon,
    }) {
      return Center(
        child: LayoutBuilder(builder: (context, constraints) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ConstrainedBox(
                  constraints: BoxConstraints(
                    maxHeight: constraints.maxHeight - 180,
                  ),
                  child: const PlayerScreenAlbumImage()),
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
        }),
      );
    }

    if ((metadata.isLoading && !metadata.hasValue) || metadata.isRefreshing) {
      return getEmptyState(
        message: "Loading lyrics...",
        icon: TablerIcons.microphone_2,
      );
    } else if (!metadata.hasValue ||
        metadata.value == null ||
        metadata.value!.hasLyrics &&
            metadata.value!.lyrics == null &&
            !metadata.isLoading) {
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
      progressStateStreamSubscription =
          progressStateStream.listen((state) async {
        currentPosition = state.position;

        if (!_isSynchronizedLyrics || !_isVisible) {
          return;
        }

        // find the closest line to the current position, clamping to the first and last lines
        int closestLineIndex = -1;
        for (int i = 0; i < metadata.value!.lyrics!.lyrics!.length; i++) {
          closestLineIndex = i;
          final line = metadata.value!.lyrics!.lyrics![i];
          if ((line.start ?? 0) ~/ 10 >
              (currentPosition?.inMicroseconds ?? 0)) {
            closestLineIndex = i - 1;
            break;
          }
        }

        currentLineIndex = closestLineIndex;
        if (currentLineIndex! != previousLineIndex) {
          setState(() {}); // Rebuild to update the current line
          if (autoScrollController.hasClients && isAutoScrollEnabled) {
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
                clampedIndex.clamp(
                    0, metadata.value!.lyrics!.lyrics!.length - 1),
                preferPosition: AutoScrollPosition.middle,
                duration: const Duration(milliseconds: 500),
              ));
            }
          }
          previousLineIndex = currentLineIndex;
        }
      });

      return LayoutBuilder(builder: (context, constraints) {
        return Padding(
          padding: const EdgeInsets.only(left: 20.0, right: 12.0),
          child: Stack(
            children: [
              LyricsListMask(
                child: ListView.builder(
                  controller: autoScrollController,
                  itemCount: metadata.value!.lyrics!.lyrics?.length ?? 0,
                  itemBuilder: (context, index) {
                    final line = metadata.value!.lyrics!.lyrics![index];
                    final nextLine =
                        index < metadata.value!.lyrics!.lyrics!.length - 1
                            ? metadata.value!.lyrics!.lyrics![index + 1]
                            : null;

                    final isCurrentLine =
                        (currentPosition?.inMicroseconds ?? 0) >=
                                (line.start ?? 0) ~/ 10 &&
                            (nextLine == null ||
                                (currentPosition?.inMicroseconds ?? 0) <
                                    (nextLine.start ?? 0) ~/ 10);

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        if (index == 0)
                          AutoScrollTag(
                            key: const ValueKey(-1),
                            controller: autoScrollController,
                            index: -1,
                            child: SizedBox(
                              height: constraints.maxHeight * 0.65,
                              child: Center(
                                  child: SizedBox(
                                      height: constraints.maxHeight * 0.55,
                                      child: (finampSettings
                                                  ?.showLyricsScreenAlbumPrelude ??
                                              true)
                                          ? const PlayerScreenAlbumImage()
                                          : null)),
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
                                await audioHandler.seek(Duration(
                                    microseconds: (line.start ?? 0) ~/ 10));
                                setState(() {
                                  isAutoScrollEnabled = true;
                                });
                                if (previousLineIndex != null) {
                                  unawaited(autoScrollController.scrollToIndex(
                                    previousLineIndex!,
                                    preferPosition: AutoScrollPosition.middle,
                                    duration: const Duration(milliseconds: 500),
                                  ));
                                }
                              }),
                        ),
                        if (index == metadata.value!.lyrics!.lyrics!.length - 1)
                          SizedBox(height: constraints.maxHeight * 0.2),
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
                          unawaited(autoScrollController.scrollToIndex(
                            previousLineIndex!,
                            preferPosition: AutoScrollPosition.middle,
                            duration: const Duration(milliseconds: 500),
                          ));
                        }
                        FeedbackHelper.feedback(FeedbackType.impact);
                      }),
                ),
            ],
          ),
        );
      });
    }
  }
}

class _LyricLine extends ConsumerWidget {
  final LyricLine line;
  final bool isCurrentLine;
  final VoidCallback? onTap;

  const _LyricLine({
    required this.line,
    required this.isCurrentLine,
    this.onTap,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final lowlightLine = !isCurrentLine && line.start != null;
    final isSynchronized = line.start != null;

    final finampSettings = ref.watch(finampSettingsProvider).value;

    return GestureDetector(
      onTap: isSynchronized ? onTap : null,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: isSynchronized ? 10.0 : 6.0),
        child: Text.rich(
          textAlign: lyricsAlignmentToTextAlign(
              finampSettings?.lyricsAlignment ?? LyricsAlignment.start),
          softWrap: true,
          TextSpan(children: [
            if (line.start != null &&
                (line.text?.trim().isNotEmpty ?? false) &&
                (finampSettings?.showLyricsTimestamps ?? true))
              WidgetSpan(
                alignment: PlaceholderAlignment.bottom,
                child: Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: Text(
                    "${Duration(microseconds: (line.start ?? 0) ~/ 10).inMinutes}:${(Duration(microseconds: (line.start ?? 0) ~/ 10).inSeconds % 60).toString().padLeft(2, '0')}",
                    style: TextStyle(
                      color: lowlightLine
                          ? Colors.grey
                          : Theme.of(context).textTheme.bodyLarge!.color,
                      fontSize: 16,
                      height: 1.75 *
                          (lyricsFontSizeToSize(
                                  finampSettings?.lyricsFontSize ??
                                      LyricsFontSize.medium) /
                              26),
                    ),
                  ),
                ),
              ),
            TextSpan(
              text: line.text ?? "<missing lyric line>",
              style: TextStyle(
                color: lowlightLine
                    ? Colors.grey
                    : Theme.of(context).textTheme.bodyLarge!.color,
                fontWeight: lowlightLine || !isSynchronized
                    ? FontWeight.normal
                    : FontWeight.w500,
                letterSpacing: lowlightLine || !isSynchronized
                    ? 0.05
                    : -0.045, // keep text width consistent across the different weights
                fontSize: lyricsFontSizeToSize(finampSettings?.lyricsFontSize ??
                        LyricsFontSize.medium) *
                    (isSynchronized ? 1.0 : 0.75),
                height: 1.25,
              ),
            ),
          ]),
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

class EnableAutoScrollButton extends StatelessWidget {
  final bool autoScrollEnabled;
  final VoidCallback? onEnableAutoScroll;

  const EnableAutoScrollButton(
      {super.key, required this.autoScrollEnabled, this.onEnableAutoScroll});

  @override
  Widget build(BuildContext context) {
    return !autoScrollEnabled
        ? FloatingActionButton.extended(
            onPressed: () {
              FeedbackHelper.feedback(FeedbackType.impact);
              onEnableAutoScroll?.call();
            },
            backgroundColor: IconTheme.of(context).color!.withOpacity(0.70),
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(16.0))),
            icon: Icon(
              TablerIcons.arrow_bar_to_up,
              size: 28.0,
              color: Colors.white.withOpacity(0.9),
            ),
            label: Text(
              AppLocalizations.of(context)!.enableAutoScroll,
              style: TextStyle(
                color: Colors.white.withOpacity(0.9),
                fontSize: 14.0,
                fontWeight: FontWeight.w500,
              ),
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
