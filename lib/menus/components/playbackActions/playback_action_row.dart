import 'package:flutter/cupertino.dart';
import 'package:finamp/menus/components/playbackActions/playback_action_page_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final double playActionRowHeight = 96.0;
final double playActionPageIndicatorHeight = 31.0;

class PlaybackActionRow extends ConsumerWidget {
  const PlaybackActionRow({
    super.key,
    required this.controller,
    required this.playbackActionPages,
  });

  final PageController controller;
  final Map<String, Widget> playbackActionPages;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      verticalDirection: VerticalDirection.up,
      children: [
        SizedBox(
          height: playActionRowHeight,
          child: PageView(
            controller: controller,
            // animation speed can't be changed directly, so we use a custom ScrollPhysics (source: https://stackoverflow.com/questions/65325496/flutter-pageview-how-to-make-faster-animations-on-swipe)
            physics: const FasterPageViewScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
            allowImplicitScrolling: true,
            scrollDirection: Axis.horizontal,
            children: playbackActionPages.values.toList(),
          ),
        ),
        PlaybackActionPageIndicator(
          pages: playbackActionPages,
          pageController: controller,
        ),
      ],
    );
  }
}

class FasterPageViewScrollPhysics extends ScrollPhysics {
  const FasterPageViewScrollPhysics({required ScrollPhysics super.parent});

  @override
  SpringDescription get spring {
    return const SpringDescription(
      mass: 40,
      stiffness: 100,
      damping: 1,
    );
  }
}
