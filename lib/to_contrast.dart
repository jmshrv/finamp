import 'dart:math' as math;

import 'package:flutter/material.dart';

extension ToContrast on Color {
  static double _linearizeColorComponent(double component) {
    if (component <= 0.03928) return component / 12.92;
    return math.pow((component + 0.055) / 1.055, 2.4) as double;
  }

  static double _delinearizeColorComponent(double component) {
    if (component <= 0.0031308) return (12.92 * component);
    return math.pow(component * 1.055, 1 / 2.4) - 0.055;
  }

  Color atContrast(double targetContrast, Color background) {
    final selfLuminance = computeLuminance();
    final backgroundLuminance = background.computeLuminance();

    final currentContrast = selfLuminance > backgroundLuminance
        ? (selfLuminance + 0.05) / (backgroundLuminance + 0.05)
        : (backgroundLuminance + 0.05) / (selfLuminance + 0.05);

    if (currentContrast == targetContrast) {
      return Color(value);
    }

    final desiredSelfLuminance = selfLuminance > backgroundLuminance
        ? currentContrast * (backgroundLuminance + 0.05) - 0.05
        : (selfLuminance + 0.05 / currentContrast) - 0.05;

    final selfLinearRed = _linearizeColorComponent(red / 0xFF);
    final selfLinearGreen = _linearizeColorComponent(green / 0xFF);
    final selfLinearBlue = _linearizeColorComponent(blue / 0xFF);

    final newLinearRed = (desiredSelfLuminance -
            0.7152 * selfLinearGreen -
            0.0722 * selfLinearBlue) /
        0.2126;
    final newLinearGreen = (desiredSelfLuminance -
            0.2126 * selfLinearRed -
            0.0722 * selfLinearBlue) /
        0.7152;
    final newLinearBlue = (desiredSelfLuminance -
            0.2126 * selfLinearRed -
            0.7152 * selfLinearGreen) /
        0.0722;

    final newRed = _delinearizeColorComponent(newLinearRed) * 0xFF;
    final newGreen = _delinearizeColorComponent(newLinearGreen) * 0xFF;
    final newBlue = _delinearizeColorComponent(newLinearBlue) * 0xFF;

    final newLuminance =
        Color.fromARGB(alpha, newRed.ceil(), newGreen.ceil(), newBlue.ceil())
            .computeLuminance();
    final newContrast = newLuminance > backgroundLuminance
        ? (newLuminance + 0.05) / (backgroundLuminance + 0.05)
        : (backgroundLuminance + 0.05) / (newLuminance + 0.05);

    return Color.fromARGB(
        alpha, newRed.ceil(), newGreen.ceil(), newBlue.ceil());
  }
}
