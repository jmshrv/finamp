import 'package:finamp/screens/home_screen.dart';
import 'package:finamp/screens/music_screen.dart';
import 'package:finamp/services/navigation_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';

class FinampNavigationBar extends ConsumerWidget {
  const FinampNavigationBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      margin: EdgeInsets.only(left: 12, right: 12, bottom: 12, top: 0),
      clipBehavior: Clip.antiAlias,
      // height: 60,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).brightness == Brightness.dark
                ? Colors.black.withOpacity(0.75)
                : Colors.black.withOpacity(0.2),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      //!!! there is a great example for complex navigation with a navigation bar: https://api.flutter.dev/flutter/material/NavigationBar-class.html#material.NavigationBar.3
      child: NavigationBar(
        surfaceTintColor: Theme.of(context).colorScheme.primary,
        height: 40,
        indicatorColor: Colors.transparent,

        elevation: 0,
        labelPadding: EdgeInsets.only(top: 4),
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
        labelTextStyle: WidgetStateProperty.fromMap({
          WidgetState.selected: TextStyle(
            color: Theme.of(context).colorScheme.primary,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
          WidgetState.any: TextStyle(
            color: Theme.of(context)
                .textTheme
                .bodyMedium!
                .color!
                .withOpacity(0.75),
            fontSize: 14,
            fontWeight: FontWeight.w400,
          ),
        }),
        destinations: [
          Padding(
            padding: EdgeInsets.only(top: 18.0),
            child: NavigationDestination(
              icon: Icon(TablerIcons.home,
                  weight: 1.0,
                  color: Theme.of(context)
                      .textTheme
                      .bodyMedium!
                      .color!
                      .withOpacity(0.75)),
              selectedIcon: Icon(TablerIcons.home,
                  weight: 1.5, color: Theme.of(context).colorScheme.primary),
              label: 'Home',
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 18.0),
            child: NavigationDestination(
              icon: Icon(TablerIcons.search,
                  weight: 1.0,
                  color: Theme.of(context)
                      .textTheme
                      .bodyMedium!
                      .color!
                      .withOpacity(0.75)),
              selectedIcon: Icon(TablerIcons.search,
                  weight: 1.5, color: Theme.of(context).colorScheme.primary),
              label: 'Search',
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 18.0),
            child: NavigationDestination(
              icon: Icon(TablerIcons.books,
                  weight: 1.0,
                  color: Theme.of(context)
                      .textTheme
                      .bodyMedium!
                      .color!
                      .withOpacity(0.75)),
              selectedIcon: Icon(TablerIcons.books,
                  weight: 1.5, color: Theme.of(context).colorScheme.primary),
              label: 'Library',
            ),
          ),
          // SizedBox.shrink(),
          // SizedBox.shrink()
        ],
        selectedIndex: ref.watch(navigationProvider).currentIndex,
        onDestinationSelected: (index) {
          ref.read(navigationProvider.notifier).setIndex(index);
          // Navigate to the corresponding screen based on the index
          switch (index) {
            case 0:
              Navigator.pushReplacementNamed(context, HomeScreen.routeName);
              break;
            case 1:
              Navigator.pushReplacementNamed(context, MusicScreen.routeName);
              break;
            case 2:
              Navigator.pushReplacementNamed(context, MusicScreen.routeName);
              break;
          }
        },
      ),
    );
  }
}
