import 'package:finamp/menus/components/playbackActions/playback_action_page_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final double playActionRowHeight = 92.0;

class PlaybackActionRow extends ConsumerWidget {
  const PlaybackActionRow({
    super.key,
    required this.controller,
    required this.playActionPages,
  });

  final PageController controller;
  final Map<String, Widget> playActionPages;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      verticalDirection: VerticalDirection.up,
      children: [
        SizedBox(
          height: playActionRowHeight,
          child: PageView(
            controller: controller,
            allowImplicitScrolling: true,
            scrollDirection: Axis.horizontal,
            children: playActionPages.values.toList(),
          ),
        ),
        PlaybackActionPageIndicator(
          pages: playActionPages,
          pageController: controller,
        ),
      ],
    );
  }
}
