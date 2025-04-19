import 'dart:math' as math;

import 'package:finamp/components/AlbumScreen/album_screen_content.dart';
import 'package:finamp/components/albums_sliver_list.dart';
import 'package:finamp/models/jellyfin_models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sticky_header/flutter_sticky_header.dart';

class TracksSection extends StatefulWidget {
  const TracksSection({
    required this.parent,
    this.tracks,
    this.childrenForQueue,
    required this.tracksText,
    this.seeAllCallbackFunction,
  });

  final BaseItemDto parent;
  final List<BaseItemDto>? tracks;
  final Future<List<BaseItemDto>>? childrenForQueue;
  final String tracksText;
  final VoidCallback? seeAllCallbackFunction;

  @override
  State<TracksSection> createState() => _TracksSectionState();
}

class _TracksSectionState extends State<TracksSection> {
  bool _showTracks = true;
  bool _isExpandable = true;
        
  @override
  Widget build(BuildContext context) {
    if (widget.tracks == null || widget.tracks?.isEmpty != false ||
      widget.childrenForQueue == null) {
        _showTracks = false;
        _isExpandable = false;
    }

    return SliverStickyHeader(
      header: Container(
        padding: EdgeInsets.fromLTRB(
            6, widget.parent.type == "MusicGenre" ? 12 : 0, 6, 0),
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        child: GestureDetector(
          onTap: () {
            if (_isExpandable) {
              setState(() {
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
                          "See All",
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
              TracksSliverList(
                childrenForList: widget.tracks!,
                childrenForQueue: widget.childrenForQueue!,
                showPlayCount: true,
                isOnArtistScreen: true,
                parent: widget.parent,
              ),
              SliverToBoxAdapter(
                  child: SizedBox(
                      height: (widget.parent.type != "MusicGenre") ? 14 : 0)),
            ])
          : SliverToBoxAdapter(child: SizedBox.shrink()),
    );
  }
}

class AlbumSection extends StatefulWidget {
  const AlbumSection({
    required this.parent,
    required this.albumsText,
    this.albums,
    this.seeAllCallbackFunction
  });

  final BaseItemDto parent;
  final String albumsText;
  final List<BaseItemDto>? albums;
  final VoidCallback? seeAllCallbackFunction;

  @override
  State<AlbumSection> createState() => _AlbumSectionState();
}

class _AlbumSectionState extends State<AlbumSection> {
  bool _showAlbums = true;
  bool _isExpandable = true;
        
  @override
  Widget build(BuildContext context) {
    if (widget.albums == null || widget.albums?.isEmpty != false) {
        _showAlbums = false;
        _isExpandable = false;
    }

    return SliverStickyHeader(
      header: Container(
        padding: EdgeInsets.fromLTRB(
            6, widget.parent.type == "MusicGenre" ? 12 : 0, 6, 0),
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        child: GestureDetector(
          onTap: () {
            if (_isExpandable) {
              setState(() {
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
                          "See All",
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
          ? SliverMainAxisGroup(slivers: [
              AlbumsSliverList(
                childrenForList: widget.albums!,
                parent: widget.parent,
              ),
              SliverToBoxAdapter(
                  child: SizedBox(
                      height: (widget.parent.type != "MusicGenre") ? 14 : 0)),
            ])
          : SliverToBoxAdapter(child: SizedBox.shrink()),
    );
  }
}
