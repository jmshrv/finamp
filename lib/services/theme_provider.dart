import 'dart:async';
import 'dart:math';
import 'dart:ui';

import 'package:finamp/at_contrast.dart';
import 'package:finamp/services/queue_service.dart';
import 'package:flutter/material.dart' hide Image;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
import 'package:logging/logging.dart';
import 'package:palette_generator/palette_generator.dart';

import 'current_album_image_provider.dart';

final themeProviderLogger = Logger("ThemeProvider");

final defaultThemeDark = ColorScheme.fromSeed(
    seedColor: const Color.fromARGB(255, 0, 164, 220),
    brightness: Brightness.dark);

final defaultThemeLight = ColorScheme.fromSeed(
    seedColor: const Color.fromARGB(255, 0, 164, 220),
    brightness: Brightness.light);

ColorScheme getDefaultTheme(Brightness brightness) =>
    brightness == Brightness.dark ? defaultThemeDark : defaultThemeLight;

final brightnessProvider = StateProvider((ref) => Brightness.dark);

final AutoDisposeProvider<ColorScheme> playerScreenThemeProvider =
    Provider.autoDispose<ColorScheme>((ref) {
  ColorScheme? scheme = ref.watch(playerScreenThemeNullableProvider).value;
  if (scheme == null) {
    return getGreyTheme(ref.watch(brightnessProvider));
  } else {
    return scheme;
  }
});

final Provider<FinampTheme?> playerScreenThemeDataProvider =
    Provider<FinampTheme?>((ref) {
  var (image, blurHash) = ref.watch(currentAlbumImageProvider);
  if (image == null) {
    return null;
  }

  themeProviderLogger.fine("Re-theming based on image $image");
  var themer = FinampTheme.fromImageDeferred(image, blurHash);

  ref.onDispose(() {
    themer.dispose();
  });

  return themer;
});

final AutoDisposeFutureProvider<ColorScheme?>
    playerScreenThemeNullableProvider =
    FutureProvider.autoDispose<ColorScheme?>((ref) async {
  var brightness = ref.watch(brightnessProvider);
  return ref.watch(playerScreenThemeDataProvider)?.calculate(brightness);
});

final Provider<FinampTheme> themeDataProvider = Provider((ref) {
  throw "No theme set";
}, dependencies: const []);

final Provider<(ImageProvider?, String?)> imageThemeProvider = Provider((ref) {
  var theme = ref.watch(themeDataProvider);
  return (theme.image, theme.blurHash);
}, dependencies: [themeDataProvider]);

final FutureProvider<ColorScheme> colorThemeNullableProvider =
    FutureProvider((ref) {
  var theme = ref.watch(themeDataProvider);
  var brightness = ref.watch(brightnessProvider);
  return theme.calculate(brightness);
}, dependencies: [themeDataProvider]);

final Provider<ColorScheme> colorThemeProvider = Provider((ref) {
  var brightness = ref.watch(brightnessProvider);
  var theme = ref.watch(themeDataProvider).colorScheme(brightness);
  if (theme != null) return theme;
  ref
      .watch(themeDataProvider)
      .calculate(brightness)
      .then((value) => ref.invalidateSelf());
  return getDefaultTheme(brightness);
}, dependencies: [themeDataProvider]);

class FinampTheme {
  FinampTheme.fromImageDeferred(ImageProvider this.image, this.blurHash);

  FinampTheme.fromImage(
      ImageProvider this.image, this.blurHash, Brightness brightness,
      {bool useIsolate = true}) {
    calculate(brightness, useIsolate: useIsolate);
  }

  Future<ColorScheme> calculate(Brightness brightness,
      {bool useIsolate = true}) {
    if (_results[brightness] != null) {
      return _results[brightness]!.colorSchemeFuture;
    }
    _results[brightness] = _ThemeProviderResults();
    if (image == null) {
      var scheme = getDefaultTheme(brightness);
      _results[brightness]!._completer.complete(scheme);
    } else {
      ImageStream stream =
          image!.resolve(const ImageConfiguration(devicePixelRatio: 1.0));
      ImageStreamListener? listener;

      listener = ImageStreamListener((image, synchronousCall) {
        stream.removeListener(listener!);
        _results[brightness]!._completer.complete(
            getColorSchemeForImage(image, brightness, useIsolate: useIsolate));
      }, onError: (e, stack) {
        stream.removeListener(listener!);
        _results[brightness]!._completer.complete(getDefaultTheme(brightness));
        themeProviderLogger.severe(e, e, stack);
      });

      _dispose = () {
        stream.removeListener(listener!);
      };

      stream.addListener(listener);
    }
    _results[brightness]!.colorSchemeFuture.then((value) {
      _results[brightness]!.colorScheme = value;
    });
    return _results[brightness]!.colorSchemeFuture;
  }

  FinampTheme.defaultTheme()
      : image = null,
        blurHash = null;

  void Function()? _dispose;
  final ImageProvider? image;
  final String? blurHash;
  final Map<Brightness, _ThemeProviderResults> _results = {};
  ColorScheme? colorScheme(Brightness brightness) =>
      _results[brightness]?.colorScheme;

  /// Disposes the imageStream, ending the attempt to load the theme.  This has no effect
  /// if the image has already loaded, as the stream will already have been disposed.
  void dispose() {
    if (_dispose != null) {
      _dispose!();
    }
    for (var result in _results.values) {
      if (!result._completer.isCompleted) {
        result._completer.completeError("disposed before completed");
      }
    }
  }
}

class _ThemeProviderResults {
  final Completer<ColorScheme> _completer = Completer();
  Future<ColorScheme> get colorSchemeFuture => _completer.future;
  ColorScheme? colorScheme;
}

Future<ColorScheme> getColorSchemeForImage(
    ImageInfo image, Brightness brightness,
    {bool useIsolate = true}) async {
  // Use fromImage instead of fromImageProvider to better handle error case
  final PaletteGenerator palette;
  try {
    palette =
        await PaletteGenerator.fromImage(image.image, useIsolate: useIsolate);
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
    return ModalRoute.of(context)!.isCurrent
        ? const Duration(milliseconds: 1000)
        : const Duration(milliseconds: 0);
  }
}
