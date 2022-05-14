import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:hive/hive.dart';
import 'package:logging/logging.dart';

import '../models/FinampModels.dart';
import '../services/FinampSettingsHelper.dart';
import '../services/AudioServiceHelper.dart';
import '../services/JellyfinApiData.dart';
import '../components/MusicScreen/MusicScreenTabView.dart';
import '../components/MusicScreen/MusicScreenDrawer.dart';
import '../components/MusicScreen/SortByMenuButton.dart';
import '../components/MusicScreen/SortOrderButton.dart';
import '../components/NowPlayingBar.dart';
import '../components/errorSnackbar.dart';

class MusicScreen extends StatefulWidget {
  const MusicScreen({Key? key}) : super(key: key);

  @override
  _MusicScreenState createState() => _MusicScreenState();
}

class _MusicScreenState extends State<MusicScreen>
    with TickerProviderStateMixin {
  bool isSearching = false;
  bool _showShuffleFab = false;
  TextEditingController textEditingController = TextEditingController();
  String? searchQuery;
  final _musicScreenLogger = Logger("MusicScreen");

  TabController? _tabController;

  final _audioServiceHelper = GetIt.instance<AudioServiceHelper>();
  final _jellyfinApiData = GetIt.instance<JellyfinApiData>();

  void _stopSearching() {
    setState(() {
      textEditingController.clear();
      searchQuery = null;
      isSearching = false;
    });
  }

  void _tabIndexCallback() {
    if (_tabController != null &&
        FinampSettingsHelper.finampSettings.showTabs.entries
                .where((element) => element.value)
                .elementAt(_tabController!.index)
                .key ==
            TabContentType.songs) {
      if (!_showShuffleFab) {
        setState(() {
          _showShuffleFab = true;
        });
      }
    } else {
      if (_showShuffleFab) {
        setState(() {
          _showShuffleFab = false;
        });
      }
    }
  }

  void _buildTabController() {
    _tabController?.removeListener(_tabIndexCallback);

    _tabController = TabController(
      length: FinampSettingsHelper.finampSettings.showTabs.entries
          .where((element) => element.value)
          .length,
      vsync: this,
    );

    _tabController!.addListener(_tabIndexCallback);
  }

  @override
  void initState() {
    super.initState();
    _buildTabController();
  }

  @override
  void dispose() {
    _tabController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Box<FinampUser>>(
      valueListenable: _jellyfinApiData.finampUsersListenable,
      builder: (context, value, _) {
        return ValueListenableBuilder<Box<FinampSettings>>(
          valueListenable: FinampSettingsHelper.finampSettingsListener,
          builder: (context, value, _) {
            final finampSettings = value.get("FinampSettings");

            if (finampSettings!.showTabs.entries
                    .where((element) => element.value)
                    .length !=
                _tabController?.length) {
              _musicScreenLogger.info(
                  "Rebuilding MusicScreen tab controller (${finampSettings.showTabs.entries.where((element) => element.value).length} != ${_tabController?.length})");
              _buildTabController();
            }

            return WillPopScope(
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
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            hintText: "Search",
                          ),
                        )
                      : Text(_jellyfinApiData.currentUser?.currentView?.name ??
                          "Music"),
                  bottom: TabBar(
                    controller: _tabController,
                    tabs: finampSettings.showTabs.entries
                        .where((element) => element.value)
                        .map((e) =>
                            Tab(text: e.key.toString().toUpperCase()))
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
                            tooltip: "Clear",
                          )
                        ]
                      : [
                          const SortOrderButton(),
                          const SortByMenuButton(),
                          IconButton(
                            icon: finampSettings.isFavourite
                                ? const Icon(Icons.star)
                                : const Icon(Icons.star_outline),
                            onPressed: finampSettings.isOffline
                                ? null
                                : () => FinampSettingsHelper.setIsFavourite(
                                    !finampSettings.isFavourite),
                            tooltip: "Favourites",
                          ),
                          IconButton(
                            icon: const Icon(Icons.search),
                            onPressed: () => setState(() {
                              isSearching = true;
                            }),
                            tooltip: "Search",
                          ),
                        ],
                ),
                bottomNavigationBar: const NowPlayingBar(),
                drawer: const MusicScreenDrawer(),
                floatingActionButton: _tabController!.index ==
                        finampSettings.showTabs.entries
                            .where((element) => element.value)
                            .map((e) => e.key)
                            .toList()
                            .indexOf(TabContentType.songs)
                    ? FloatingActionButton(
                        child: const Icon(Icons.shuffle),
                        tooltip: "Shuffle all",
                        onPressed: () async {
                          try {
                            await _audioServiceHelper
                                .shuffleAll(finampSettings.isFavourite);
                          } catch (e) {
                            errorSnackbar(e, context);
                          }
                        },
                      )
                    : null,
                body: TabBarView(
                  controller: _tabController,
                  children: finampSettings.showTabs.entries
                      .where((element) => element.value)
                      .map((e) => MusicScreenTabView(
                            tabContentType: e.key,
                            searchTerm: searchQuery,
                            isFavourite: finampSettings.isFavourite,
                            sortBy: finampSettings.sortBy,
                            sortOrder: finampSettings.sortOrder,
                            view: _jellyfinApiData.currentUser?.currentView,
                          ))
                      .toList(),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
