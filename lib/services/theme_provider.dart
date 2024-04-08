import 'dart:async';
import 'dart:math';
import 'dart:ui';

import 'package:finamp/at_contrast.dart';
import 'package:flutter/material.dart' hide Image;
import 'package:flutter_riverpod/flutter_riverpod.dart';
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

final AutoDisposeProviderFamily<ColorScheme, Brightness>
    playerScreenThemeProvider =
    Provider.family.autoDispose<ColorScheme, Brightness>((ref, brightness) {
  ColorScheme? scheme =
      ref.watch(playerScreenThemeNullableProvider(brightness)).value;
  if (scheme == null) {
    return getGreyTheme(brightness);
  } else {
    return scheme;
  }
});

final AutoDisposeFutureProviderFamily<ColorScheme?, Brightness>
    playerScreenThemeNullableProvider = FutureProvider.family
        .autoDispose<ColorScheme?, Brightness>((ref, brightness) async {
  ImageProvider? image = ref.watch(currentAlbumImageProvider);
  if (image == null) {
    return null;
  }

  themeProviderLogger.fine("Re-theming based on image $image");
  var themer = ThemeProvider(image, brightness);

  ref.onDispose(() {
    themer.dispose();
  });

  return themer.colorSchemeFuture;
});

class ThemeProvider {
  ThemeProvider(ImageProvider image, Brightness brightness,
      {bool useIsolate = true}) {
    ImageStream stream =
        image.resolve(const ImageConfiguration(devicePixelRatio: 1.0));
    ImageStreamListener? listener;

    listener = ImageStreamListener((image, synchronousCall) {
      stream.removeListener(listener!);
      _completer.complete(getColorSchemeForImage(image.image, brightness,
          useIsolate: useIsolate));
    }, onError: (_, __) {
      stream.removeListener(listener!);
      _completer.complete(getDefaultTheme(brightness));
    });

    _dispose = () {
      stream.removeListener(listener!);
    };

    stream.addListener(listener);
    _completer.future.then((value) {
      colorScheme = value;
    });
  }

  void Function()? _dispose;
  final Completer<ColorScheme> _completer = Completer();
  Future<ColorScheme> get colorSchemeFuture => _completer.future;
  ColorScheme? colorScheme;

  /// Disposes the imageStream, ending the attempt to load the theme.  This has no effect
  /// if the image has already loaded, as the stream will already have been disposed.
  void dispose() {
    if (_dispose != null) {
      _dispose!();
    }
  }
}

Future<ColorScheme> getColorSchemeForImage(Image image, Brightness brightness,
    {bool useIsolate = true}) async {
  // Use fromImage instead of fromImageProvider to better handle error case
  final PaletteGenerator palette =
      await PaletteGenerator.fromImage(image, useIsolate: useIsolate);

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
