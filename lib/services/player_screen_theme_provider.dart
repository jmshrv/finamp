import 'package:finamp/at_contrast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logging/logging.dart';
import 'package:palette_generator/palette_generator.dart';

import '../generate_material_color.dart';
import 'current_album_image_provider.dart';

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
  ImageProvider? image = await ref.watch(currentAlbumImageProvider.future);
  if (image == null) {
    return null;
  }
  Logger("colorProvider").fine("Re-theming based on image $image");

  final PaletteGenerator? palette = await PaletteGenerator.fromImageProvider(
    image,
    timeout: const Duration(seconds: 5),
  ).then((value) => value, onError: (_) => null);
  if (palette == null) {
    return ColorScheme.fromSeed(
        seedColor: const Color.fromARGB(255, 0, 164, 220),
        brightness: brightness);
  }
  // Color accent = palette.dominantColor!.color;
  Color accent = palette.vibrantColor?.color ??
      palette.dominantColor?.color ??
      const Color.fromARGB(255, 0, 164, 220);

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
  );
});
