import 'dart:async';
import 'dart:typed_data';

import 'package:finamp/components/PlayerScreen/queue_source_helper.dart';
import 'package:finamp/components/animated_album_cover.dart';
import 'package:finamp/l10n/app_localizations.dart';
import 'package:finamp/models/finamp_models.dart';
import 'package:finamp/models/jellyfin_models.dart';
import 'package:finamp/services/animated_music_service.dart';
import 'package:finamp/services/feedback_helper.dart';
import 'package:finamp/services/finamp_settings_helper.dart';
import 'package:finamp/services/music_player_background_task.dart';
import 'package:finamp/services/queue_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
import 'package:simple_gesture_detector/simple_gesture_detector.dart';

import '../../services/current_album_image_provider.dart';
import '../../services/favorite_provider.dart';
import '../../menus/track_menu.dart';
import '../album_image.dart';

class PlayerScreenAlbumImage extends ConsumerStatefulWidget {
  const PlayerScreenAlbumImage({super.key});

  @override
  ConsumerState<PlayerScreenAlbumImage> createState() => _PlayerScreenAlbumImageState();
}

class _PlayerScreenAlbumImageState extends ConsumerState<PlayerScreenAlbumImage> {
  late final AnimatedMusicService _animatedMusicService;
  String? _animatedCoverUri;
  String? _lastTrackId;
  bool _isLoadingAnimatedCover = false;

  @override
  void initState() {
    super.initState();
    // Service is already registered in main.dart - just get the instance
    _animatedMusicService = GetIt.instance<AnimatedMusicService>();
  }

  Future<void> _loadAnimatedCover(String trackId) async {
    if (_isLoadingAnimatedCover || _lastTrackId == trackId) {
      return;
    }

    _isLoadingAnimatedCover = true;
    _lastTrackId = trackId;

    try {
      final animatedUri = await _animatedMusicService.getAnimatedCoverForTrack(BaseItemId(trackId));

      if (mounted && _lastTrackId == trackId) {
        setState(() {
          _animatedCoverUri = animatedUri;
        });
      }
    } catch (e) {
      // Silently fail and fallback to static image
      if (mounted) {
        setState(() {
          _animatedCoverUri = null;
        });
      }
    } finally {
      _isLoadingAnimatedCover = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final queueService = GetIt.instance<QueueService>();
    final audioService = GetIt.instance<MusicPlayerBackgroundTask>();
    return StreamBuilder<FinampQueueInfo?>(
      stream: queueService.getQueueStream(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          // show loading indicator
          return const Center(child: CircularProgressIndicator());
        }

        final queueInfo = snapshot.data!;
        final currentTrack = queueInfo.currentTrack;
        final currentTrackId = currentTrack?.baseItemId.raw;

        // Load animated cover if we have an track ID
        if (currentTrackId != null && currentTrackId != _lastTrackId) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            _loadAnimatedCover(currentTrackId);
          });
        }

        return Semantics(
          label: AppLocalizations.of(
            context,
          )!.playerAlbumArtworkTooltip(currentTrack?.item.title ?? AppLocalizations.of(context)!.unknownName),
          excludeSemantics: true, // replace child semantics with custom semantics
          container: true,
          child: GestureDetector(
            onSecondaryTapDown: (_) async {
              var queueItem = snapshot.data!.currentTrack;
              if (queueItem?.baseItem != null) {
                var inPlaylist = queueItemInPlaylist(queueItem);
                await showModalTrackMenu(
                  context: context,
                  item: queueItem!.baseItem!,
                  showPlaybackControls: true,
                  // show controls on player screen
                  parentItem: inPlaylist ? queueItem.source.item : null,
                  isInPlaylist: inPlaylist,
                );
              }
            },
            child: SimpleGestureDetector(
              //TODO replace with PageView, this is just a placeholder
              onTap: () {
                unawaited(audioService.togglePlayback());
                FeedbackHelper.feedback(FeedbackType.selection);
              },
              onDoubleTap: () {
                final currentTrack = queueService.getCurrentTrack();
                if (currentTrack?.baseItem != null && !FinampSettingsHelper.finampSettings.isOffline) {
                  ref.read(isFavoriteProvider(currentTrack!.baseItem).notifier).toggleFavorite();
                }
              },
              onHorizontalSwipe: (direction) {
                if (direction == SwipeDirection.left) {
                  if (!FinampSettingsHelper.finampSettings.disableGesture) {
                    queueService.skipByOffset(1);
                    FeedbackHelper.feedback(FeedbackType.selection);
                  }
                } else if (direction == SwipeDirection.right) {
                  if (!FinampSettingsHelper.finampSettings.disableGesture) {
                    queueService.skipByOffset(-1);
                    FeedbackHelper.feedback(FeedbackType.selection);
                  }
                }
              },
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final minPadding = ref.watch(finampSettingsProvider.playerScreenCoverMinimumPadding);
                  final horizontalPadding = constraints.maxWidth * (minPadding / 100.0);
                  final verticalPadding = constraints.maxHeight * (minPadding / 100.0);

                  return Padding(
                    padding: EdgeInsets.symmetric(horizontal: horizontalPadding, vertical: verticalPadding),
                    child: _buildCoverWidget(),
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildCoverWidget() {
    final borderRadius = BorderRadius.circular(8.0);
    final decoration = BoxDecoration(
      boxShadow: [BoxShadow(blurRadius: 24, offset: const Offset(0, 4), color: Colors.black.withOpacity(0.3))],
    );

    // Show animated cover if available
    if (_animatedCoverUri != null) {
      return Stack(
        children: [
          // Fallback static image
          AlbumImage(
            imageListenable: currentAlbumImageProvider,
            borderRadius: borderRadius,
            autoScale: false,
            decoration: decoration,
          ),
          // Animated cover overlay
          AnimatedAlbumCover(animatedCoverUri: _animatedCoverUri!, borderRadius: borderRadius),
        ],
      );
    }

    // Fallback to static image
    return AlbumImage(
      imageListenable: currentAlbumImageProvider,
      borderRadius: borderRadius,
      autoScale: false,
      decoration: decoration,
    );
  }
}
