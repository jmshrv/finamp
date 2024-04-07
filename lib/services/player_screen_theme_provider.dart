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
    Color accent = brightness == Brightness.dark
        ? const Color.fromARGB(255, 133, 133, 133)
        : const Color.fromARGB(255, 61, 61, 61);

    return ColorScheme.fromSwatch(
      primarySwatch: generateMaterialColor(accent),
      accentColor: accent,
      brightness: brightness,
    );
  } else {
    return scheme;
  }
});

final AutoDisposeFutureProviderFamily<ColorScheme?, Brightness>
    playerScreenThemeNullableProvider = FutureProvider.family
        .autoDispose<ColorScheme?, Brightness>((ref, brightness) async {
  ImageProvider? image = ref.watch(currentAlbumImageProvider).value;
  if (image == null) {
    return null;
  }

  themeProviderLogger.fine("Re-theming based on image $image");
  Completer<ColorScheme?> completer = Completer();
  ImageStream stream =
      image.resolve(const ImageConfiguration(devicePixelRatio: 1.0));
  ImageStreamListener? listener;

  listener = ImageStreamListener((image, synchronousCall) {
    stream.removeListener(listener!);
    completer.complete(getColorSchemeForImage(image.image, brightness));
  }, onError: (_, __) {
    stream.removeListener(listener!);
    completer.complete(getDefaultTheme(brightness));
  });

  ref.onDispose(() {
    stream.removeListener(listener!);
  });

  stream.addListener(listener);
  return completer.future;
});

Future<ColorScheme> getColorSchemeForImage(
    Image image, Brightness brightness) async {
  // Use fromImage instead of fromImageProvider to better handle error case
  final PaletteGenerator palette = await PaletteGenerator.fromImage(image);

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
