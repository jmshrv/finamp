import 'dart:async';

import 'package:finamp/components/Buttons/cta_medium.dart';
import 'package:finamp/components/curated_item_filter_row.dart';
import 'package:finamp/services/artist_content_provider.dart';
import 'package:finamp/components/curated_item_sections.dart';
import 'package:finamp/l10n/app_localizations.dart';
import 'package:finamp/services/finamp_user_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';

import '../../models/finamp_models.dart';
import '../../models/jellyfin_models.dart';
import '../../services/downloads_service.dart';
import '../../services/finamp_settings_helper.dart';
import '../../services/jellyfin_api_helper.dart';
import '../AlbumScreen/download_button.dart';
import '../favorite_button.dart';
import '../padded_custom_scrollview.dart';
import 'artist_screen_content_flexible_space_bar.dart';

class ArtistScreenContent extends ConsumerStatefulWidget {
  const ArtistScreenContent({
    super.key,
    required this.parent,
    this.library,
    this.genreFilter,
  });

  final BaseItemDto parent;
  final BaseItemDto? library;
  final BaseItemDto? genreFilter;

  @override
  ConsumerState<ArtistScreenContent> createState() => _ArtistScreenContentState();
}

class _ArtistScreenContentState extends ConsumerState<ArtistScreenContent> {
  JellyfinApiHelper jellyfinApiHelper = GetIt.instance<JellyfinApiHelper>();
  final _downloadsService = GetIt.instance<DownloadsService>();
  final Set<CuratedItemSelectionType> _disabledTrackFilters = {};
  BaseItemDto? currentGenreFilter;
  CuratedItemSelectionType? clickedCuratedItemSelectionType;

  StreamSubscription<void>? _refreshStream;

  @override
  void initState() {
    _refreshStream = _downloadsService.offlineDeletesStream.listen((event) {
      _refresh();
    });
    currentGenreFilter = widget.genreFilter;
    super.initState();
  }

  @override
  void dispose() {
    _refreshStream?.cancel();
    super.dispose();
  }

  Future<void> _refresh() async {
    ref.invalidate(getArtistTracksSectionProvider);
    ref.invalidate(getArtistAlbumsProvider);
    ref.invalidate(getPerformingArtistAlbumsProvider);
    ref.invalidate(getPerformingArtistTracksProvider);
    ref.invalidate(getArtistTracksProvider);
    _disabledTrackFilters.clear();
  }

  // Function to update the genre filter
  // Pass null in order to reset the filter
  void updateGenreFilter(BaseItemDto? genre) {
    setState(() {
      // We also clear the disabledTrackFilters
      _disabledTrackFilters.clear();
      currentGenreFilter = genre;
    });
  }

  @override
  Widget build(BuildContext context) {
    final finampUserHelper = GetIt.instance<FinampUserHelper>();
    final library = finampUserHelper.currentUser?.currentView;
    final artistItemSectionsOrder = ref.watch(finampSettingsProvider.artistItemSectionsOrder);
    final artistCuratedItemSectionFilterOrder = ref.watch(finampSettingsProvider.artistItemSectionFilterChipOrder);
    final bool autoSwitchItemCurationTypeEnabled = ref.watch(finampSettingsProvider.autoSwitchItemCurationType);

    List<BaseItemDto> allChildren = [];

    /// Similarly to the sections on the genreScreen, we can let the tracks section auto-switch
    /// when there are no items to show for the currently selected type. In this case, the provider
    /// will use the next available filter, fetch its items and return those in addition to a set
    /// containing the disabled filters that had no items.
    final (topTracksAsync, artistCuratedItemSelectionType, newDisabledTrackFilters) =
        ref.watch(getArtistTracksSectionProvider(widget.parent, widget.library, currentGenreFilter)).valueOrNull ??
            (null, null, null);
    final albumArtistAlbumsAsync =
        ref.watch(getArtistAlbumsProvider(widget.parent, widget.library, currentGenreFilter)).valueOrNull;
    final performingArtistAlbumsAsync =
        ref.watch(getPerformingArtistAlbumsProvider(widget.parent, widget.library, currentGenreFilter)).valueOrNull;
    final allPerformingArtistTracksAsync =
        ref.watch(getPerformingArtistTracksProvider(widget.parent, widget.library, currentGenreFilter)).valueOrNull;
    final allTracks = ref.watch(
      getArtistTracksProvider(widget.parent, widget.library, currentGenreFilter).future,
    );

    final isLoading = topTracksAsync == null || albumArtistAlbumsAsync == null || performingArtistAlbumsAsync == null;

    /// We add the new disabled filters to our local set, so that we don't accidentally re-enable
    /// previously disabled filters. Only a full refresh of the screen should do that.
    if (newDisabledTrackFilters != null) {
      _disabledTrackFilters.addAll(newDisabledTrackFilters.whereType<CuratedItemSelectionType>());
    }

    /// The currently active filter either has items (now) or the user has disabled auto-switching,
    /// so we can remove it from our disabled Set in case it was there before and show it as enabled.
    _disabledTrackFilters.remove(artistCuratedItemSelectionType);

    /// In case the user selects an option that has no items and auto-switch is enabled,
    /// we want to show a snackbar message in addition to disabling the filter.
    if (autoSwitchItemCurationTypeEnabled &&
        clickedCuratedItemSelectionType != null &&
        _disabledTrackFilters.contains(clickedCuratedItemSelectionType)) {
      sendEmptyItemSelectionTypeMessage(
          context: context,
          typeSelected: clickedCuratedItemSelectionType,
          messageFor: BaseItemDtoType.artist,
          hasGenreFilter: (currentGenreFilter != null));
      // When we've sent the message, we should reset the clicked value
      // so that we don't send it again on next state refresh
      clickedCuratedItemSelectionType = null;
    }

    final topTracks = topTracksAsync ?? [];
    final albumArtistAlbums = albumArtistAlbumsAsync ?? [];
    final performingArtistAlbums = performingArtistAlbumsAsync ?? [];
    final allPerformingArtistTracks = allPerformingArtistTracksAsync ?? [];

    var appearsOnAlbums = performingArtistAlbums.where((a) => !albumArtistAlbums.any((b) => b.id == a.id)).toList();

    // Combine Children to get correct ChildrenCount
    // for the Download Status Sync Display for Artists
    allChildren = [...albumArtistAlbums, ...allPerformingArtistTracks];

    return RefreshIndicator(
      onRefresh: _refresh,
      child: PaddedCustomScrollview(slivers: <Widget>[
        SliverAppBar(
          title: Text(widget.parent.name ?? AppLocalizations.of(context)!.unknownName),
          // 125 + 116 is the total height of the widget we use as a
          // FlexibleSpaceBar. We add the toolbar height since the widget
          // should appear below the appbar.
          expandedHeight: kToolbarHeight + 125 + 24 + CTAMedium.predictedHeight(context),
          centerTitle: false,
          pinned: true,
          flexibleSpace: ArtistScreenContentFlexibleSpaceBar(
            parentItem: widget.parent,
            allTracks: allTracks,
            albumCount: albumArtistAlbums.length,
            genreFilter: currentGenreFilter,
            updateGenreFilter: updateGenreFilter,
          ),
          actions: [
            FavoriteButton(item: widget.parent),
            if (!isLoading)
              DownloadButton(
                item: DownloadStub.fromFinampCollection(FinampCollection(
                  type: FinampCollectionType.collectionWithLibraryFilter,
                  library: library,
                  item: widget.parent,
                )),
                children: allChildren,
                downloadDisabled: (currentGenreFilter != null),
                customTooltip: (currentGenreFilter != null)
                    ? AppLocalizations.of(context)!.downloadButtonDisabledGenreFilterTooltip
                    : null,
              ),
          ],
        ),
        const SliverToBoxAdapter(child: SizedBox(height: 10)),
        if (!isLoading)
          ...artistItemSectionsOrder.map((type) {
            switch (type) {
              case ArtistItemSections.tracks:
                if (ref.watch(finampSettingsProvider.showArtistsTracksSection)) {
                  return SliverPadding(
                    padding: const EdgeInsets.all(0),
                    sliver: TracksSection(
                      parent: widget.parent,
                      tracks: topTracks,
                      childrenForQueue: topTracks,
                      tracksText: type.toLocalisedSectionTitle(context, artistCuratedItemSelectionType),
                      isOnArtistScreen: true,
                      genreFilter: currentGenreFilter,
                      includeFilterRow: true,
                      customFilterOrder: artistCuratedItemSectionFilterOrder,
                      selectedFilter: artistCuratedItemSelectionType,
                      disabledFilters: _disabledTrackFilters.toList(),
                      onFilterSelected: (type) {
                        // We store the clicked type locally in addition to changing the setting,
                        // because we don't know if the provider might auto-switch to something else
                        // because of an empty result-list, but we want to show a message in that case.
                        clickedCuratedItemSelectionType = type;
                        FinampSetters.setArtistCuratedItemSelectionType(type);
                      },
                    ),
                  );
                }
                return const SliverToBoxAdapter(child: SizedBox.shrink());
              case ArtistItemSections.albums:
                if (albumArtistAlbums.isNotEmpty) {
                  return SliverPadding(
                    padding: const EdgeInsets.all(0),
                    sliver: CollectionsSection(
                      parent: widget.parent,
                      itemsText: AppLocalizations.of(context)!.albums,
                      items: albumArtistAlbums,
                      albumsShowYearAndDurationInstead: true,
                    ),
                  );
                }
                return const SliverToBoxAdapter(child: SizedBox.shrink());
              case ArtistItemSections.appearsOn:
                if (appearsOnAlbums.isNotEmpty) {
                  return SliverPadding(
                    padding: const EdgeInsets.all(0),
                    sliver: CollectionsSection(
                      parent: widget.parent,
                      itemsText: AppLocalizations.of(context)!.appearsOnAlbums,
                      items: appearsOnAlbums,
                      albumsShowYearAndDurationInstead: true,
                    ),
                  );
                }
                return const SliverToBoxAdapter(child: SizedBox.shrink());
            }
          }),
        if (!isLoading && (albumArtistAlbums.isEmpty && appearsOnAlbums.isEmpty))
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(6, 12, 6, 0),
            sliver: SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 12),
                child: Center(
                  child: Text(
                    AppLocalizations.of(context)!.emptyFilteredListTitle,
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
          ),
        if (isLoading)
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 24),
              child: Center(
                child: CircularProgressIndicator.adaptive(),
              ),
            ),
          )
      ]),
    );
  }
}
