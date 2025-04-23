import 'dart:async';
import 'dart:io';

import 'package:finamp/l10n/app_localizations.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
import 'package:logging/logging.dart';

import '../components/MusicScreen/artist_type_selection_row.dart';
import '../components/MusicScreen/music_screen_drawer.dart';
import '../components/MusicScreen/music_screen_tab_view.dart';
import '../components/MusicScreen/sort_by_menu_button.dart';
import '../components/MusicScreen/sort_order_button.dart';
import '../components/global_snackbar.dart';
import '../components/now_playing_bar.dart';
import '../models/finamp_models.dart';
import '../services/audio_service_helper.dart';
import '../services/finamp_settings_helper.dart';
import '../services/finamp_user_helper.dart';
import '../services/jellyfin_api_helper.dart';

final _musicScreenLogger = Logger("MusicScreen");

class MusicScreen extends ConsumerStatefulWidget {
  const MusicScreen({super.key});

  static const routeName = "/music";

  @override
  ConsumerState<MusicScreen> createState() => _MusicScreenState();
}

class _MusicScreenState extends ConsumerState<MusicScreen>
    with TickerProviderStateMixin {
  bool isSearching = false;
  bool _showShuffleFab = false;
  TextEditingController textEditingController = TextEditingController();
  String? searchQuery;
  final Map<TabContentType, MusicRefreshCallback> refreshMap = {};

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
        (tabKey == TabContentType.tracks ||
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
      initialIndex: ModalRoute.of(context)?.settings.arguments as int? ?? 0,
    );

    _tabController!.addListener(_tabIndexCallback);
  }

  @override
  void dispose() {
    _tabController?.dispose();
    super.dispose();
  }

  FloatingActionButton? getFloatingActionButton(
      List<TabContentType> sortedTabs) {
    // Show the floating action button only on the albums, artists, generes and tracks tab.
    if (_tabController!.index == sortedTabs.indexOf(TabContentType.tracks)) {
      return FloatingActionButton(
        tooltip: AppLocalizations.of(context)!.shuffleAll,
        onPressed: () async {
          try {
            await _audioServiceHelper.shuffleAll(
                ref.watch(finampSettingsProvider.onlyShowFavourites));
          } catch (e) {
            GlobalSnackbar.error(e);
          }
        },
        child: const Icon(Icons.shuffle),
      );
    } else if (_tabController!.index ==
        sortedTabs.indexOf(TabContentType.artists)) {
      return FloatingActionButton(
          tooltip: AppLocalizations.of(context)!.startMix,
          onPressed: () async {
            try {
              if (_jellyfinApiHelper.selectedMixArtists.isEmpty) {
                GlobalSnackbar.message((scaffold) =>
                    AppLocalizations.of(context)!.startMixNoTracksArtist);
              } else {
                await _audioServiceHelper.startInstantMixForArtists(
                    _jellyfinApiHelper.selectedMixArtists);
                _jellyfinApiHelper.clearArtistMixBuilderList();
              }
            } catch (e) {
              GlobalSnackbar.error(e);
            }
          },
          child: const Icon(Icons.explore));
    } else if (_tabController!.index ==
        sortedTabs.indexOf(TabContentType.albums)) {
      return FloatingActionButton(
          tooltip: AppLocalizations.of(context)!.startMix,
          onPressed: () async {
            try {
              if (_jellyfinApiHelper.selectedMixAlbums.isEmpty) {
                GlobalSnackbar.message((scaffold) =>
                    AppLocalizations.of(context)!.startMixNoTracksAlbum);
              } else {
                await _audioServiceHelper.startInstantMixForAlbums(
                    _jellyfinApiHelper.selectedMixAlbums);
              }
            } catch (e) {
              GlobalSnackbar.error(e);
            }
          },
          child: const Icon(Icons.explore));
    } else if (_tabController!.index ==
        sortedTabs.indexOf(TabContentType.genres)) {
      return FloatingActionButton(
          tooltip: AppLocalizations.of(context)!.startMix,
          onPressed: () async {
            try {
              if (_jellyfinApiHelper.selectedMixGenres.isEmpty) {
                GlobalSnackbar.message((scaffold) =>
                    AppLocalizations.of(context)!.startMixNoTracksGenre);
              } else {
                await _audioServiceHelper.startInstantMixForGenres(
                    _jellyfinApiHelper.selectedMixGenres);
              }
            } catch (e) {
              GlobalSnackbar.error(e);
            }
          },
          child: const Icon(Icons.explore));
    } else {
      return null;
    }
  }

  void refreshTab(TabContentType tabType) {
    refreshMap[tabType]?.call();
  }

  @override
  Widget build(BuildContext context) {
    if (_tabController == null) {
      _buildTabController();
    }
    ref.watch(FinampUserHelper.finampCurrentUserProvider);
    // Get the tabs from the user's tab order, and filter them to only
    // include enabled tabs
    final sortedTabs = ref
        .watch(finampSettingsProvider.tabOrder)
        .where((e) => ref.watch(finampSettingsProvider.showTabs)[e] ?? false);
    refreshMap[sortedTabs.elementAt(_tabController!.index)] =
        MusicRefreshCallback();

    if (sortedTabs.length != _tabController?.length) {
      _musicScreenLogger.info(
          "Rebuilding MusicScreen tab controller (${sortedTabs.length} != ${_tabController?.length})");
      _buildTabController();
    }

    Timer? debounce;

    return PopScope(
      canPop: !isSearching,
      onPopInvoked: (popped) {
        if (isSearching) {
          _stopSearching();
        }
      },
      child: Scaffold(
        extendBody: true,
        appBar: AppBar(
          titleSpacing: 0, // The surrounding iconButtons provide enough padding
          title: isSearching
              ? TextField(
                  controller: textEditingController,
                  autocorrect: false, // avoid autocorrect
                  enableSuggestions:
                      true, // keep suggestions which can be manually selected
                  autofocus: true,
                  keyboardType: TextInputType.text,
                  textInputAction: TextInputAction.search,
                  onChanged: (value) {
                    if (debounce?.isActive ?? false) debounce!.cancel();
                    debounce = Timer(const Duration(milliseconds: 400), () {
                      setState(() {
                        searchQuery = value;
                      });
                    });
                  },
                  onSubmitted: (value) => setState(() {
                    searchQuery = value;
                  }),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText:
                        MaterialLocalizations.of(context).searchFieldLabel,
                  ),
                )
              : Text(_finampUserHelper.currentUser?.currentView?.name ??
                  AppLocalizations.of(context)!.music),
          bottom: TabBar(
            controller: _tabController,
            tabs: sortedTabs
                .map((tabType) => Tab(
                        child: Container(
                      constraints: const BoxConstraints(minWidth: 50),
                      alignment: Alignment.center,
                      child: Text(
                        tabType.toLocalisedString(context).toUpperCase(),
                        // style: TextStyle(
                        //   fontSize: 12,
                        //   fontWeight: FontWeight.bold,
                        // ),
                      ),
                    )))
                .toList(),
            isScrollable: true,
            tabAlignment: TabAlignment.start,
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
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                    onPressed: () => setState(() {
                      textEditingController.clear();
                      searchQuery = null;
                    }),
                    tooltip: AppLocalizations.of(context)!.clear,
                  )
                ]
              : [
                  if (!Platform.isIOS && !Platform.isAndroid)
                    IconButton(
                        icon: const Icon(Icons.refresh),
                        onPressed: () {
                          refreshMap[
                              sortedTabs.elementAt(_tabController!.index)]!();
                        }),
                  SortOrderButton(
                    sortedTabs.elementAt(_tabController!.index),
                  ),
                  SortByMenuButton(
                    sortedTabs.elementAt(_tabController!.index),
                  ),
                  if (ref.watch(finampSettingsProvider.isOffline))
                    IconButton(
                      icon: ref.watch(
                              finampSettingsProvider.onlyShowFullyDownloaded)
                          ? const Icon(Icons.download)
                          : const Icon(Icons.download_outlined),
                      onPressed: ref.watch(finampSettingsProvider.isOffline)
                          ? () => FinampSetters.setOnlyShowFullyDownloaded(
                              !ref.watch(finampSettingsProvider
                                  .onlyShowFullyDownloaded))
                          : null,
                      tooltip:
                          AppLocalizations.of(context)!.onlyShowFullyDownloaded,
                    ),
                  if (!ref.watch(finampSettingsProvider.isOffline) ||
                      ref.watch(finampSettingsProvider.trackOfflineFavorites))
                    IconButton(
                      icon: ref.watch(finampSettingsProvider.onlyShowFavourites)
                          ? const Icon(Icons.favorite)
                          : const Icon(Icons.favorite_outline),
                      onPressed: () => FinampSetters.setOnlyShowFavourites(!ref
                          .watch(finampSettingsProvider.onlyShowFavourites)),
                      tooltip: AppLocalizations.of(context)!.favourites,
                    ),
                  IconButton(
                    icon: const Icon(Icons.search),
                    onPressed: () => setState(() {
                      isSearching = true;
                    }),
                    tooltip: MaterialLocalizations.of(context).searchFieldLabel,
                  ),
                ],
        ),
        bottomNavigationBar: const NowPlayingBar(),
        drawer: const MusicScreenDrawer(),
        floatingActionButton: Padding(
          padding: EdgeInsets.only(
              right: ref.watch(finampSettingsProvider.showFastScroller)
                  ? 24.0
                  : 8.0),
          child: getFloatingActionButton(sortedTabs.toList()),
        ),
        body: Builder(builder: (context) {
          final child = TabBarView(
            controller: _tabController,
            physics: ref.watch(finampSettingsProvider.disableGesture)
                ? const NeverScrollableScrollPhysics()
                : const AlwaysScrollableScrollPhysics(),
            dragStartBehavior: DragStartBehavior.down,
            children: sortedTabs.map((tabType) {
              return Column(
                children: [
                  buildArtistTypeSelectionRow(
                      context,
                      tabType,
                      ref.watch(finampSettingsProvider.artistListType),
                      refreshTab),
                  Expanded(
                    child: MusicScreenTabView(
                      tabContentType: tabType,
                      searchTerm: searchQuery,
                      view: _finampUserHelper.currentUser?.currentView,
                      refresh: refreshMap[tabType],
                    ),
                  ),
                ],
              );
            }).toList(),
          );

          if (Platform.isAndroid) {
            return TransparentRightSwipeDetector(
              action: () {
                if (_tabController?.index == 0 &&
                    !ref.watch(finampSettingsProvider.disableGesture)) {
                  Scaffold.of(context).openDrawer();
                }
              },
              child: child,
            );
          }

          return child;
        }),
      ),
    );
  }
}

// This class causes a horizontal swipe to be processed even when another widget
// wins the GestureArena.
class _TransparentSwipeRecognizer extends HorizontalDragGestureRecognizer {
  _TransparentSwipeRecognizer({
    super.debugOwner,
    super.supportedDevices,
  });

  @override
  void rejectGesture(int pointer) {
    acceptGesture(pointer);
  }
}

// This class is a cut-down version of SimplifiedGestureDetector/GestureDetector,
// but using _TransparentSwipeRecognizer instead of HorizontalDragGestureRecognizer
// to allow both it and the TabBarView to process the same gestures.
class TransparentRightSwipeDetector extends StatefulWidget {
  const TransparentRightSwipeDetector(
      {super.key, this.child, required this.action});

  final Widget? child;

  final void Function() action;

  @override
  State<TransparentRightSwipeDetector> createState() =>
      _TransparentRightSwipeDetectorState();
}

class _TransparentRightSwipeDetectorState
    extends State<TransparentRightSwipeDetector> {
  @override
  Widget build(BuildContext context) {
    /// Device types that scrollables should accept drag gestures from by default.
    const Set<PointerDeviceKind> supportedDevices = <PointerDeviceKind>{
      PointerDeviceKind.touch,
      PointerDeviceKind.stylus,
      PointerDeviceKind.invertedStylus,
      PointerDeviceKind.trackpad,
      // The VoiceAccess sends pointer events with unknown type when scrolling
      // scrollables.
      PointerDeviceKind.unknown,
    };
    final Map<Type, GestureRecognizerFactory> gestures =
        <Type, GestureRecognizerFactory>{};
    gestures[_TransparentSwipeRecognizer] =
        GestureRecognizerFactoryWithHandlers<_TransparentSwipeRecognizer>(
      () => _TransparentSwipeRecognizer(
          debugOwner: this, supportedDevices: supportedDevices),
      (_TransparentSwipeRecognizer instance) {
        instance
          ..onStart = _onHorizontalDragStart
          ..onUpdate = _onHorizontalDragUpdate
          ..onEnd = _onHorizontalDragEnd
          ..supportedDevices = supportedDevices;
      },
    );

    return RawGestureDetector(
      gestures: gestures,
      child: widget.child,
    );
  }

  Offset? _initialSwipeOffset;

  void _onHorizontalDragStart(DragStartDetails details) {
    _initialSwipeOffset = details.globalPosition;
  }

  void _onHorizontalDragUpdate(DragUpdateDetails details) {
    final finalOffset = details.globalPosition;
    final initialOffset = _initialSwipeOffset;
    if (initialOffset != null) {
      final offsetDifference = initialOffset.dx - finalOffset.dx;
      if (offsetDifference < -100.0) {
        _initialSwipeOffset = null;
        widget.action();
      }
    }
  }

  void _onHorizontalDragEnd(DragEndDetails details) {
    _initialSwipeOffset = null;
  }
}
