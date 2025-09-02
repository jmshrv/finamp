import 'package:flutter/material.dart';

class PlaybackActionPageIndicator extends StatelessWidget {
  const PlaybackActionPageIndicator({
    super.key,
    required this.pages,
    required this.pageController,
    this.compactLayout = false,
  });

  final Map<String, Widget> pages;
  final PageController pageController;
  final bool compactLayout;

  @override
  Widget build(BuildContext context) {
    final textColorSelected = compactLayout
        ? TextStyle(fontSize: 13.0, color: Theme.of(context).colorScheme.onPrimary)
        : TextStyle(fontSize: 13.0, color: Colors.white);
    final textColor = compactLayout
        ? TextStyle(fontSize: 13.0, color: Theme.of(context).colorScheme.onSurface)
        : TextStyle(fontSize: 13.0, color: Colors.white);
    final buttonColorSelected = compactLayout
        ? Theme.of(context).colorScheme.primary
        : Theme.of(context).colorScheme.primary.withOpacity(0.8);
    final buttonColor = compactLayout
        ? Theme.of(context).colorScheme.onSurface.withOpacity(0.1)
        : Theme.of(context).colorScheme.onSurface.withOpacity(0.3);

    return Padding(
      padding: compactLayout ? EdgeInsets.only(top: 4.0) : EdgeInsets.only(bottom: 4.0),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
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
                      duration: Duration(milliseconds: 500),
                      curve: Curves.easeOutCubic,
                    );
                  },
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 4.0),
                    padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                    decoration: BoxDecoration(
                      color: (pageController.page ?? pageController.initialPage).round() == index
                          ? buttonColorSelected
                          : buttonColor,
                      borderRadius: BorderRadius.circular(9999.0),
                    ),
                    child: Text(
                      pages.keys.elementAt(index),
                      style: (pageController.page ?? pageController.initialPage).round() == index
                          ? textColorSelected
                          : textColor,
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
