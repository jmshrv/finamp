import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:hive/hive.dart';
import 'package:logging/logging.dart';

import '../models/finamp_models.dart';
import '../services/finamp_settings_helper.dart';
import '../services/audio_service_helper.dart';
import '../services/finamp_user_helper.dart';
import '../components/MusicScreen/music_screen_tab_view.dart';
import '../components/MusicScreen/music_screen_drawer.dart';
import '../components/MusicScreen/sort_by_menu_button.dart';
import '../components/MusicScreen/sort_order_button.dart';
import '../components/now_playing_bar.dart';
import '../components/error_snackbar.dart';
import '../services/jellyfin_api_helper.dart';

class MusicScreen extends StatefulWidget {
  const MusicScreen({Key? key}) : super(key: key);

  static const routeName = "/music";

  @override
  State<MusicScreen> createState() => _MusicScreenState();
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
  final _finampUserHelper = GetIt.instance<FinampUserHelper>();
  final _jellyfinApiHelper = GetIt.instance<JellyfinApiHelper>();

  void _stopSearching() {
    setState(() {
      textEditingController.clear();
      searchQuery = null;
      isSearching = false;
    });
  }

  void _tabIndexCallback() {
    var tabKey = FinampSettingsHelper.finampSettings.showTabs.entries
        .where((element) => element.value)
        .elementAt(_tabController!.index)
        .key;
    if (_tabController != null &&
        (tabKey == TabContentType.songs ||
            tabKey == TabContentType.artists ||
            tabKey == TabContentType.albums)) {
      setState(() {
        _showShuffleFab = true;
      });
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

  FloatingActionButton? getFloatingActionButton() {
    var tabList = FinampSettingsHelper.finampSettings.showTabs.entries
        .where((element) => element.value)
        .map((e) => e.key)
        .toList();

    // Show the floating action button only on the albums, artists and songs tab.
    if (_tabController!.index == tabList.indexOf(TabContentType.songs)) {
      return FloatingActionButton(
        tooltip: "Shuffle all",
        onPressed: () async {
          try {
            await _audioServiceHelper
                .shuffleAll(FinampSettingsHelper.finampSettings.isFavourite);
          } catch (e) {
            errorSnackbar(e, context);
          }
        },
        child: const Icon(Icons.shuffle),
      );
    } else if (_tabController!.index ==
        tabList.indexOf(TabContentType.artists)) {
      return FloatingActionButton(
          tooltip: "Start Mix",
          onPressed: () async {
            try {
              if (_jellyfinApiHelper.selectedMixArtistsIds.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text(
                        "Long press on an artist to add or remove them from the mix builder before starting a mix")));
              } else {
                await _audioServiceHelper.startInstantMixForArtists(
                    _jellyfinApiHelper.selectedMixArtistsIds);
              }
            } catch (e) {
              errorSnackbar(e, context);
            }
          },
          child: const Icon(Icons.explore));
    } else if (_tabController!.index ==
        tabList.indexOf(TabContentType.albums)) {
      return FloatingActionButton(
          tooltip: "Start Mix",
          onPressed: () async {
            try {
              if (_jellyfinApiHelper.selectedMixAlbumIds.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text(
                        "Long press on an album to add or remove them from the mix builder before starting a mix")));
              } else {
                await _audioServiceHelper.startInstantMixForAlbums(
                    _jellyfinApiHelper.selectedMixAlbumIds);
              }
            } catch (e) {
              errorSnackbar(e, context);
            }
          },
          child: const Icon(Icons.explore));
    } else {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Box<FinampUser>>(
      valueListenable: _finampUserHelper.finampUsersListenable,
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
                      : Text(_finampUserHelper.currentUser?.currentView?.name ??
                          "Music"),
                  bottom: TabBar(
                    controller: _tabController,
                    tabs: finampSettings.showTabs.entries
                        .where((element) => element.value)
                        .map((e) => Tab(text: e.key.toString().toUpperCase()))
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
                                ? const Icon(Icons.favorite)
                                : const Icon(Icons.favorite_outline),
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
                floatingActionButton: getFloatingActionButton(),
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
                            view: _finampUserHelper.currentUser?.currentView,
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
