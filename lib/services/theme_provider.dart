import 'dart:async';
import 'dart:math';

import 'package:finamp/at_contrast.dart';
import 'package:finamp/services/album_image_provider.dart';
import 'package:finamp/services/current_album_image_provider.dart';
import 'package:finamp/services/queue_service.dart';
import 'package:flutter/material.dart' hide Image;
import 'package:flutter_blurhash/flutter_blurhash.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
import 'package:logging/logging.dart';
import 'package:palette_generator/palette_generator.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../models/jellyfin_models.dart';
import 'widget_bindings_observer_provider.dart';

part 'theme_provider.g.dart';

class ThemeImage {
  ThemeImage(this.image, this.blurHash, {this.useIsolate = true});
  const ThemeImage.empty()
      : image = null,
        blurHash = null,
        useIsolate = true;
  // The background image to use
  final ImageProvider? image;
  // The blurHash associated with the image
  final String? blurHash;
  // Whether to use an isolate for slower but less laggy theme calculations
  final bool useIsolate;
}

final themeProviderLogger = Logger("ThemeProvider");

class PlayerScreenTheme extends StatelessWidget {
  final Widget child;
  final Duration? themeTransitionDuration;
  final ThemeData Function(ThemeData)? themeOverride;

  const PlayerScreenTheme(
      {super.key,
      required this.child,
      this.themeTransitionDuration,
      this.themeOverride});

  @override
  Widget build(BuildContext context) {
    return ProviderScope(
        overrides: [
          localImageProvider
              .overrideWith((ref) => ref.watch(currentAlbumImageProvider)),
          localThemeInfoProvider.overrideWith((ref) {
            var item = ref.watch(currentTrackProvider
                .select((queueItem) => queueItem.valueOrNull?.baseItem));
            if (item == null) {
              return null;
            }
            return ThemeInfo(item, largeThemeImage: true);
          })
        ],
        child: Consumer(
            builder: (context, ref, child) {
              var theme = ThemeData(
                  colorScheme: ref.watch(localThemeProvider),
                  iconTheme: Theme.of(context).iconTheme.copyWith(
                        color: ref.watch(localThemeProvider).primary,
                      ));
              if (themeOverride != null) {
                theme = themeOverride!(theme);
              }
              return AnimatedTheme(
                  duration: themeTransitionDuration ??
                      getThemeTransitionDuration(context),
                  data: theme,
                  child: child!);
            },
            child: child));
  }
}

class ItemTheme extends StatelessWidget {
  final Widget child;
  final BaseItemDto item;
  final Duration? themeTransitionDuration;
  final ThemeData Function(ThemeData)? themeOverride;

  const ItemTheme(
      {super.key,
      required this.item,
      required this.child,
      this.themeTransitionDuration,
      this.themeOverride});

  @override
  Widget build(BuildContext context) {
    return ProviderScope(
        overrides: [
          localThemeInfoProvider
              .overrideWithValue(ThemeInfo(item, useIsolate: false))
        ],
        child: Consumer(
            builder: (context, ref, child) {
              var theme = ThemeData(
                  colorScheme: ref.watch(localThemeProvider),
                  iconTheme: Theme.of(context).iconTheme.copyWith(
                        color: ref.watch(localThemeProvider).primary,
                      ));
              if (themeOverride != null) {
                theme = themeOverride!(theme);
              }
              return AnimatedTheme(
                  duration: themeTransitionDuration ??
                      getThemeTransitionDuration(context),
                  data: theme,
                  child: child!);
            },
            child: child));
  }
}

final Provider<ThemeInfo?> localThemeInfoProvider =
    Provider((ref) => null, dependencies: const []);

final Provider<ThemeImage> localImageProvider = Provider((ref) {
  var item = ref.watch(localThemeInfoProvider);
  if (item == null) {
    return ThemeImage.empty();
  }
  return ref.watch(themeImageProvider(item));
}, dependencies: [localThemeInfoProvider]);

final Provider<ColorScheme> localThemeProvider = Provider((ref) {
  var image = ref.watch(localImageProvider);
  return ref.watch(finampThemeFromImageProvider(
      ThemeRequestFromImage(image.image, image.useIsolate)));
}, dependencies: [localImageProvider]);

@riverpod
ColorScheme finampTheme(Ref ref, ThemeInfo request) {
  var image = ref.watch(themeImageProvider(request));
  return ref.watch(finampThemeFromImageProvider(
      ThemeRequestFromImage(image.image, request.useIsolate)));
}

@riverpod
ThemeImage themeImage(Ref ref, ThemeInfo request) {
  var item = request.item;
  ImageProvider? image;
  String? cacheKey = request.item.blurHash ?? request.item.imageId;
  // Re-use an existing request if possible to hit the image cache
  if (albumRequestsCache.containsKey(cacheKey)) {
    if (albumRequestsCache[cacheKey] == null) {
      return ThemeImage.empty();
    }
    image = ref.watch(albumImageProvider(albumRequestsCache[cacheKey]!));
  } else {
    // Use blurhash if possible, otherwise fetch 100x100
    if (item.blurHash != null) {
      image = BlurHashImage(item.blurHash!);
    } else if (item.imageId != null) {
      image = ref.watch(albumImageProvider(
          AlbumImageRequest(item: item, maxHeight: 100, maxWidth: 100)));
    }
  }
  return ThemeImage(image, item.blurHash, useIsolate: request.useIsolate);
}

@riverpod
class FinampThemeFromImage extends _$FinampThemeFromImage {
  @override
  ColorScheme build(ThemeRequestFromImage request) {
    var brightness = ref.watch(brightnessProvider);
    if (request.image == null) {
      return getGreyTheme(brightness);
    }
    Future.sync(() async {
      var image = await _fetchImage(request.image!);
      if (image == null) {
        return getDefaultTheme(brightness);
      }
      var scheme =
          await _getColorSchemeForImage(image, brightness, request.useIsolate);
      if (scheme == null) {
        return getDefaultTheme(brightness);
      }
      return scheme;
    }).then((value) => state = value);
    return getGreyTheme(brightness);
  }

  Future<ImageInfo?> _fetchImage(ImageProvider image) {
    ImageStream stream =
        image.resolve(const ImageConfiguration(devicePixelRatio: 1.0));
    ImageStreamListener? listener;
    Completer<ImageInfo?> completer = Completer();

    listener = ImageStreamListener((listenerImage, synchronousCall) async {
      stream.removeListener(listener!);

      completer.complete(listenerImage);
    }, onError: (e, stack) {
      stream.removeListener(listener!);
      completer.complete(null);
      themeProviderLogger.severe(e, e, stack);
    });

    ref.onDispose(() {
      stream.removeListener(listener!);
    });

    stream.addListener(listener);
    return completer.future;
  }

  Future<ColorScheme?> _getColorSchemeForImage(
      ImageInfo image, Brightness brightness, bool useIsolate) async {
    // Use fromImage instead of fromImageProvider to better handle error case
    final PaletteGenerator palette;
    try {
      palette =
          await PaletteGenerator.fromImage(image.image, useIsolate: useIsolate);
    } catch (e, stack) {
      themeProviderLogger.severe(e, e, stack);
      return null;
    } finally {
      image.dispose();
    }

    Color accent = palette.vibrantColor?.color ??
        palette.dominantColor?.color ??
        const Color.fromARGB(255, 0, 164, 220);

    themeProviderLogger.finest("Accent color: $accent");

    final lighter = brightness == Brightness.dark;

    final background = Color.alphaBlend(
        lighter
            ? Colors.black.withOpacity(0.675)
            : Colors.white.withOpacity(0.675),
        accent);

    accent = accent.atContrast(4.5, background, lighter);
    return ColorScheme.fromSwatch(
      primarySwatch: generateMaterialColor(accent),
      accentColor: accent,
      brightness: brightness,
      backgroundColor: background,
    );
  }
}

ColorScheme getGreyTheme(Brightness brightness) {
  Color accent = brightness == Brightness.dark
      ? const Color.fromARGB(255, 133, 133, 133)
      : const Color.fromARGB(255, 61, 61, 61);

  return ColorScheme.fromSwatch(
    primarySwatch: generateMaterialColor(accent),
    accentColor: accent,
    brightness: brightness,
  );
}

final defaultThemeDark = ColorScheme.fromSeed(
    seedColor: const Color.fromARGB(255, 0, 164, 220),
    brightness: Brightness.dark);

final defaultThemeLight = ColorScheme.fromSeed(
    seedColor: const Color.fromARGB(255, 0, 164, 220),
    brightness: Brightness.light);

ColorScheme getDefaultTheme(Brightness brightness) =>
    brightness == Brightness.dark ? defaultThemeDark : defaultThemeLight;

MaterialColor generateMaterialColor(Color color) {
  return MaterialColor(color.value, {
    50: tintColor(color, 0.9),
    100: tintColor(color, 0.8),
    200: tintColor(color, 0.6),
    300: tintColor(color, 0.4),
    400: tintColor(color, 0.2),
    500: color,
    600: shadeColor(color, 0.1),
    700: shadeColor(color, 0.2),
    800: shadeColor(color, 0.3),
    900: shadeColor(color, 0.4),
  });
}

int tintValue(int value, double factor) =>
    max(0, min((value + ((255 - value) * factor)).round(), 255));

Color tintColor(Color color, double factor) => Color.fromRGBO(
    tintValue(color.red, factor),
    tintValue(color.green, factor),
    tintValue(color.blue, factor),
    1);

int shadeValue(int value, double factor) =>
    max(0, min(value - (value * factor).round(), 255));

Color shadeColor(Color color, double factor) => Color.fromRGBO(
    shadeValue(color.red, factor),
    shadeValue(color.green, factor),
    shadeValue(color.blue, factor),
    1);

class ThemeInfo {
  ThemeInfo(this.item, {this.useIsolate = true, this.largeThemeImage = false});

  final BaseItemDto item;

  final bool useIsolate;

  final bool largeThemeImage;

  @override
  bool operator ==(Object other) {
    return other is ThemeInfo && other._imageCode == _imageCode;
  }

  @override
  int get hashCode => _imageCode.hashCode;

  String? get _imageCode => item.blurHash ?? item.imageId;
}

class ThemeRequestFromImage {
  ThemeRequestFromImage(this.image, this.useIsolate);

  final ImageProvider? image;

  final bool useIsolate;

  @override
  bool operator ==(Object other) {
    return other is ThemeRequestFromImage && other.image == image;
  }

  @override
  int get hashCode => image.hashCode;
}

_ThemeTransitionCalculator? _calculator;

Duration getThemeTransitionDuration(BuildContext context) =>
    (_calculator ??= _ThemeTransitionCalculator())
        .getThemeTransitionDuration(context);

/// Skip track change transition animations if app or route is in background
class _ThemeTransitionCalculator {
  _ThemeTransitionCalculator() {
    AppLifecycleListener(onShow: () {
      // Continue skipping until we get a foreground track change.
      _skipAllTransitions = true;
    }, onHide: () {
      _skipAllTransitions = true;
    });
    GetIt.instance<QueueService>().getCurrentTrackStream().listen((value) {
      _skipAllTransitions = false;
    });
  }

  bool _skipAllTransitions = false;

  Duration getThemeTransitionDuration(BuildContext context) {
    if (_skipAllTransitions || MediaQuery.of(context).disableAnimations) {
      return Duration.zero;
    }
    return context.mounted
        ? const Duration(milliseconds: 1000)
        : Duration.zero;
  }
}
