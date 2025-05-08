import 'dart:ui';

import 'package:finamp/services/theme_mode_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_ce/hive.dart';

final displayFeaturesProvider = StateProvider<List<DisplayFeature>>((ref) {
  return [];
});

final brightnessProvider = StateProvider((ref) => Brightness.dark);

final halfOpenFoldableProvider = Provider((ref) => ref.watch(
    displayFeaturesProvider.select((x) => x.any((d) =>
        (d.type == DisplayFeatureType.fold ||
            d.type == DisplayFeatureType.hinge) &&
        // Flip-style foldable, top == bottom, height == 0
        d.bounds.height == 0 &&
        d.state == DisplayFeatureState.postureHalfOpened))));

class FinampProviderBuilder extends ConsumerStatefulWidget {
  const FinampProviderBuilder({required this.child, super.key});

  final Widget child;

  @override
  ConsumerState<FinampProviderBuilder> createState() =>
      _FinampProviderBuilderState();
}

class _FinampProviderBuilderState extends ConsumerState<FinampProviderBuilder>
    with WidgetsBindingObserver {
  bool _initialized = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    ThemeModeHelper.themeModeListener.addListener(didChangePlatformBrightness);
    Future.microtask(() {
      didChangePlatformBrightness();
      didChangeMetrics();
      setState(() {
        _initialized = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) =>
      _initialized ? widget.child : SizedBox.shrink();

  @override
  void didChangePlatformBrightness() {
    var theme = switch (Hive.box<ThemeMode>("ThemeMode").get("ThemeMode")) {
      null ||
      ThemeMode.system =>
        View.of(context).platformDispatcher.platformBrightness,
      ThemeMode.light => Brightness.light,
      ThemeMode.dark => Brightness.dark,
    };
    ref.read(brightnessProvider.notifier).state = theme;
  }

  @override
  void didChangeMetrics() {
    ref.read(displayFeaturesProvider.notifier).state =
        View.of(context).displayFeatures;
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    ThemeModeHelper.themeModeListener
        .removeListener(didChangePlatformBrightness);
    super.dispose();
  }
}
