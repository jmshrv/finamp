import 'package:flutter/material.dart';

import '../components/MusicScreen/MusicScreenTabView.dart';
import '../components/MusicScreen/MusicScreenDrawer.dart';
import '../components/NowPlayingBar.dart';

class MusicScreen extends StatefulWidget {
  const MusicScreen({Key key}) : super(key: key);

  @override
  _MusicScreenState createState() => _MusicScreenState();
}

// https://stackoverflow.com/questions/53399223/flutter-different-floating-action-button-in-tabbar
class _MusicScreenState extends State<MusicScreen>
    with SingleTickerProviderStateMixin {
  TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this, initialIndex: 0);
    _tabController.addListener(_handleTabIndex);
  }

  @override
  void dispose() {
    _tabController.removeListener(_handleTabIndex);
    _tabController.dispose();
    super.dispose();
  }

  void _handleTabIndex() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Music"),
        bottom: TabBar(
          tabs: [
            Tab(text: "SONGS"),
            Tab(text: "ALBUMS"),
            Tab(text: "PLAYLISTS"),
          ],
          controller: _tabController,
        ),
      ),
      floatingActionButton: _floatingActionButton(),
      // persistentFooterButtons: [NowPlayingBar()],
      bottomNavigationBar: NowPlayingBar(),
      drawer: MusicScreenDrawer(),
      body: TabBarView(
        children: [
          MusicScreenTabView(tabContentType: TabContentType.songs),
          MusicScreenTabView(tabContentType: TabContentType.albums),
          MusicScreenTabView(tabContentType: TabContentType.playlists)
        ],
        controller: _tabController,
      ),
    );
  }

  /// Sets the floating action button if the current tab is playlists (3nd tab)
  Widget _floatingActionButton() {
    if (_tabController.index == 2) {
      return FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: null,
      );
    } else {
      return null;
    }
  }
}
