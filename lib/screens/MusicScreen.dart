import 'package:flutter/material.dart';

import '../components/MusicScreen/AlbumView.dart';

class MusicScreen extends StatelessWidget {
  const MusicScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text("Music"),
          bottom: TabBar(tabs: [Tab(text: "Albums"), Tab(text: "Playlists")]),
        ),
        body: TabBarView(children: [AlbumView(), Text("Playlists")]),
      ),
    );
  }
}
