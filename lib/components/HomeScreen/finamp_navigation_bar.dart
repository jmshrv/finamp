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
      margin: EdgeInsets.only(left: 16, right: 16, bottom: 16),
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: BottomNavigationBar(
        backgroundColor: Color.fromRGBO(40, 40, 40, 1),
        elevation: 0,
        useLegacyColorScheme: false,
        enableFeedback: true,
        landscapeLayout: BottomNavigationBarLandscapeLayout.centered,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(TablerIcons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(TablerIcons.search),
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: Icon(TablerIcons.books),
            label: 'Library',
          ),
        ],
        currentIndex: ref.watch(navigationProvider).currentIndex,
        onTap: (index) {
          ref.read(navigationProvider.notifier).setIndex(index);
          // Navigate to the corresponding screen based on the index
          switch (index) {
            case 0:
              Navigator.pushNamed(context, HomeScreen.routeName);
              break;
            case 1:
              Navigator.pushNamed(context, MusicScreen.routeName);
              break;
            case 2:
              Navigator.pushNamed(context, MusicScreen.routeName);
              break;
          }
        },
      ),
    );
  }
}
