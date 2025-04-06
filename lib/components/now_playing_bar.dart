import 'dart:async';
import 'dart:math';

import 'package:audio_service/audio_service.dart';
import 'package:finamp/color_schemes.g.dart';
import 'package:finamp/components/AddToPlaylistScreen/add_to_playlist_button.dart';
import 'package:finamp/components/print_duration.dart';
import 'package:finamp/components/audio_fade_progress_visualizer_container.dart';
import 'package:finamp/models/finamp_models.dart';
import 'package:finamp/services/current_track_metadata_provider.dart';
import 'package:finamp/services/feedback_helper.dart';
import 'package:finamp/services/one_line_marquee_helper.dart';
import 'package:finamp/services/queue_service.dart';
import 'package:finamp/services/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:finamp/l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:flutter_vibrate/flutter_vibrate.dart';
import 'package:get_it/get_it.dart';
import 'package:simple_gesture_detector/simple_gesture_detector.dart';

import '../models/jellyfin_models.dart' as jellyfin_models;
import '../screens/player_screen.dart';
import '../services/current_album_image_provider.dart';
import '../services/finamp_settings_helper.dart';
import '../services/media_state_stream.dart';
import '../services/music_player_background_task.dart';
import '../services/process_artist.dart';
import 'PlayerScreen/player_split_screen_scaffold.dart';
import 'album_image.dart';

class NowPlayingBar extends ConsumerWidget {
  const NowPlayingBar({
    super.key,
  });

  static const horizontalPadding = 8.0;
  static const albumImageSize = 70.0;

  BoxDecoration? getShadow(BuildContext context) => BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(12.0)),
          boxShadow: [
            BoxShadow(
                blurRadius: 12.0,
                spreadRadius: 8.0,
                color: Theme.of(context).brightness == Brightness.light
                    ? darkColorScheme.surface.withOpacity(0.15)
                    : darkColorScheme.surface.withOpacity(0.7))
          ]);

  Color getProgressBackgroundColor(BuildContext context) {
    return FinampSettingsHelper.finampSettings.showProgressOnNowPlayingBar
        ? Color.alphaBlend(
            Theme.of(context).brightness == Brightness.dark
                ? IconTheme.of(context).color!.withOpacity(0.35)
                : IconTheme.of(context).color!.withOpacity(0.5),
            Theme.of(context).brightness == Brightness.dark
                ? Colors.black
                : Colors.white)
        : IconTheme.of(context).color!.withOpacity(0.85);
  }

  Widget buildLoadingQueueBar(BuildContext context, Function()? retryCallback) {
    final progressBackgroundColor =
        getProgressBackgroundColor(context).withOpacity(0.5);

    return SimpleGestureDetector(
        onVerticalSwipe: (direction) {
          if (direction == SwipeDirection.up && retryCallback != null) {
            retryCallback();
          }
        },
        onTap: retryCallback,
        child: Padding(
          padding: const EdgeInsets.only(left: 12.0, bottom: 12.0, right: 12.0),
          child: Container(
            decoration: getShadow(context),
            child: Material(
              shadowColor: Theme.of(context).colorScheme.primary.withOpacity(
                  Theme.of(context).brightness == Brightness.light
                      ? 0.75
                      : 0.3),
              borderRadius: BorderRadius.circular(12.0),
              clipBehavior: Clip.antiAlias,
              color: Theme.of(context).brightness == Brightness.dark
                  ? IconTheme.of(context).color!.withOpacity(0.1)
                  : Theme.of(context).cardColor,
              elevation: 8.0,
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: albumImageSize,
                padding: EdgeInsets.zero,
                child: Container(
                  clipBehavior: Clip.antiAlias,
                  decoration: ShapeDecoration(
                    color: progressBackgroundColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                          width: albumImageSize,
                          height: albumImageSize,
                          decoration: const ShapeDecoration(
                            shape: Border(),
                            color: Color.fromRGBO(0, 0, 0, 0.3),
                          ),
                          child: (retryCallback != null)
                              ? const Icon(Icons.refresh, size: albumImageSize)
                              : const Center(
                                  child: CircularProgressIndicator.adaptive())),
                      Expanded(
                        child: Container(
                            height: albumImageSize,
                            padding: const EdgeInsets.only(left: 12, right: 4),
                            alignment: Alignment.centerLeft,
                            child: Text((retryCallback != null)
                                ? AppLocalizations.of(context)!
                                    .queueRetryMessage
                                : AppLocalizations.of(context)!
                                    .queueLoadingMessage)),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ));
  }

  Widget buildNowPlayingBar(
      BuildContext context, FinampQueueItem currentTrack) {
    final audioHandler = GetIt.instance<MusicPlayerBackgroundTask>();
    final queueService = GetIt.instance<QueueService>();

    Duration? playbackPosition;

    final currentTrackBaseItem = currentTrack.item.extras?["itemJson"] != null
        ? jellyfin_models.BaseItemDto.fromJson(
            currentTrack.item.extras!["itemJson"] as Map<String, dynamic>)
        : null;

    final progressBackgroundColor = getProgressBackgroundColor(context);

    Future openPlayerScreen() => Navigator.of(context).push(
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) =>
                const PlayerScreen(),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
              const begin = Offset(0.0, 1.0);
              const end = Offset.zero;

              var tween = Tween(begin: begin, end: end)
                  .chain(CurveTween(curve: Curves.easeInOutQuad));
              var offsetAnimation = animation.drive(tween);

              if (animation.status == AnimationStatus.reverse) {
                // dismiss animation
                return FadeTransition(
                  opacity: animation,
                  child: child,
                );
              } else {
                return SlideTransition(position: offsetAnimation, child: child);
              }
            },
            settings: const RouteSettings(name: PlayerScreen.routeName),
          ),
        );

    return SafeArea(
        child: Padding(
      padding: const EdgeInsets.only(left: 12.0, bottom: 12.0, right: 12.0),
      child: Semantics.fromProperties(
        properties: SemanticsProperties(
          label: AppLocalizations.of(context)!.nowPlayingBarTooltip,
          button: true,
        ),
        child: SimpleGestureDetector(
          onTap: openPlayerScreen,
          child: Dismissible(
            key: const Key("NowPlayingBarDismiss"),
            direction: FinampSettingsHelper.finampSettings.disableGesture
                ? DismissDirection.none
                : DismissDirection.vertical,
            confirmDismiss: (direction) async {
              if (direction == DismissDirection.down) {
                FeedbackHelper.feedback(FeedbackType.success);
                await queueService.stopPlayback();
              } else {
                await openPlayerScreen();
              }
              return false;
            },
            dismissThresholds: const {
              DismissDirection.up: 0.15,
              DismissDirection.down: 0.7
            },
            child: Container(
              clipBehavior: Clip.antiAlias,
              decoration: getShadow(context),
              //TODO use a PageView instead of a Dismissible, and only wrap dynamic items (not the buttons)
              child: Dismissible(
                key: const Key("NowPlayingBar"),
                direction: FinampSettingsHelper.finampSettings.disableGesture
                    ? DismissDirection.none
                    : DismissDirection.horizontal,
                confirmDismiss: (direction) async {
                  if (direction == DismissDirection.endToStart) {
                    FeedbackHelper.feedback(FeedbackType.light);
                    await audioHandler.skipToNext();
                  } else {
                    FeedbackHelper.feedback(FeedbackType.light);
                    await audioHandler.skipToPrevious(forceSkip: true);
                  }
                  return false;
                },
                child: Material(
                  shadowColor: Theme.of(context)
                      .colorScheme
                      .primary
                      .withOpacity(
                          Theme.of(context).brightness == Brightness.light
                              ? 0.75
                              : 0.3),
                  borderRadius: BorderRadius.circular(12.0),
                  clipBehavior: Clip.antiAlias,
                  color: Theme.of(context).brightness == Brightness.dark
                      ? IconTheme.of(context).color!.withOpacity(0.1)
                      : Theme.of(context).cardColor,
                  elevation: 8.0,
                  child: StreamBuilder<MediaState>(
                    stream: mediaStateStream
                        .where((event) => event.mediaItem != null),
                    initialData: MediaState(
                        audioHandler.mediaItem.valueOrNull,
                        audioHandler.playbackState.value,
                        audioHandler.fadeState.value),
                    builder: (context, snapshot) {
                      final MediaState mediaState = snapshot.data!;
                      final playbackState = mediaState.playbackState;
                      final fadeState = mediaState.fadeState;
                      // If we have a media item and the player hasn't finished, show
                      // the now playing bar.
                      if (mediaState.mediaItem != null) {
                        //TODO move into separate component and share with queue list
                        return Container(
                          width: MediaQuery.of(context).size.width,
                          height: albumImageSize,
                          padding: EdgeInsets.zero,
                          child: Container(
                            clipBehavior: Clip.antiAlias,
                            decoration: ShapeDecoration(
                              color: progressBackgroundColor,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12.0),
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    AlbumImage(
                                      placeholderBuilder: (_) =>
                                          const SizedBox.shrink(),
                                      imageListenable:
                                          currentAlbumImageProvider,
                                      borderRadius: BorderRadius.zero,
                                    ),
                                    AudioFadeProgressVisualizerContainer(
                                      key: const Key(
                                          "AlbumArtAudioFadeProgressVisualizer"),
                                      width: albumImageSize,
                                      height: albumImageSize,
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(12.0),
                                        bottomLeft: Radius.circular(12.0),
                                      ),
                                      child: IconButton(
                                          tooltip: AppLocalizations.of(context)!
                                              .togglePlaybackButtonTooltip,
                                          onPressed: () {
                                            FeedbackHelper.feedback(
                                                FeedbackType.light);
                                            unawaited(
                                                audioHandler.togglePlayback());
                                          },
                                          color: Colors.white,
                                          icon: Icon(
                                              playbackState.playing
                                                  ? fadeState.fadeDirection !=
                                                          FadeDirection.fadeOut
                                                      ? TablerIcons.player_pause
                                                      : TablerIcons.player_play
                                                  : TablerIcons.player_play,
                                              size: 32)),
                                    ),
                                  ],
                                ),
                                Expanded(
                                  child: Stack(
                                    children: [
                                      if (FinampSettingsHelper.finampSettings
                                          .showProgressOnNowPlayingBar)
                                        Positioned(
                                          left: 0,
                                          top: 0,
                                          child: StreamBuilder<Duration>(
                                              stream: AudioService.position,
                                              initialData: audioHandler
                                                  .playbackState.value.position,
                                              builder: (context, snapshot) {
                                                if (snapshot.hasData) {
                                                  playbackPosition =
                                                      snapshot.data;
                                                  final screenSize =
                                                      MediaQuery.of(context)
                                                          .size;
                                                  return Container(
                                                    // rather hacky workaround, using LayoutBuilder would be nice but I couldn't get it to work...
                                                    width: max(
                                                        0,
                                                        (screenSize.width -
                                                                3 *
                                                                    horizontalPadding -
                                                                albumImageSize) *
                                                            (playbackPosition!
                                                                    .inMilliseconds /
                                                                (mediaState.mediaItem
                                                                            ?.duration ??
                                                                        const Duration(
                                                                            seconds:
                                                                                0))
                                                                    .inMilliseconds)),
                                                    height: albumImageSize,
                                                    decoration: ShapeDecoration(
                                                      color: IconTheme.of(
                                                              context)
                                                          .color!
                                                          .withOpacity(0.75),
                                                      shape:
                                                          const RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius.only(
                                                          topRight:
                                                              Radius.circular(
                                                                  12),
                                                          bottomRight:
                                                              Radius.circular(
                                                                  12),
                                                        ),
                                                      ),
                                                    ),
                                                  );
                                                } else {
                                                  return Container();
                                                }
                                              }),
                                        ),
                                      Row(
                                        mainAxisSize: MainAxisSize.max,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Expanded(
                                            child: Container(
                                              height: albumImageSize,
                                              padding: const EdgeInsets.only(
                                                  left: 12, right: 4),
                                              child: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  SizedBox(
                                                    height: 20,
                                                    child: OneLineMarqueeHelper(
                                                      key: ValueKey(
                                                          currentTrack.item.id),
                                                      text: currentTrack
                                                          .item.title,
                                                      style: TextStyle(
                                                        fontSize: 16,
                                                        height: 26 / 20,
                                                        color: Colors.white,
                                                        fontWeight: Theme.of(
                                                                        context)
                                                                    .brightness ==
                                                                Brightness.light
                                                            ? FontWeight.w500
                                                            : FontWeight.w600,
                                                      ),
                                                    ),
                                                  ),
                                                  const SizedBox(height: 4),
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Expanded(
                                                        child: Text(
                                                          processArtist(
                                                              currentTrack
                                                                  .item.artist,
                                                              context),
                                                          style: TextStyle(
                                                              color: Colors
                                                                  .white
                                                                  .withOpacity(
                                                                      0.85),
                                                              fontSize: 13,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w300,
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis),
                                                        ),
                                                      ),
                                                      StreamBuilder<Duration>(
                                                          stream: AudioService
                                                              .position,
                                                          initialData:
                                                              audioHandler
                                                                  .playbackState
                                                                  .value
                                                                  .position,
                                                          builder: (context,
                                                              snapshot) {
                                                            if (snapshot
                                                                .hasData) {
                                                              playbackPosition =
                                                                  snapshot.data;
                                                              final positionFullMinutes =
                                                                  (playbackPosition
                                                                              ?.inMinutes ??
                                                                          0) %
                                                                      60;
                                                              final positionFullHours =
                                                                  (playbackPosition
                                                                          ?.inHours ??
                                                                      0);
                                                              final positionSeconds =
                                                                  (playbackPosition
                                                                              ?.inSeconds ??
                                                                          0) %
                                                                      60;
                                                              final durationFullHours = (mediaState
                                                                      .mediaItem
                                                                      ?.duration
                                                                      ?.inHours ??
                                                                  0);
                                                              final durationFullMinutes = (mediaState
                                                                          .mediaItem
                                                                          ?.duration
                                                                          ?.inMinutes ??
                                                                      0) %
                                                                  60;
                                                              final durationSeconds = (mediaState
                                                                          .mediaItem
                                                                          ?.duration
                                                                          ?.inSeconds ??
                                                                      0) %
                                                                  60;
                                                              return Semantics
                                                                  .fromProperties(
                                                                properties:
                                                                    SemanticsProperties(
                                                                  label:
                                                                      "${positionFullHours > 0 ? "$positionFullHours hours " : ""}${positionFullMinutes > 0 ? "$positionFullMinutes minutes " : ""}$positionSeconds seconds of ${durationFullHours > 0 ? "$durationFullHours hours " : ""}${durationFullMinutes > 0 ? "$durationFullMinutes minutes " : ""}$durationSeconds seconds",
                                                                ),
                                                                excludeSemantics:
                                                                    true,
                                                                container: true,
                                                                child: Row(
                                                                  children: [
                                                                    Text(
                                                                      printDuration(
                                                                          playbackPosition,
                                                                          leadingZeroes:
                                                                              false),
                                                                      style:
                                                                          TextStyle(
                                                                        fontSize:
                                                                            14,
                                                                        fontWeight:
                                                                            FontWeight.w400,
                                                                        color: Colors
                                                                            .white
                                                                            .withOpacity(0.8),
                                                                      ),
                                                                    ),
                                                                    const SizedBox(
                                                                        width:
                                                                            2),
                                                                    Text(
                                                                      '/',
                                                                      style:
                                                                          TextStyle(
                                                                        color: Colors
                                                                            .white
                                                                            .withOpacity(0.8),
                                                                        fontSize:
                                                                            14,
                                                                        fontWeight:
                                                                            FontWeight.w400,
                                                                      ),
                                                                    ),
                                                                    const SizedBox(
                                                                        width:
                                                                            2),
                                                                    Text(
                                                                      // '3:44',
                                                                      (mediaState.mediaItem?.duration?.inHours ?? 0.0) >=
                                                                              1.0
                                                                          ? "${mediaState.mediaItem?.duration?.inHours.toString()}:${((mediaState.mediaItem?.duration?.inMinutes ?? 0) % 60).toString().padLeft(2, '0')}:${((mediaState.mediaItem?.duration?.inSeconds ?? 0) % 60).toString().padLeft(2, '0')}"
                                                                          : "${mediaState.mediaItem?.duration?.inMinutes.toString()}:${((mediaState.mediaItem?.duration?.inSeconds ?? 0) % 60).toString().padLeft(2, '0')}",
                                                                      style:
                                                                          TextStyle(
                                                                        color: Colors
                                                                            .white
                                                                            .withOpacity(0.8),
                                                                        fontSize:
                                                                            14,
                                                                        fontWeight:
                                                                            FontWeight.w400,
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              );
                                                            } else {
                                                              return const SizedBox
                                                                  .shrink();
                                                            }
                                                          })
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 4.0, right: 4.0),
                                                child: AddToPlaylistButton(
                                                  item: currentTrackBaseItem,
                                                  queueItem: currentTrack,
                                                  color: Colors.white,
                                                  size: 28,
                                                  visualDensity:
                                                      const VisualDensity(
                                                          horizontal: -4),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      } else {
                        return const SizedBox.shrink();
                      }
                    },
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    ));
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final queueService = GetIt.instance<QueueService>();

    ref.listen(currentTrackMetadataProvider,
        (metadataOrNull, metadata) {}); // keep provider alive

    return Hero(
        tag: "nowplaying",
        createRectTween: (from, to) => RectTween(begin: from, end: from),
        child: PlayerScreenTheme(
          // Scaffold ignores system elements padding if bottom bar is present, so we must
          // use SafeArea in all cases to include it in our height
          child: SafeArea(
            child: StreamBuilder<FinampQueueInfo?>(
                stream: queueService.getQueueStream(),
                initialData: queueService.getQueue(),
                builder: (context, snapshot) {
                  if (snapshot.hasData &&
                      snapshot.data!.saveState == SavedQueueState.loading &&
                      !usingPlayerSplitScreen) {
                    return buildLoadingQueueBar(context, null);
                  } else if (snapshot.hasData &&
                      snapshot.data!.saveState == SavedQueueState.failed &&
                      !usingPlayerSplitScreen) {
                    return buildLoadingQueueBar(
                        context, queueService.retryQueueLoad);
                  } else if (snapshot.hasData &&
                      snapshot.data!.currentTrack != null &&
                      !usingPlayerSplitScreen) {
                    return buildNowPlayingBar(
                        context, snapshot.data!.currentTrack!);
                  } else {
                    return const SizedBox.shrink();
                  }
                }),
          ),
        ));
  }
}
