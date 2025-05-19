import 'package:finamp/menus/components/playbackActions/playback_action_page_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final double playActionRowHeight = 96.0;

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
