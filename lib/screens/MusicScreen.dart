import 'package:finamp/services/FinampSettingsHelper.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

import '../models/FinampModels.dart';
import '../services/FinampSettingsHelper.dart';
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
    return ValueListenableBuilder<Box<FinampSettings>>(
      valueListenable: FinampSettingsHelper.finampSettingsListener,
      builder: (context, value, child) {
        final finampSettings = value.get("FinampSettings");

        return DefaultTabController(
          length: finampSettings!.showTabs.entries
              .where((element) => element.value)
              .length,
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
                  tabs: finampSettings.showTabs.entries
                      .where((element) => element.value)
                      .map((e) =>
                          Tab(text: e.key.humanReadableName.toUpperCase()))
                      .toList(),
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
                children: finampSettings.showTabs.entries
                    .where((element) => element.value)
                    .map((e) => MusicScreenTabView(
                          tabContentType: e.key,
                          searchTerm: searchQuery,
                        ))
                    .toList(),
              ),
            ),
          ),
        );
      },
    );
  }
}
