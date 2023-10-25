import 'dart:math';

import 'package:audio_service/audio_service.dart';
import 'package:finamp/at_contrast.dart';
import 'package:finamp/components/favourite_button.dart';
import 'package:finamp/generate_material_color.dart';
import 'package:finamp/services/current_album_image_provider.dart';
import 'package:finamp/services/player_screen_theme_provider.dart';
import 'package:finamp/services/queue_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
import 'package:palette_generator/palette_generator.dart';
import 'package:simple_gesture_detector/simple_gesture_detector.dart';

import '../services/finamp_settings_helper.dart';
import '../services/media_state_stream.dart';
import 'album_image.dart';
import '../models/jellyfin_models.dart';
import '../services/process_artist.dart';
import '../services/music_player_background_task.dart';
import '../screens/player_screen.dart';
import 'PlayerScreen/progress_slider.dart';

class NowPlayingBar extends ConsumerWidget {
  const NowPlayingBar({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // BottomNavBar's default elevation is 8 (https://api.flutter.dev/flutter/material/BottomNavigationBar/elevation.html)
    final imageTheme = ref.watch(playerScreenThemeProvider);

    const elevation = 8.0;
    // final color = Theme.of(context).bottomNavigationBarTheme.backgroundColor;

    final audioHandler = GetIt.instance<MusicPlayerBackgroundTask>();
    final queueService = GetIt.instance<QueueService>();

    return AnimatedTheme(
      duration: const Duration(milliseconds: 500),
      data: ThemeData(
        fontFamily: "LexendDeca",
        colorScheme: imageTheme,
        brightness: Theme.of(context).brightness,
        iconTheme: Theme.of(context).iconTheme.copyWith(
          color: imageTheme?.primary,
        ),
      ),
      child: SimpleGestureDetector(
        onVerticalSwipe: (direction) {
          if (direction == SwipeDirection.up) {
            Navigator.of(context).pushNamed(PlayerScreen.routeName);
          }
        },
        child: StreamBuilder<MediaState>(
          stream: mediaStateStream,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final playing = snapshot.data!.playbackState.playing;
    
              // If we have a media item and the player hasn't finished, show
              // the now playing bar.
              if (snapshot.data!.mediaItem != null) {
                final item = BaseItemDto.fromJson(
                    snapshot.data!.mediaItem!.extras!["itemJson"]);
    
                return Material(
                  color: IconTheme.of(context).color!.withOpacity(0.1),
                  elevation: elevation,
                  child: SafeArea(
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child: Stack(
                        children: [
                          const ProgressSlider(
                            allowSeeking: false,
                            showBuffer: false,
                            showDuration: false,
                            showPlaceholder: false,
                          ),
                          Dismissible(
                            key: const Key("NowPlayingBar"),
                            direction: FinampSettingsHelper.finampSettings.disableGesture ? DismissDirection.none : DismissDirection.horizontal,
                            confirmDismiss: (direction) async {
                              if (direction == DismissDirection.endToStart) {
                                audioHandler.skipToNext();
                              } else {
                                audioHandler.skipToPrevious();
                              }
                              return false;
                            },
                            background: const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 16.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  AspectRatio(
                                    aspectRatio: 1,
                                    child: FittedBox(
                                      fit: BoxFit.fitHeight,
                                      child: Padding(
                                        padding:
                                            EdgeInsets.symmetric(vertical: 8.0),
                                        child: Icon(Icons.skip_previous),
                                      ),
                                    ),
                                  ),
                                  AspectRatio(
                                    aspectRatio: 1,
                                    child: FittedBox(
                                      fit: BoxFit.fitHeight,
                                      child: Padding(
                                        padding:
                                            EdgeInsets.symmetric(vertical: 8.0),
                                        child: Icon(Icons.skip_next),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            child: ListTile(
                              onTap: () => Navigator.of(context)
                                  .pushNamed(PlayerScreen.routeName),
                              leading: AlbumImage(item: item, 
                                // We need a post frame callback because otherwise this
                                // widget rebuilds on the same frame
                                imageProviderCallback: (imageProvider) =>
                                    WidgetsBinding.instance.addPostFrameCallback((_) async {
                                  // Don't do anything if the image from the callback is the same as
                                  // the current provider's image. This is probably needed because of
                                  // addPostFrameCallback shenanigans
                                  if (imageProvider != null &&
                                      ref.read(currentAlbumImageProvider.notifier).state ==
                                          imageProvider) {
                                    return;
                                  }

                                  ref.read(currentAlbumImageProvider.notifier).state = imageProvider;

                                  if (imageProvider != null) {
                                    final theme = Theme.of(context);

                                    final paletteGenerator =
                                        await PaletteGenerator.fromImageProvider(imageProvider);

                                    Color accent = paletteGenerator.dominantColor!.color;

                                    final lighter = theme.brightness == Brightness.dark;
                                    final background = Color.alphaBlend(
                                        lighter
                                            ? Colors.black.withOpacity(0.675)
                                            : Colors.white.withOpacity(0.675),
                                        accent);

                                    // increase saturation if the accent colour is too dark
                                    if (!lighter) {
                                      final hsv = HSVColor.fromColor(accent);
                                      final newSaturation = min(1.0, hsv.saturation * 2);
                                      final adjustedHsv = hsv.withSaturation(newSaturation);
                                      accent = adjustedHsv.toColor();
                                    }

                                    accent = accent.atContrast(3.5, background, lighter);

                                    ref.read(playerScreenThemeProvider.notifier).state =
                                        ColorScheme.fromSwatch(
                                      primarySwatch: generateMaterialColor(accent),
                                      accentColor: accent,
                                      brightness: theme.brightness,
                                    );

                                  }
                                }),
                              ),
                              title: Text(
                                snapshot.data!.mediaItem!.title,
                                softWrap: false,
                                maxLines: 1,
                                overflow: TextOverflow.fade,
                              ),
                              subtitle: Text(
                                processArtist(
                                    snapshot.data!.mediaItem!.artist, context),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                    FavoriteButton(
                                      item: item,
                                      onToggle: (isFavorite) {
                                        item.userData!.isFavorite = isFavorite;
                                        snapshot.data!.mediaItem?.extras!["itemJson"] = item.toJson();
                                      },
                                    ),
                                  playing
                                      ? IconButton(
                                          icon: const Icon(Icons.pause),
                                          onPressed: () => audioHandler.pause(),
                                        )
                                      : IconButton(
                                          icon: const Icon(Icons.play_arrow),
                                          onPressed: () => audioHandler.play(),
                                        ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              } else {
                return const SizedBox(
                  width: 0,
                  height: 0,
                );
              }
            } else {
              return const SizedBox(
                width: 0,
                height: 0,
              );
            }
          },
        ),
      ),
    );
  }
}
