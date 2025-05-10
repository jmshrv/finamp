import 'package:flutter/material.dart';

class PlaybackActionPageIndicator extends StatelessWidget {
  const PlaybackActionPageIndicator({
    super.key,
    required this.pages,
    required this.pageController,
  });

  final Map<String, Widget> pages;
  final PageController pageController;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(
          pages.length,
          (index) => AnimatedBuilder(
            animation: pageController,
            builder: (context, child) {
              return GestureDetector(
                onTap: () {
                  pageController.animateToPage(
                    index,
                    duration: Duration(milliseconds: 750),
                    curve: Curves.easeOutCubic,
                  );
                },
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 4.0),
                  padding: const EdgeInsets.symmetric(
                      horizontal: 8.0, vertical: 4.0),
                  decoration: BoxDecoration(
                    color: pageController.page?.round() == index
                        ? Theme.of(context).colorScheme.primary
                        : Theme.of(context)
                            .colorScheme
                            .onSurface
                            .withOpacity(0.3),
                    borderRadius: BorderRadius.circular(9999.0),
                  ),
                  child: Text(
                    pages.keys.elementAt(index),
                    style: const TextStyle(
                      fontSize: 13.0,
                      color: Colors.white,
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
