import 'package:finamp/components/AudioServiceSettingsScreen/track_shuffle_item_count_editor.dart';
import 'package:finamp/components/Buttons/cta_small.dart';
import 'package:finamp/components/HomeScreen/auto_grid_item.dart';
import 'package:finamp/components/HomeScreen/finamp_home_screen_header.dart';
import 'package:finamp/components/MusicScreen/album_item.dart';
import 'package:finamp/components/global_snackbar.dart';
import 'package:finamp/models/finamp_models.dart';
import 'package:finamp/models/jellyfin_models.dart';
import 'package:finamp/screens/music_screen.dart';
import 'package:finamp/screens/queue_restore_screen.dart';
import 'package:finamp/services/finamp_settings_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:get_it/get_it.dart';
import 'package:finamp/services/audio_service_helper.dart';
import 'package:finamp/services/finamp_user_helper.dart';
import 'package:finamp/services/jellyfin_api_helper.dart';
import 'package:finamp/components/Buttons/simple_button.dart';
import 'package:finamp/components/Buttons/cta_large.dart';
import 'package:finamp/components/Buttons/cta_medium.dart';

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
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
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
                  text: 'Song Mix',
                  icon: TablerIcons.arrows_shuffle,
                  vertical: true,
                  minWidth: 110,
                  onPressed: () {
                    _audioServiceHelper.shuffleAll(
                        finampSettings?.onlyShowFavourites ?? false);
                  },
                ),
                CTALarge(
                  text: 'Recents',
                  icon: TablerIcons.calendar,
                  vertical: true,
                  minWidth: 110,
                  onPressed: () {
                    Navigator.pushNamed(
                      context,
                      QueueRestoreScreen.routeName,
                    );
                  },
                ),
                CTALarge(
                  text: 'Decade Mix',
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
              alignment: WrapAlignment.spaceBetween,
              runAlignment: WrapAlignment.center,
              children: [
                CTASmall(
                  text: 'Tracks',
                  icon: TablerIcons.music,
                  onPressed: () {
                    Navigator.pushNamed(
                      context,
                      MusicScreen.routeName,
                      arguments: TabContentType.tracks,
                    );
                  },
                ),
                CTASmall(
                  text: 'Playlists',
                  icon: TablerIcons.playlist,
                  onPressed: () {
                    Navigator.pushNamed(
                      context,
                      MusicScreen.routeName,
                      arguments: TabContentType.playlists,
                    );
                  },
                ),
                CTASmall(
                  text: 'Albums',
                  icon: TablerIcons.disc,
                  onPressed: () {
                    Navigator.pushNamed(
                      context,
                      MusicScreen.routeName,
                      arguments: TabContentType.albums,
                    );
                  },
                ),
              ],
            ),
            const SizedBox(height: 24),
            _buildSection(
                'Listen Again',
                _buildHorizontalList(
                    loadHomeSectionItems(HomeScreenSectionType.listenAgain))),
            const SizedBox(height: 16),
            _buildSection(
                'Newly Added',
                _buildHorizontalList(
                    loadHomeSectionItems(HomeScreenSectionType.newlyAdded))),
            const SizedBox(height: 16),
            _buildSection(
                'Favorite Artists',
                _buildHorizontalList(loadHomeSectionItems(
                    HomeScreenSectionType.favoriteArtists))),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(String title, Widget content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        content,
      ],
    );
  }

  Widget _buildHorizontalList(Future<List<BaseItemDto>?> items) {
    return FutureBuilder<List<BaseItemDto>?>(
      future: items,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return SizedBox(
            height: 120,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: 5, // Show 5 skeleton items
              itemBuilder: (context, index) {
                return Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(8),
                  ),
                );
              },
              separatorBuilder: (context, index) => const SizedBox(width: 16),
            ),
          );
        } else if (snapshot.hasData) {
          return SizedBox(
            height: 120,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final BaseItemDto item = snapshot.data![index];
                return AutoGridItem(baseItem: item);
              },
              separatorBuilder: (context, index) => const SizedBox(width: 16),
            ),
          );
        } else {
          return const Center(child: Text('No items available.'));
        }
      },
    );
  }
}

Future<List<BaseItemDto>?> loadHomeSectionItems(
    HomeScreenSectionType sectionType) async {
  final jellyfinApiHelper = GetIt.instance<JellyfinApiHelper>();
  final finampUserHelper = GetIt.instance<FinampUserHelper>();
  final settings = FinampSettingsHelper.finampSettings;

  final Future<List<BaseItemDto>?> newItemsFuture;

  final int amountOfItems = 10;

  switch (sectionType) {
    case HomeScreenSectionType.listenAgain:
      newItemsFuture = jellyfinApiHelper.getItems(
        parentItem: finampUserHelper.currentUser?.currentView,
        includeItemTypes: [
          BaseItemDtoType.album.idString,
          BaseItemDtoType.playlist.idString
        ].join(","),
        sortBy: SortBy.datePlayed.jellyfinName(null),
        sortOrder: SortOrder.descending.toString(),
        // filters: settings.onlyShowFavourites ? "IsFavorite" : null,
        startIndex: 0,
        limit: amountOfItems,
      );
      break;
    case HomeScreenSectionType.newlyAdded:
      newItemsFuture = jellyfinApiHelper.getItems(
        parentItem: finampUserHelper.currentUser?.currentView,
        includeItemTypes: [
          BaseItemDtoType.album.idString,
          BaseItemDtoType.playlist.idString
        ].join(","),
        sortBy: SortBy.dateCreated.jellyfinName(null),
        sortOrder: SortOrder.descending.toString(),
        // filters: settings.onlyShowFavourites ? "IsFavorite" : null,
        startIndex: 0,
        limit: amountOfItems,
      );
      break;
    case HomeScreenSectionType.favoriteArtists:
      newItemsFuture = jellyfinApiHelper.getItems(
        parentItem: finampUserHelper.currentUser?.currentView,
        includeItemTypes: [
          BaseItemDtoType.artist.idString,
        ].join(","),
        sortBy: SortBy.datePlayed.jellyfinName(null),
        sortOrder: SortOrder.descending.toString(),
        filters: "IsFavorite",
        startIndex: 0,
        limit: amountOfItems,
      );
      break;
  }

  return newItemsFuture;
}
