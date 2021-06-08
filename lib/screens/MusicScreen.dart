import 'package:flutter/material.dart';

import '../components/MusicScreen/MusicScreenTabView.dart';
import '../components/MusicScreen/MusicScreenDrawer.dart';
import '../components/NowPlayingBar.dart';

class MusicScreen extends StatefulWidget {
  const MusicScreen({Key? key}) : super(key: key);

  static const List<Tab> tabs = [
    Tab(text: "ALBUMS"),
    Tab(text: "ARTISTS"),
    Tab(text: "PLAYLISTS"),
  ];

  @override
  _MusicScreenState createState() => _MusicScreenState();
}

class _MusicScreenState extends State<MusicScreen> {
  bool isSearching = false;
  TextEditingController textEditingController = TextEditingController();
  String? searchQuery;

  void _stopSearching() {
    setState(() {
      textEditingController.clear();
      searchQuery = null;
      isSearching = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: MusicScreen.tabs.length,
      child: WillPopScope(
        onWillPop: () async {
          if (isSearching) {
            _stopSearching();
            return false;
          } else {
            return true;
          }
        },
        child: Scaffold(
          appBar: AppBar(
            title: isSearching
                ? TextField(
                    controller: textEditingController,
                    autofocus: true,
                    onChanged: (value) => setState(() {
                      searchQuery = value;
                    }),
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: "Search",
                    ),
                  )
                : Text("Music"),
            bottom: TabBar(tabs: MusicScreen.tabs),
            leading: isSearching
                ? BackButton(
                    onPressed: () => _stopSearching(),
                  )
                : null,
            actions: isSearching
                ? [
                    IconButton(
                      icon: Icon(
                        Icons.cancel,
                        color: Theme.of(context).iconTheme.color,
                      ),
                      onPressed: () => setState(() {
                        textEditingController.clear();
                        searchQuery = null;
                      }),
                    )
                  ]
                : [
                    IconButton(
                      icon: Icon(Icons.search),
                      onPressed: () => setState(() {
                        isSearching = true;
                      }),
                    ),
                  ],
          ),
          bottomNavigationBar: NowPlayingBar(),
          drawer: MusicScreenDrawer(),
          body: TabBarView(
            children: [
              MusicScreenTabView(
                tabContentType: TabContentType.albums,
                searchTerm: searchQuery,
              ),
              MusicScreenTabView(
                tabContentType: TabContentType.artists,
                searchTerm: searchQuery,
              ),
              MusicScreenTabView(
                tabContentType: TabContentType.playlists,
                searchTerm: searchQuery,
              )
            ],
          ),
        ),
      ),
    );
  }
}
