import 'package:finamp/services/FinampSettingsHelper.dart';
import 'package:flutter/material.dart';

import '../components/MusicScreen/MusicScreenTabView.dart';
import '../components/MusicScreen/MusicScreenDrawer.dart';
import '../components/NowPlayingBar.dart';

class MusicScreen extends StatefulWidget {
  const MusicScreen({Key? key}) : super(key: key);

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

    List<Tab> tabs = [
    ];

    List<MusicScreenTabView> tabViews = [
    ];

    if (FinampSettingsHelper.finampSettings.showTabs['Albums']) {
      tabs.add(Tab(text: 'ALBUMS'));
      tabViews.add(
        MusicScreenTabView(
          tabContentType: TabContentType.albums,
          searchTerm: searchQuery,
        ),
      );
    }
    if (FinampSettingsHelper.finampSettings.showTabs['Artists']) {
      tabs.add(Tab(text: 'ARTISTS'));
      tabViews.add(
        MusicScreenTabView(
          tabContentType: TabContentType.artists,
          searchTerm: searchQuery,
        ),
      );
    }
    if (FinampSettingsHelper.finampSettings.showTabs['Playlists']) {
      tabs.add(Tab(text: 'PLAYLISTS'));
      tabViews.add(
        MusicScreenTabView(
          tabContentType: TabContentType.playlists,
          searchTerm: searchQuery,
        ),
      );
    }
    if (FinampSettingsHelper.finampSettings.showTabs['Songs']) {
      tabs.add(Tab(text: 'SONGS'));
      tabViews.add(
        MusicScreenTabView(
          tabContentType: TabContentType.songs,
          searchTerm: searchQuery,
        ),
      );
    }

    return DefaultTabController(
      length: tabs.length,
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
            bottom: TabBar(
              tabs: tabs,
              isScrollable: true,
            ),
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
            children: tabViews
          ),
        ),
      ),
    );
  }
}
