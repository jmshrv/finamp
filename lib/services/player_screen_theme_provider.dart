import 'package:finamp/at_contrast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:palette_generator/palette_generator.dart';

import '../generate_material_color.dart';
import 'current_album_image_provider.dart';

final playerScreenThemeProvider =
    FutureProvider.autoDispose.family<ColorScheme?,BuildContext>((ref,context) async {
        ImageProvider? image = ref.watch(currentAlbumImageProvider);

        if (image != null) {
            final theme = Theme.of(context);

            final palette =
                await PaletteGenerator.fromImageProvider(
                image,
                timeout: const Duration(milliseconds: 2000),
            );

            // Color accent = palette.dominantColor!.color;
            Color accent = palette.vibrantColor?.color ?? palette.dominantColor?.color ?? const Color.fromARGB(255, 0, 164, 220);

            final lighter = theme.brightness == Brightness.dark;

            final background = Color.alphaBlend(
                lighter
                    ? Colors.black.withOpacity(0.675)
                    : Colors.white.withOpacity(0.675),
                accent);

            accent = accent.atContrast(4.5, background, lighter);

            return ColorScheme.fromSwatch(
                    primarySwatch: generateMaterialColor(accent),
                    accentColor: accent,
                    brightness: theme.brightness,
                );
        }
    });
