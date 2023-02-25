import 'package:flutter/material.dart';

extension ToContrast on Color {
// Contrast calculations
  double contrastRatio(num a, num b) {
    final ratio = (a + 0.05) / (b + 0.05);
    return ratio >= 1 ? ratio : 1 / ratio;
  }

  Color atContrast(double targetContrast, Color background, bool lighter) {
    final inc = lighter ? 0.01 : -0.01;

    HSLColor hslColor = HSLColor.fromColor(this);

    final backgroundLuminance = background.computeLuminance();

    while (contrastRatio(
            hslColor.toColor().computeLuminance(), backgroundLuminance) <
        targetContrast) {
      final newLightness = hslColor.lightness + inc;

      if (newLightness < 0 || newLightness > 1) break;

      hslColor = hslColor.withLightness(hslColor.lightness + inc);
    }

    return hslColor.toColor();
  }
}
