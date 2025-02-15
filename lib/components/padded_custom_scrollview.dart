import 'package:flutter/cupertino.dart';

/// A customScrollView that adds additional padding to the top/bottom of the list to
/// avoid system elements
class PaddedCustomScrollview extends CustomScrollView {
  const PaddedCustomScrollview({
    super.key,
    // Only vertical scrolling supported
    //super.scrollDirection,
    super.reverse,
    super.controller,
    super.primary,
    super.physics,
    super.scrollBehavior,
    super.shrinkWrap,
    super.center,
    super.anchor,
    super.cacheExtent,
    super.slivers,
    super.semanticChildCount,
    super.dragStartBehavior,
    super.keyboardDismissBehavior,
    super.restorationId,
    super.clipBehavior,
    super.hitTestBehavior,
    this.bottomPadding = 32.0,
  });

  /// Additional bottom padding to add in addition to system element padding
  final double bottomPadding;

  @override
  List<Widget> buildSlivers(BuildContext context) {
    final MediaQueryData? mediaQuery = MediaQuery.maybeOf(context);
    if (mediaQuery == null) {
      return slivers;
    }

    // Strip vertical MediaQuery padding because it is being added by this widget
    final MediaQueryData strippedMediaQuery = mediaQuery.copyWith(
      padding: mediaQuery.padding.copyWith(top: 0.0, bottom: 0.0),
    );

    return [
      SliverPadding(padding: EdgeInsets.only(top: mediaQuery.padding.top)),
      ...slivers.map((x) => MediaQuery(
            data: strippedMediaQuery,
            child: x,
          )),
      SliverPadding(
          padding: EdgeInsets.only(
              bottom: mediaQuery.padding.bottom + bottomPadding))
    ];
  }
}
