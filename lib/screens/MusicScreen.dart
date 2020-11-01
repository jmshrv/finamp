import 'package:flutter/material.dart';

import '../components/MusicScreen/AlbumView.dart';
import '../components/NowPlayingBar.dart';

class MusicScreen extends StatefulWidget {
  const MusicScreen({Key key}) : super(key: key);

  @override
  _MusicScreenState createState() => _MusicScreenState();
}

class _MusicScreenState extends State<MusicScreen>
    with SingleTickerProviderStateMixin {
  TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this, initialIndex: 0);
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
          tabs: [Tab(text: "Albums"), Tab(text: "Playlists")],
          controller: _tabController,
        ),
      ),
      floatingActionButton: _floatingActionButton(),
      persistentFooterButtons: [NowPlayingBar()],
      body: TabBarView(
        children: [AlbumView(), Text("Playlists")],
        controller: _tabController,
      ),
    );
  }

  /// Sets the floating action button if the current tab is playlists (2nd tab)
  Widget _floatingActionButton() {
    if (_tabController.index == 1) {
      return FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: null,
      );
    } else {
      return null;
    }
  }
}
