import 'dart:async';

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
  Completer<ColorScheme?> completer = Completer();
  ImageStream stream =
      image.resolve(const ImageConfiguration(devicePixelRatio: 1.0));
  ImageStreamListener? listener;

  listener = ImageStreamListener((image, synchronousCall) async {
    stream.removeListener(listener!);
    // Use fromImage instead of fromImageProvider to better handle error case
    final PaletteGenerator palette =
        await PaletteGenerator.fromImage(image.image);

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

    completer.complete(ColorScheme.fromSwatch(
      primarySwatch: generateMaterialColor(accent),
      accentColor: accent,
      brightness: brightness,
    ));
  }, onError: (_, __) {
    stream.removeListener(listener!);
    completer.complete(ColorScheme.fromSeed(
        seedColor: const Color.fromARGB(255, 0, 164, 220),
        brightness: brightness));
  });

  ref.onDispose(() {
    stream.removeListener(listener!);
  });

  stream.addListener(listener);
  return completer.future;
});
