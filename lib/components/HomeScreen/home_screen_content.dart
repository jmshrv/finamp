import 'package:finamp/components/Buttons/simple_button.dart';
import 'package:finamp/components/HomeScreen/auto_grid_item.dart';
import 'package:finamp/components/HomeScreen/show_all_button.dart';
import 'package:finamp/components/HomeScreen/show_all_screen.dart';
import 'package:finamp/components/MusicScreen/music_screen_tab_view.dart';
import 'package:finamp/components/global_snackbar.dart';
import 'package:finamp/models/finamp_models.dart';
import 'package:finamp/models/jellyfin_models.dart';
import 'package:finamp/screens/music_screen.dart';
import 'package:finamp/screens/queue_restore_screen.dart';
import 'package:finamp/services/downloads_service.dart';
import 'package:finamp/services/finamp_settings_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:get_it/get_it.dart';
import 'package:finamp/services/audio_service_helper.dart';
import 'package:finamp/services/finamp_user_helper.dart';
import 'package:finamp/services/jellyfin_api_helper.dart';
import 'package:finamp/components/Buttons/cta_large.dart';
import 'package:logging/logging.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:simple_gesture_detector/simple_gesture_detector.dart';

part 'home_screen_content.g.dart';

final _homeScreenLogger = Logger("HomeScreen");
const homeScreenSectionItemLimit = 10;

class HomeScreenContent extends ConsumerStatefulWidget {
  const HomeScreenContent({super.key});

  @override
  ConsumerState<HomeScreenContent> createState() => _HomeScreenContentState();
}

class _HomeScreenContentState extends ConsumerState<HomeScreenContent> {
  final _audioServiceHelper = GetIt.instance<AudioServiceHelper>();
  final _finampUserHelper = GetIt.instance<FinampUserHelper>();
  final _jellyfinApiHelper = GetIt.instance<JellyfinApiHelper>();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    FinampSettings? finampSettings = ref.watch(finampSettingsProvider).value;

    return SafeArea(
      bottom: false,
      child: RefreshIndicator(
        onRefresh: () async => Future.wait([
          ref.refresh(
            loadHomeSectionItemsProvider(
              sectionInfo: HomeScreenSectionInfo(type: HomeScreenSectionType.listenAgain),
            ).future,
          ),
          ref.refresh(
            loadHomeSectionItemsProvider(
              sectionInfo: HomeScreenSectionInfo(type: HomeScreenSectionType.newlyAdded),
            ).future,
          ),
          ref.refresh(
            loadHomeSectionItemsProvider(
              sectionInfo: HomeScreenSectionInfo(type: HomeScreenSectionType.favoriteArtists),
            ).future,
          ),
          ref.refresh(
            loadHomeSectionItemsProvider(
              sectionInfo: HomeScreenSectionInfo(type: HomeScreenSectionType.collection, itemId: BaseItemId("")),
            ).future,
          ),
        ]),
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 16.0, bottom: 200.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Wrap(
                spacing: 0,
                runSpacing: 8,
                direction: Axis.horizontal,
                alignment: WrapAlignment.spaceBetween,
                runAlignment: WrapAlignment.center,
                children: [
                  CTALarge(
                    text: 'Song Mix*',
                    icon: TablerIcons.arrows_shuffle,
                    vertical: true,
                    minWidth: 110,
                    onPressed: () {
                      _audioServiceHelper.shuffleAll(onlyShowFavorites: finampSettings?.onlyShowFavorites ?? false);
                    },
                  ),
                  CTALarge(
                    text: 'Recents*',
                    icon: TablerIcons.calendar,
                    vertical: true,
                    minWidth: 110,
                    onPressed: () {
                      Navigator.pushNamed(context, QueueRestoreScreen.routeName);
                    },
                  ),
                  CTALarge(
                    text: 'Decade Mix*',
                    icon: TablerIcons.chevrons_left,
                    vertical: true,
                    minWidth: 110,
                    onPressed: () {
                      GlobalSnackbar.message((buildContext) {
                        return "Decade Mix is not available yet.";
                      });
                    },
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Wrap(
                spacing: 0,
                runSpacing: 8,
                direction: Axis.horizontal,
                alignment: WrapAlignment.spaceAround,
                runAlignment: WrapAlignment.center,
                children: [
                  SimpleButton(
                    text: 'Tracks*',
                    icon: TablerIcons.music,
                    onPressed: () {
                      Navigator.pushNamed(context, MusicScreen.routeName, arguments: TabContentType.tracks);
                    },
                  ),
                  SimpleButton(
                    text: 'Playlists*',
                    icon: TablerIcons.playlist,
                    onPressed: () {
                      Navigator.pushNamed(context, MusicScreen.routeName, arguments: TabContentType.playlists);
                    },
                  ),
                  SimpleButton(
                    text: 'Albums*',
                    icon: TablerIcons.disc,
                    onPressed: () {
                      Navigator.pushNamed(context, MusicScreen.routeName, arguments: TabContentType.albums);
                    },
                  ),
                ],
              ),
              const SizedBox(height: 24),
              _buildSection(HomeScreenSectionInfo(type: HomeScreenSectionType.collection, itemId: BaseItemId(""))),
              _buildSection(HomeScreenSectionInfo(type: HomeScreenSectionType.listenAgain)),
              const SizedBox(height: 8),
              _buildSection(HomeScreenSectionInfo(type: HomeScreenSectionType.newlyAdded)),
              const SizedBox(height: 8),
              _buildSection(HomeScreenSectionInfo(type: HomeScreenSectionType.favoriteArtists)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSection(HomeScreenSectionInfo sectionInfo) {
    return Consumer(
      builder: (context, ref, child) {
        final items = ref.watch(loadHomeSectionItemsProvider(sectionInfo: sectionInfo));

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SimpleGestureDetector(
              onTap: () {
                // Handle the tap event
                GlobalSnackbar.message((buildContext) {
                  return "This feature is not available yet.";
                });
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    sectionInfo.type.toLocalisedString(context),
                    style: TextTheme.of(context).titleSmall?.copyWith(
                      fontWeight: FontWeight.w500,
                      fontSize: 18,
                      color: Theme.of(context).brightness == Brightness.light ? Colors.black : Colors.white,
                    ),
                  ),
                  ShowAllButton(
                    onPressed: () {
                      Navigator.pushNamed(context, ShowAllScreen.routeName, arguments: sectionInfo);
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            _buildHorizontalList(items),
          ],
        );
      },
    );
  }

  Widget _buildHorizontalList(AsyncValue<List<BaseItemDto>?> items) {
    return switch (items) {
      AsyncData(:final value) => switch (value) {
        null => _buildHorizontalSkeletonLoader(),
        [] => const Center(child: Text("No items available.", maxLines: 1)),
        _ => SizedBox(
          height: 175,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: value.length,
            itemBuilder: (context, index) {
              final BaseItemDto item = value[index];
              return AutoGridItem(baseItem: item);
            },
            separatorBuilder: (context, index) => const SizedBox(width: 2),
          ),
        ),
      },
      AsyncError(:final error) => () {
        _homeScreenLogger.severe("Error loading items: $error");
        return Center(child: Text("Failed to load items.", maxLines: 1));
      }(),
      _ => _buildHorizontalSkeletonLoader(),
    };
  }

  Widget _buildHorizontalSkeletonLoader() {
    return SizedBox(
      height: 175,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: 5, // Show 5 skeleton items
        itemBuilder: (context, index) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(8)),
              ),
              SizedBox(height: 4 + 5),
              Container(
                width: 120,
                height: 10,
                decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(4)),
              ),
              SizedBox(height: 4 + 5),
              Container(
                width: 50,
                height: 10,
                decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(4)),
              ),
            ],
          );
        },
        separatorBuilder: (context, index) => const SizedBox(width: 8),
      ),
    );
  }
}

@riverpod
Future<List<BaseItemDto>?> loadHomeSectionItems(
  Ref ref, {
  required HomeScreenSectionInfo sectionInfo,
  int startIndex = 0,
  int limit = homeScreenSectionItemLimit,
}) async {
  final jellyfinApiHelper = GetIt.instance<JellyfinApiHelper>();
  final finampUserHelper = GetIt.instance<FinampUserHelper>();
  final settings = FinampSettingsHelper.finampSettings;

  print("CALLED loadHomeSectionItems provider with ${sectionInfo.type}");

  final Future<List<BaseItemDto>?> newItemsFuture;

  if (settings.isOffline) {
    newItemsFuture = loadHomeSectionItemsOffline(sectionInfo: sectionInfo, startIndex: startIndex, limit: limit);
    return newItemsFuture;
  }

  switch (sectionInfo.type) {
    case HomeScreenSectionType.listenAgain:
      newItemsFuture = jellyfinApiHelper.getItems(
        parentItem: finampUserHelper.currentUser?.currentView,
        includeItemTypes: [BaseItemDtoType.album.idString, BaseItemDtoType.playlist.idString].join(","),
        sortBy: SortBy.datePlayed.jellyfinName(null),
        sortOrder: SortOrder.descending.toString(),
        // filters: settings.onlyShowFavorites ? "IsFavorite" : null,
        startIndex: startIndex,
        limit: limit,
      );
      break;
    case HomeScreenSectionType.newlyAdded:
      newItemsFuture = jellyfinApiHelper.getItems(
        parentItem: finampUserHelper
            .currentUser
            ?.currentView, //FIXME Jellyfin can't query (playlists) and (albums of a specific library) at the same time yet
        includeItemTypes: [BaseItemDtoType.album.idString, BaseItemDtoType.playlist.idString].join(","),
        sortBy: SortBy.dateCreated.jellyfinName(null),
        sortOrder: SortOrder.descending.toString(),
        // filters: settings.onlyShowFavorites ? "IsFavorite" : null,
        startIndex: startIndex,
        limit: limit,
      );
      break;
    case HomeScreenSectionType.favoriteArtists:
      newItemsFuture = jellyfinApiHelper.getItems(
        parentItem: finampUserHelper.currentUser?.currentView,
        includeItemTypes: [BaseItemDtoType.artist.idString].join(","),
        sortBy: SortBy.datePlayed.jellyfinName(null),
        sortOrder: SortOrder.descending.toString(),
        filters: "IsFavorite",
        startIndex: startIndex,
        limit: limit,
      );
      break;
    case HomeScreenSectionType.collection:
      final baseItem = await jellyfinApiHelper.getItemById(
        sectionInfo.itemId!,
      ); //TODO I don't like this null check. Enforcing IDs for collection types would be much nice, but how to do that while allowing dynamic IDs? Enums don't seem to work
      newItemsFuture = jellyfinApiHelper.getItems(
        parentItem: baseItem,
        // includeItemTypes: [
        //   BaseItemDtoType.album.idString,
        //   BaseItemDtoType.playlist.idString,
        //   BaseItemDtoType.artist.idString,
        //   BaseItemDtoType.genre.idString,
        //   BaseItemDtoType.audioBook.idString,
        // ].join(","),
        recursive: false, //!!! prevent loading tracks and albums from inside the collection items
        // filters: "IsFavorite",
        startIndex: startIndex,
        limit: limit,
      );
      break;
  }

  return await newItemsFuture;
}

Future<List<BaseItemDto>?> loadHomeSectionItemsOffline({
  required HomeScreenSectionInfo sectionInfo,
  int startIndex = 0,
  int limit = 10,
}) async {
  final FinampSettings settings = FinampSettingsHelper.finampSettings;
  final downloadsService = GetIt.instance<DownloadsService>();
  final finampUserHelper = GetIt.instance<FinampUserHelper>();

  List<DownloadStub> offlineItems;
  List<BaseItemDto> items;

  switch (sectionInfo.type) {
    case HomeScreenSectionType.listenAgain:
      //FIXME this seems to also return metadata-only albums which don't have any downloaded children
      offlineItems = await downloadsService.getAllCollections(
        includeItemTypes: [BaseItemDtoType.album, BaseItemDtoType.playlist], //FIXME support allowing multiple types
        fullyDownloaded: settings.onlyShowFullyDownloaded,
        viewFilter: finampUserHelper.currentUser?.currentViewId,
        childViewFilter: null,
        nullableViewFilters: settings.showDownloadsWithUnknownLibrary,
        onlyFavorites: settings.onlyShowFavorites && settings.trackOfflineFavorites,
      );

      items = offlineItems.map((e) => e.baseItem).nonNulls.toList();
      items = sortItems(items, SortBy.datePlayed, SortOrder.descending);
      break;

    case HomeScreenSectionType.newlyAdded:
      offlineItems = await downloadsService.getAllCollections(
        includeItemTypes: [BaseItemDtoType.album, BaseItemDtoType.playlist], //FIXME support allowing multiple types
        fullyDownloaded: settings.onlyShowFullyDownloaded,
        viewFilter: finampUserHelper.currentUser?.currentViewId,
        childViewFilter: null,
        nullableViewFilters: settings.showDownloadsWithUnknownLibrary,
        onlyFavorites: settings.onlyShowFavorites && settings.trackOfflineFavorites,
      );
      items = offlineItems.map((e) => e.baseItem).nonNulls.toList();
      items = sortItems(items, SortBy.dateCreated, SortOrder.descending);
      break;
    case HomeScreenSectionType.favoriteArtists:
      offlineItems = await downloadsService.getAllCollections(
        includeItemTypes: [BaseItemDtoType.artist],
        fullyDownloaded: settings.onlyShowFullyDownloaded,
        viewFilter: finampUserHelper.currentUser?.currentViewId,
        childViewFilter: null,
        nullableViewFilters: false,
        onlyFavorites: settings.onlyShowFavorites && settings.trackOfflineFavorites,
      );
      items = offlineItems.map((e) => e.baseItem).nonNulls.toList();
      items = sortItems(items, SortBy.datePlayed, SortOrder.descending);
      break;
    default:
      offlineItems = <DownloadStub>[]; // No items for other sections
      items = offlineItems.map((e) => e.baseItem).nonNulls.toList();
  }

  return items.take(limit).toList();
}
