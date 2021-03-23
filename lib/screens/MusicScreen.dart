import 'package:flutter/material.dart';

import '../components/MusicScreen/MusicScreenTabView.dart';
import '../components/MusicScreen/MusicScreenDrawer.dart';
import '../components/NowPlayingBar.dart';

class MusicScreen extends StatelessWidget {
  const MusicScreen({Key key}) : super(key: key);

  static const List<Tab> tabs = [
    Tab(text: "ALBUMS"),
    Tab(text: "ARTISTS"),
    Tab(text: "PLAYLISTS"),
  ];

  static const List<MusicScreenTabView> tabViews = [
    MusicScreenTabView(tabContentType: TabContentType.albums),
    MusicScreenTabView(tabContentType: TabContentType.artists),
    MusicScreenTabView(tabContentType: TabContentType.playlists)
  ];

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: tabs.length,
      child: Scaffold(
        appBar: AppBar(
          title: Text("Music"),
          bottom: TabBar(
            tabs: tabs,
          ),
        ),
        // persistentFooterButtons: [NowPlayingBar()],
        bottomNavigationBar: NowPlayingBar(),
        drawer: MusicScreenDrawer(),
        body: TabBarView(
          children: tabViews,
        ),
      ),
    );
  }
}
