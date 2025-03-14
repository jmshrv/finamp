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

part 'theme_provider.g.dart';

// Image imageProvider, associated blurHash, useIsolate
typedef ListenableImage = (ImageProvider?, String?, bool);

final themeProviderLogger = Logger("ThemeProvider");

final defaultThemeDark = ColorScheme.fromSeed(
    seedColor: const Color.fromARGB(255, 0, 164, 220),
    brightness: Brightness.dark);

final defaultThemeLight = ColorScheme.fromSeed(
    seedColor: const Color.fromARGB(255, 0, 164, 220),
    brightness: Brightness.light);

ColorScheme getDefaultTheme(Brightness brightness) =>
    brightness == Brightness.dark ? defaultThemeDark : defaultThemeLight;

// This provider gets updated to the latest brightness by a valuelistner in main.dart
final brightnessProvider = StateProvider((ref) => Brightness.dark);

final isPlayerThemedProvider = Provider((ref) => false);

final Provider<ThemeRequest> localThemeRequestProvider = Provider((ref) {
  throw "no item set for this scope";
}, dependencies: const []);

// TODO override localImageProvider, remove playerScreenThemeProvider?
final Provider<ListenableImage> localImageProvider = Provider((ref) {
  var item = ref.watch(localThemeRequestProvider);
  return ref.watch(themeImageProvider(item));
}, dependencies: [localThemeRequestProvider]);

final ProviderFamily<ColorScheme, ThemeRequest> finampThemeProvider =
    ProviderFamily((ref, request) {
  var image = ref.watch(themeImageProvider(request));
  return ref.watch(finampThemeFromImageProvider(
      ThemeRequestFromImage(image.$1, request.useIsolate)));
});

final ProviderFamily<ListenableImage, ThemeRequest> themeImageProvider =
    ProviderFamily((ref, request) {
  var item = request.item;
  ImageProvider? image;
  String? cacheKey = request.item.blurHash ?? request.item.imageId;
  // Re-use an existing request if possible to hit the image cache
  if (albumRequestsCache.containsKey(cacheKey)) {
    if (albumRequestsCache[cacheKey] == null) {
      return (null, null, true);
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
  return (image, item.blurHash, request.useIsolate);
});

final Provider<ColorScheme> localThemeProvider = Provider((ref) {
  var image = ref.watch(localImageProvider);
  return ref.watch(
      finampThemeFromImageProvider(ThemeRequestFromImage(image.$1, image.$3)));
}, dependencies: [localImageProvider]);

class ThemeRequest {
  ThemeRequest(this.item, {this.useIsolate = true});

  final BaseItemDto item;

  final bool useIsolate;

  @override
  bool operator ==(Object other) {
    return other is ThemeRequest && other._imageCode == _imageCode;
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

@riverpod
class RawThemeAccent extends _$RawThemeAccent {
  @override
  Future<Color?> build(ThemeRequestFromImage request) {
    if (request.image == null) {
      return Future.value(null);
    }
    return _calculate(ref, request.image!, request.useIsolate);
  }

  static Future<Color?> _calculate(
      Ref ref, ImageProvider image, bool useIsolate) {
    ImageStream stream =
        image.resolve(const ImageConfiguration(devicePixelRatio: 1.0));
    ImageStreamListener? listener;
    Completer<Color?> completer = Completer();

    listener = ImageStreamListener((listenerImage, synchronousCall) async {
      stream.removeListener(listener!);

      // Use fromImage instead of fromImageProvider to better handle error case
      final PaletteGenerator palette;
      try {
        palette = await PaletteGenerator.fromImage(listenerImage.image,
            useIsolate: useIsolate);
      } finally {
        listenerImage.dispose();
      }

      Color accent = palette.vibrantColor?.color ??
          palette.dominantColor?.color ??
          const Color.fromARGB(255, 0, 164, 220);

      completer.complete(accent);
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
}

@riverpod
class FinampThemeFromImage extends _$FinampThemeFromImage {
  @override
  ColorScheme build(ThemeRequestFromImage request) {
    var brightness = ref.watch(brightnessProvider);
    var accent = ref.watch(rawThemeAccentProvider(request)).valueOrNull;
    if (accent == null) {
      return getDefaultTheme(brightness);
    }

    themeProviderLogger.finest("Accent color: $accent");

    return _calculate(accent, brightness);
  }

  static ColorScheme _calculate(Color rawAccent, Brightness brightness) {
    final lighter = brightness == Brightness.dark;

    final background = Color.alphaBlend(
        lighter
            ? Colors.black.withOpacity(0.675)
            : Colors.white.withOpacity(0.675),
        rawAccent);

    var accent = rawAccent.atContrast(4.5, background, lighter);
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
    if (_skipAllTransitions) {
      return const Duration(milliseconds: 0);
    }
    return ModalRoute.of(context)?.isCurrent ?? true
        ? const Duration(milliseconds: 1000)
        : const Duration(milliseconds: 0);
  }
}

class PlayerScreenTheme extends ConsumerWidget {
  final Widget child;
  final Duration? duration;

  const PlayerScreenTheme({super.key, required this.child, this.duration});

  @override
  Widget build(BuildContext context, ref) {
    return ProviderScope(
        overrides: [
          localImageProvider.overrideWith(
              (provider) => provider.watch(currentAlbumImageProvider)),
          isPlayerThemedProvider.overrideWithValue(true),
        ],
        child: Consumer(
            builder: (context, ref, child) {
              return AnimatedTheme(
                  duration: duration ?? getThemeTransitionDuration(context),
                  data: ThemeData(
                      colorScheme: ref.watch(localThemeProvider),
                      iconTheme: Theme.of(context).iconTheme.copyWith(
                            color: ref.watch(localThemeProvider).primary,
                          )),
                  child: child!);
            },
            child: child));
  }
}
