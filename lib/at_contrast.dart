import 'package:flutter/material.dart';
import 'package:logging/logging.dart';

extension AtContrast on Color {
  static const double _tolerance = 0.05;

  static final _atContrastLogger = Logger("AtContrast");

// Contrast calculations
  double contrastRatio(num a, num b) {
    final ratio = (a + 0.05) / (b + 0.05);
    return ratio >= 1 ? ratio : 1 / ratio;
  }

  Color atContrast(double targetContrast, Color background, bool lighter) {
    final backgroundLuminance = background.computeLuminance();

    HSLColor hslColor = HSLColor.fromColor(this);

    double contrast = contrastRatio(
      computeLuminance(),
      backgroundLuminance,
    );

    double minLightness = 0.0;
    double maxLightness = 1.0;
    double diff = contrast - targetContrast;
    int steps = 0;

    while (diff.abs() > _tolerance) {
      steps++;
      print("$steps $diff");
      // If diff is negative, we need more contrast. Otherwise, we need less
      if (diff.isNegative) {
        minLightness = hslColor.lightness;

        final lightDiff = maxLightness - hslColor.lightness;

        hslColor = hslColor.withLightness(hslColor.lightness + lightDiff / 2);
      } else {
        maxLightness = hslColor.lightness;

        final lightDiff = hslColor.lightness - minLightness;

        hslColor = hslColor.withLightness(hslColor.lightness - lightDiff / 2);
      }

      contrast = contrastRatio(
        hslColor.toColor().computeLuminance(),
        backgroundLuminance,
      );

      diff = (contrast - targetContrast);
    }

    _atContrastLogger.info("Calculated contrast in $steps steps");

    return hslColor.toColor();
  }
}
