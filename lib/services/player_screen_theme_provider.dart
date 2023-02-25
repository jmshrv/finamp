import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Provider to handle setting the theme in PlayerScreen.
final playerScreenThemeProvider =
    StateProvider.autoDispose<Color?>((_) => null);
