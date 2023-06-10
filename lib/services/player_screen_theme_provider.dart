import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final playerScreenThemeProvider =
    StateProvider.autoDispose<ColorScheme?>((_) => null);
