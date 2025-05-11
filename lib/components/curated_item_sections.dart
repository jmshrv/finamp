import 'dart:math' as math;

import 'package:finamp/components/AlbumScreen/album_screen_content.dart';
import 'package:finamp/components/curated_item_filter_row.dart';
import 'package:finamp/components/albums_sliver_list.dart';
import 'package:finamp/l10n/app_localizations.dart';
import 'package:finamp/models/finamp_models.dart';
import 'package:finamp/models/jellyfin_models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_sticky_header/flutter_sticky_header.dart';

class TracksSection extends ConsumerStatefulWidget {
  const TracksSection({super.key, 
    required this.parent,
    this.tracks,
    this.childrenForQueue,
    required this.tracksText,
    this.seeAllCallbackFunction,
    this.includeFilterRow = false,
    this.customFilterOrder,
    this.selectedFilter,
    this.disabledFilters,
    this.onFilterSelected,
  });

  final BaseItemDto parent;
  final List<BaseItemDto>? tracks;
  final Future<List<BaseItemDto>>? childrenForQueue;
  final String tracksText;
  final VoidCallback? seeAllCallbackFunction;
  final bool includeFilterRow;
  final List<CuratedItemSelectionType>? customFilterOrder;
  final CuratedItemSelectionType? selectedFilter;
  final List<CuratedItemSelectionType>? disabledFilters;
  final void Function(CuratedItemSelectionType type)? onFilterSelected;

  @override
  ConsumerState<TracksSection> createState() => _TracksSectionState();
}

class _TracksSectionState extends ConsumerState<TracksSection> {
  bool _showTracks = true;
  bool _isExpandable = true;
  bool _manuallyClosed = false;

  @override
  void initState() {
    super.initState();
    _evaluateTrackVisibility();
  }

  @override
  void didUpdateWidget(covariant TracksSection oldWidget) {
    super.didUpdateWidget(oldWidget);
    _evaluateTrackVisibility();
  }

  void _evaluateTrackVisibility() {
    final hasTracks = widget.tracks != null && widget.tracks!.isNotEmpty;
    final hasQueue = widget.childrenForQueue != null;

    if ((hasTracks && hasQueue) || widget.includeFilterRow) {
      if (!_showTracks || !_isExpandable) {
        setState(() {
          if (!_manuallyClosed) {
            _showTracks = true;
          }
          _isExpandable = true;
        });
      }
    } else {
      if (_showTracks || _isExpandable) {
        setState(() {
          _showTracks = false;
          _isExpandable = false;
        });
      }
    }
  }
      
  @override
  Widget build(BuildContext context) {
    return SliverStickyHeader(
      header: Container(
        padding: EdgeInsets.fromLTRB(
            6, widget.parent.type == "MusicGenre" ? 12 : 0, 6, 0),
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        child: GestureDetector(
          onTap: () {
            if (_isExpandable) {
              setState(() {
                _manuallyClosed = _showTracks;
                _showTracks = !_showTracks;
              });
            }
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    if (_isExpandable)
                      Transform.rotate(
                        angle: _showTracks ? 0 : -math.pi / 2,
                        child: const Icon(Icons.arrow_drop_down, size: 24),
                      ),
                    if (_isExpandable)
                      const SizedBox(width: 4),
                    Text(
                      widget.tracksText,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                if (widget.seeAllCallbackFunction != null)
                  GestureDetector(
                    onTap: widget.seeAllCallbackFunction,
                    child: Row(
                      children: [
                        Text(
                          AppLocalizations.of(context)!.seeAll,
                          style: TextStyle(
                            fontSize: 14,
                            color: Theme.of(context).colorScheme.primary,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Icon(
                          Icons.chevron_right,
                          size: 20,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
      sliver: _showTracks
          ? SliverMainAxisGroup(slivers: [
              if (widget.includeFilterRow)
                buildCuratedItemFilterRow(
                  ref: ref,
                  parent: widget.parent, 
                  filterListFor: BaseItemDtoType.track, 
                  customFilterOrder: widget.customFilterOrder,
                  selectedFilter: widget.selectedFilter,
                  disabledfilters: widget.disabledFilters,
                  onFilterSelected: widget.onFilterSelected,
                ),
              if (widget.tracks != null && widget.tracks!.isNotEmpty)
                TracksSliverList(
                  childrenForList: widget.tracks!,
                  childrenForQueue: widget.childrenForQueue!,
                  showPlayCount: true,
                  isOnArtistScreen: true,
                  parent: widget.parent,
                )
              else
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 12),
                    child: Center(
                      child: Text(
                        AppLocalizations.of(context)!.emptyFilteredListTitle,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ),
                  ),
                ),
              SliverToBoxAdapter(
                  child: SizedBox(
                      height: (widget.parent.type != "MusicGenre") ? 14 : 0
                  )
              ),
            ])
          : SliverToBoxAdapter(child: SizedBox.shrink()),
    );
  }
}

class AlbumSection extends ConsumerStatefulWidget {
  const AlbumSection({super.key, 
    required this.parent,
    required this.albumsText,
    this.albums,
    this.seeAllCallbackFunction,
    this.genreFilter,
    this.includeFilterRowFor,
    this.customFilterOrder,
    this.selectedFilter,
    this.disabledFilters,
    this.onFilterSelected, 
  });

  final BaseItemDto parent;
  final String albumsText;
  final List<BaseItemDto>? albums;
  final VoidCallback? seeAllCallbackFunction;
  final BaseItemDto? genreFilter;
  final BaseItemDtoType? includeFilterRowFor;
  final List<CuratedItemSelectionType>? customFilterOrder;
  final CuratedItemSelectionType? selectedFilter;
  final List<CuratedItemSelectionType>? disabledFilters;
  final void Function(CuratedItemSelectionType type)? onFilterSelected;

  @override
  ConsumerState<AlbumSection> createState() => _AlbumSectionState();
}

class _AlbumSectionState extends ConsumerState<AlbumSection> {
  bool _showAlbums = true;
  bool _isExpandable = true;
  bool _manuallyClosed = false;

  @override
  void initState() {
    super.initState();
    _evaluateAlbumVisibility();
  }

  @override
  void didUpdateWidget(covariant AlbumSection oldWidget) {
    super.didUpdateWidget(oldWidget);
    _evaluateAlbumVisibility();
  }

  void _evaluateAlbumVisibility() {
    final hasAlbums = widget.albums != null && widget.albums!.isNotEmpty;

    if (hasAlbums || widget.includeFilterRowFor != null) {
      if (!_showAlbums || !_isExpandable) {
        setState(() {
          if (!_manuallyClosed) {
            _showAlbums = true;
          }
          _isExpandable = true;
        });
      }
    } else {
      if (_showAlbums || _isExpandable) {
        setState(() {
          _showAlbums = false;
          _isExpandable = false;
        });
      }
    }
  }
        
  @override
  Widget build(BuildContext context) {
    return SliverStickyHeader(
      header: Container(
        padding: EdgeInsets.fromLTRB(
            6, widget.parent.type == "MusicGenre" ? 12 : 0, 6, 0),
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        child: GestureDetector(
          onTap: () {
            if (_isExpandable) {
              setState(() {
                _manuallyClosed = _showAlbums;
                _showAlbums = !_showAlbums;
              });
            }
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    if (_isExpandable)
                      Transform.rotate(
                        angle: _showAlbums ? 0 : -math.pi / 2,
                        child: const Icon(Icons.arrow_drop_down, size: 24),
                      ),
                    if (_isExpandable)
                      const SizedBox(width: 4),
                    Text(
                      widget.albumsText,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                if (widget.seeAllCallbackFunction != null)
                  GestureDetector(
                    onTap: widget.seeAllCallbackFunction,
                    child: Row(
                      children: [
                        Text(
                          AppLocalizations.of(context)!.seeAll,
                          style: TextStyle(
                            fontSize: 14,
                            color: Theme.of(context).colorScheme.primary,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Icon(
                          Icons.chevron_right,
                          size: 20,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
      sliver: _showAlbums
          ? SliverMainAxisGroup(
              slivers: [
                if (widget.includeFilterRowFor != null)
                  buildCuratedItemFilterRow(
                    ref: ref, 
                    parent: widget.parent,
                    filterListFor: widget.includeFilterRowFor!,
                    customFilterOrder: widget.customFilterOrder,
                    selectedFilter: widget.selectedFilter,
                    disabledfilters: widget.disabledFilters,
                    onFilterSelected: widget.onFilterSelected,
                  ),
                if (widget.albums != null && widget.albums!.isNotEmpty)
                  AlbumsSliverList(
                    childrenForList: widget.albums!,
                    parent: widget.parent,
                    genreFilter: widget.genreFilter,
                  )
                else
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 12),
                      child: Center(
                          child: Text(
                            AppLocalizations.of(context)!.emptyFilteredListTitle,
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                      ),
                    ),
                  ),
                SliverToBoxAdapter(
                  child: SizedBox(
                    height: (widget.parent.type != "MusicGenre") ? 14 : 0,
                  ),
                ),
              ],
          )
          : const SliverToBoxAdapter(child: SizedBox.shrink()),
    );
  }
}
