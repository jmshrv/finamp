import 'dart:ui';

import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DisplayFeaturesHelper extends ChangeNotifier with WidgetsBindingObserver {
  BuildContext? _context;
  List<DisplayFeature> _features = [];
  bool _halfOpened = false;

  List<DisplayFeature> get features => _features;

  bool get halfOpened => _halfOpened;

  void attach(BuildContext context) {
    _context = context;
    WidgetsBinding.instance.addObserver(this);
    _update();
  }

  void detach() {
    WidgetsBinding.instance.removeObserver(this);
    _context = null;
  }

  void _update() {
    final context = _context;
    if (context != null) {
      _features = View.of(context).displayFeatures;
      _halfOpened = _features.any((d) =>
          (d.type == DisplayFeatureType.fold ||
              d.type == DisplayFeatureType.hinge) &&
          // Flip-style foldable, top == bottom, height == 0
          d.bounds.height == 0 &&
          d.state == DisplayFeatureState.postureHalfOpened);
      notifyListeners();
    }
  }

  @override
  void didChangeMetrics() => _update();
}

final displayFeaturesProvider = ChangeNotifierProvider<DisplayFeaturesHelper>(
  (ref) {
    final helper = DisplayFeaturesHelper();
    ref.onDispose(helper.detach);
    return helper;
  },
);
