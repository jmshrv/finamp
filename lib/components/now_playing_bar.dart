import 'dart:math';

import 'package:audio_service/audio_service.dart';
import 'package:Finamp/color_schemes.g.dart';
import 'package:Finamp/components/favourite_button.dart';
import 'package:Finamp/models/finamp_models.dart';
import 'package:Finamp/services/feedback_helper.dart';
import 'package:Finamp/services/theme_provider.dart';
import 'package:Finamp/services/current_track_metadata_provider.dart';
import 'package:Finamp/services/feedback_helper.dart';
import 'package:Finamp/services/theme_provider.dart';
import 'package:Finamp/services/queue_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
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

  BoxDecoration? getShadow(BuildContext context) => BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(12.0)),
          boxShadow: [
            BoxShadow(
                blurRadius: 12.0,
                spreadRadius: 8.0,
                color: Theme.of(context).brightness == Brightness.light
                    ? darkColorScheme.background.withOpacity(0.15)
                    : darkColorScheme.background.withOpacity(0.7))
          ]);

  Widget buildLoadingQueueBar(BuildContext context, Function()? retryCallback) {
    const albumImageSize = 70.0;

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
                    color: Color.alphaBlend(
                        Theme.of(context).brightness == Brightness.dark
                            ? IconTheme.of(context).color!.withOpacity(0.35)
                            : IconTheme.of(context).color!.withOpacity(0.5),
                        Theme.of(context).brightness == Brightness.dark
                            ? Colors.black
                            : Colors.white),
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
    const horizontalPadding = 8.0;
    const albumImageSize = 70.0;

    final audioHandler = GetIt.instance<MusicPlayerBackgroundTask>();

    Duration? playbackPosition;

    final currentTrackBaseItem = currentTrack.item.extras?["itemJson"] != null
        ? jellyfin_models.BaseItemDto.fromJson(
            currentTrack.item.extras!["itemJson"] as Map<String, dynamic>)
        : null;
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.only(left: 12.0, bottom: 12.0, right: 12.0),
        child: SimpleGestureDetector(
          onTap: () => Navigator.of(context).pushNamed(PlayerScreen.routeName),
          child: Dismissible(
            key: const Key("NowPlayingBarDismiss"),
            direction: FinampSettingsHelper.finampSettings.disableGesture
                ? DismissDirection.none
                : DismissDirection.down,
            confirmDismiss: (direction) async {
              if (direction == DismissDirection.down) {
                final queueService = GetIt.instance<QueueService>();
                await queueService.stopPlayback();
              }
              return false;
            },
            dismissThresholds: const {DismissDirection.down: 0.7},
            child: Container(
              clipBehavior: Clip.antiAlias,
              decoration: getShadow(context),
              child: Dismissible(
                key: const Key("NowPlayingBar"),
                direction: FinampSettingsHelper.finampSettings.disableGesture
                    ? DismissDirection.none
                    : DismissDirection.horizontal,
                confirmDismiss: (direction) async {
                  if (direction == DismissDirection.endToStart) {
                    audioHandler.skipToNext();
                  } else {
                    audioHandler.skipToPrevious(forceSkip: true);
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
                  //TODO use a PageView instead of a Dismissible, and only wrap dynamic items (not the buttons)
                  child: StreamBuilder<MediaState>(
                    stream: mediaStateStream
                        .where((event) => event.mediaItem != null),
                    initialData: MediaState(audioHandler.mediaItem.valueOrNull,
                        audioHandler.playbackState.value),
                    builder: (context, snapshot) {
                      final MediaState mediaState = snapshot.data!;
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
                              color: Color.alphaBlend(
                                  Theme.of(context).brightness ==
                                          Brightness.dark
                                      ? IconTheme.of(context)
                                          .color!
                                          .withOpacity(0.35)
                                      : IconTheme.of(context)
                                          .color!
                                          .withOpacity(0.5),
                                  Theme.of(context).brightness ==
                                          Brightness.dark
                                      ? Colors.black
                                      : Colors.white),
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
                                    Container(
                                        width: albumImageSize,
                                        height: albumImageSize,
                                        decoration: const ShapeDecoration(
                                          shape: Border(),
                                          color: Color.fromRGBO(0, 0, 0, 0.3),
                                        ),
                                        child: IconButton(
                                          onPressed: () {
                                            FeedbackHelper.feedback(
                                                FeedbackType.light);
                                            audioHandler.togglePlayback();
                                          },
                                          icon: mediaState.playbackState.playing
                                              ? const Icon(
                                                  TablerIcons.player_pause,
                                                  size: 32,
                                                )
                                              : const Icon(
                                                  TablerIcons.player_play,
                                                  size: 32,
                                                ),
                                          color: Colors.white,
                                        )),
                                  ],
                                ),
                                Expanded(
                                  child: Stack(
                                    children: [
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
                                                    MediaQuery.of(context).size;
                                                return Container(
                                                  // rather hacky workaround, using LayoutBuilder would be nice but I couldn't get it to work...
                                                  width: max(
                                                      0,
                                                      (screenSize.width -
                                                              2 *
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
                                                  height: 70.0,
                                                  decoration: ShapeDecoration(
                                                    color: IconTheme.of(context)
                                                        .color!
                                                        .withOpacity(0.75),
                                                    shape:
                                                        const RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.only(
                                                        topRight:
                                                            Radius.circular(12),
                                                        bottomRight:
                                                            Radius.circular(12),
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
                                                  Text(
                                                    currentTrack.item.title,
                                                    style: const TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        overflow: TextOverflow
                                                            .ellipsis),
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
                                                      Row(
                                                        children: [
                                                          StreamBuilder<
                                                                  Duration>(
                                                              stream:
                                                                  AudioService
                                                                      .position,
                                                              initialData:
                                                                  audioHandler
                                                                      .playbackState
                                                                      .value
                                                                      .position,
                                                              builder: (context,
                                                                  snapshot) {
                                                                final TextStyle
                                                                    style =
                                                                    TextStyle(
                                                                  color: Colors
                                                                      .white
                                                                      .withOpacity(
                                                                          0.8),
                                                                  fontSize: 14,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w400,
                                                                );
                                                                if (snapshot
                                                                    .hasData) {
                                                                  playbackPosition =
                                                                      snapshot
                                                                          .data;
                                                                  return Text(
                                                                    // '0:00',
                                                                    playbackPosition!.inHours >=
                                                                            1.0
                                                                        ? "${playbackPosition?.inHours.toString()}:${((playbackPosition?.inMinutes ?? 0) % 60).toString().padLeft(2, '0')}:${((playbackPosition?.inSeconds ?? 0) % 60).toString().padLeft(2, '0')}"
                                                                        : "${playbackPosition?.inMinutes.toString()}:${((playbackPosition?.inSeconds ?? 0) % 60).toString().padLeft(2, '0')}",
                                                                    style:
                                                                        style,
                                                                  );
                                                                } else {
                                                                  return Text(
                                                                    "0:00",
                                                                    style:
                                                                        style,
                                                                  );
                                                                }
                                                              }),
                                                          const SizedBox(
                                                              width: 2),
                                                          Text(
                                                            '/',
                                                            style: TextStyle(
                                                              color: Colors
                                                                  .white
                                                                  .withOpacity(
                                                                      0.8),
                                                              fontSize: 14,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w400,
                                                            ),
                                                          ),
                                                          const SizedBox(
                                                              width: 2),
                                                          Text(
                                                            // '3:44',
                                                            (mediaState.mediaItem?.duration
                                                                            ?.inHours ??
                                                                        0.0) >=
                                                                    1.0
                                                                ? "${mediaState.mediaItem?.duration?.inHours.toString()}:${((mediaState.mediaItem?.duration?.inMinutes ?? 0) % 60).toString().padLeft(2, '0')}:${((mediaState.mediaItem?.duration?.inSeconds ?? 0) % 60).toString().padLeft(2, '0')}"
                                                                : "${mediaState.mediaItem?.duration?.inMinutes.toString()}:${((mediaState.mediaItem?.duration?.inSeconds ?? 0) % 60).toString().padLeft(2, '0')}",
                                                            style: TextStyle(
                                                              color: Colors
                                                                  .white
                                                                  .withOpacity(
                                                                      0.8),
                                                              fontSize: 14,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w400,
                                                            ),
                                                          ),
                                                        ],
                                                      )
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
                                                child: FavoriteButton(
                                                  item: currentTrackBaseItem,
                                                  color: Colors.white,
                                                  onToggle: (isFavorite) {
                                                    currentTrackBaseItem!
                                                            .userData!
                                                            .isFavorite =
                                                        isFavorite;
                                                    mediaState.mediaItem?.extras![
                                                            "itemJson"] =
                                                        currentTrackBaseItem
                                                            .toJson();
                                                  },
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
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final queueService = GetIt.instance<QueueService>();
    var imageTheme =
        ref.watch(playerScreenThemeProvider(Theme.of(context).brightness));

    ref.listen(currentTrackMetadataProvider,
        (metadataOrNull, metadata) {}); // keep provider alive

    return Hero(
        tag: "nowplaying",
        createRectTween: (from, to) => RectTween(begin: from, end: from),
        child: AnimatedTheme(
          duration: getThemeTransitionDuration(context),
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
        ));
  }
}
