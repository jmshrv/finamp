import 'package:flutter_riverpod/flutter_riverpod.dart';

class NavigationState {
  final int currentIndex;

  NavigationState(this.currentIndex);

  NavigationState copyWith({int? currentIndex}) {
    return NavigationState(currentIndex ?? this.currentIndex);
  }
}

class NavigationNotifier extends StateNotifier<NavigationState> {
  NavigationNotifier() : super(NavigationState(0));

  void setIndex(int index) {
    state = state.copyWith(currentIndex: index);
  }
}

final navigationProvider = StateNotifierProvider<NavigationNotifier, NavigationState>(
  (ref) => NavigationNotifier(),
);
