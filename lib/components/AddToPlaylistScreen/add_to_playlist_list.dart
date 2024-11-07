import 'dart:async';

import 'package:collection/collection.dart';
import 'package:finamp/components/Buttons/cta_medium.dart';
import 'package:finamp/components/PlayerScreen/queue_source_helper.dart';
import 'package:finamp/components/album_image.dart';
import 'package:finamp/services/downloads_service.dart';
import 'package:finamp/services/finamp_settings_helper.dart';
import 'package:finamp/services/jellyfin_api_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:get_it/get_it.dart';

import '../../models/jellyfin_models.dart';
import '../global_snackbar.dart';
import 'new_playlist_dialog.dart';
import 'playlist_actions_menu.dart';

class AddToPlaylistList extends StatefulWidget {
  const AddToPlaylistList({
    super.key,
    required this.itemToAdd,
    required this.playlistsFuture,
  });

  final BaseItemDto itemToAdd;
  final Future<List<BaseItemDto>> playlistsFuture;

  @override
  State<AddToPlaylistList> createState() => _AddToPlaylistListState();
}

class _AddToPlaylistListState extends State<AddToPlaylistList> {
  @override
  void initState() {
    super.initState();
    playlistsFuture = widget.playlistsFuture.then(
        (value) => value.map((e) => (e, false, null as String?)).toList());
  }

  // playlist, isLoading, playlistItemId
  late Future<List<(BaseItemDto, bool, String?)>> playlistsFuture;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: playlistsFuture,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return SliverList(
              delegate: SliverChildBuilderDelegate(
            (context, index) {
              if (index == snapshot.data!.length) {
                return createNewPlaylistButton(context);
              }
              final (playlist, isLoading, playListItemId) =
                  snapshot.data![index];
              return AddToPlaylistTile(
                  playlist: playlist,
                  song: widget.itemToAdd,
                  playlistItemId: playListItemId,
                  isLoading: isLoading);
            },
            childCount: snapshot.data!.length + 1,
          ));
        } else if (snapshot.hasError) {
          GlobalSnackbar.error(snapshot.error);
          return const SliverToBoxAdapter(
            child: Center(
              heightFactor: 3.0,
              child: Icon(Icons.error, size: 64),
            ),
          );
        } else {
          return SliverList(
              delegate: SliverChildBuilderDelegate((context, index) {
            if (index == 1) {
              return createNewPlaylistButton(context);
            } else {
              return const Center(
                child: CircularProgressIndicator.adaptive(),
              );
            }
          }, childCount: 2));
        }
      },
    );
  }

  Widget createNewPlaylistButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CTAMedium(
            text: AppLocalizations.of(context)!.newPlaylist,
            icon: TablerIcons.plus,
            //accentColor: Theme.of(context).colorScheme.primary,
            onPressed: () async {
              var dialogResult = await showDialog<(Future<String>, String?)?>(
                context: context,
                builder: (context) =>
                    NewPlaylistDialog(itemToAdd: widget.itemToAdd.id),
              );
              if (dialogResult != null) {
                var oldFuture = playlistsFuture;
                setState(() {
                  var loadingItem = [
                    (
                      BaseItemDto(id: "pending", name: dialogResult.$2),
                      true,
                      null as String?
                    )
                  ];
                  playlistsFuture =
                      oldFuture.then((value) => value + loadingItem);
                });
                try {
                  var newId = await dialogResult.$1;
                  // Give the server time to calculate an initial playlist image
                  await Future.delayed(const Duration(seconds: 1));
                  final jellyfinApiHelper = GetIt.instance<JellyfinApiHelper>();
                  var playlist = await jellyfinApiHelper.getItemById(newId);
                  var playlistItems = await jellyfinApiHelper.getItems(
                      parentItem: playlist, fields: "");
                  var song = playlistItems?.firstWhere(
                      (element) => element.id == widget.itemToAdd.id);
                  setState(() {
                    var newItem = [(playlist, false, song?.playlistItemId)];
                    playlistsFuture =
                        oldFuture.then((value) => value + newItem);
                  });
                } catch (e) {
                  GlobalSnackbar.error(e);
                }
              }
            },
          ),
        ],
      ),
    );
  }
}

class AddToPlaylistTile extends StatefulWidget {
  const AddToPlaylistTile(
      {super.key,
      required this.playlist,
      this.playlistItemId,
      required this.song,
      this.isLoading = false});

  final BaseItemDto playlist;
  final BaseItemDto song;
  final String? playlistItemId;
  final bool isLoading;

  @override
  State<AddToPlaylistTile> createState() => _AddToPlaylistTileState();
}

class _AddToPlaylistTileState extends State<AddToPlaylistTile> {
  String? playlistItemId;
  int? childCount;
  bool? itemIsIncluded;

  @override
  void initState() {
    super.initState();
    _updateState();
  }

  @override
  void didUpdateWidget(AddToPlaylistTile oldWidget) {
    super.didUpdateWidget(oldWidget);
    _updateState();
  }

  void _updateState() {
    if (!widget.isLoading) {
      playlistItemId = widget.playlistItemId;
      childCount = widget.playlist.childCount;
      if (widget.playlistItemId != null) {
        itemIsIncluded = true;
      } else {
        final downloadsService = GetIt.instance<DownloadsService>();
        itemIsIncluded =
            downloadsService.checkIfInCollection(widget.playlist, widget.song);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isOffline = FinampSettingsHelper.finampSettings.isOffline;
    return ToggleableListTile(
      forceLoading: widget.isLoading,
      title: widget.playlist.name ?? AppLocalizations.of(context)!.unknownName,
      subtitle: AppLocalizations.of(context)!.songCount(childCount ?? 0),
      leading: AlbumImage(item: widget.playlist),
      positiveIcon: TablerIcons.circle_check_filled,
      negativeIcon: itemIsIncluded == null
          // we don't actually know if the track is part of the playlist
          ? TablerIcons.circle_dashed_plus
          : TablerIcons.circle_plus,
      initialState: itemIsIncluded ?? false,
      onToggle: (bool currentState) async {
        if (currentState) {
          // If playlistItemId is null, we need to fetch from the server before we can remove
          if (playlistItemId == null) {
            final jellyfinApiHelper = GetIt.instance<JellyfinApiHelper>();
            var newItems = await jellyfinApiHelper.getItems(
                parentItem: widget.playlist, fields: "");

            playlistItemId = newItems
                ?.firstWhereOrNull((x) => x.id == widget.song.id)
                ?.playlistItemId;
            if (playlistItemId == null) {
              // We were already not part of the playlist,. so removal is complete
              setState(() {
                childCount = newItems?.length ?? 0;
                itemIsIncluded = false;
              });
              return false;
            }
            if (!context.mounted) {
              return true;
            }
          }
          // part of playlist, remove
          bool removed = await removeFromPlaylist(
              context, widget.song, widget.playlist, playlistItemId!,
              confirm: false);
          if (removed) {
            setState(() {
              childCount = childCount == null ? null : childCount! - 1;
              itemIsIncluded = false;
            });
          }
          return !removed;
        } else {
          // add to playlist
          bool added =
              await addItemToPlaylist(context, widget.song, widget.playlist);
          if (added) {
            final jellyfinApiHelper = GetIt.instance<JellyfinApiHelper>();
            var newItems = await jellyfinApiHelper.getItems(
                parentItem: widget.playlist, fields: "");
            setState(() {
              childCount = newItems?.length ?? 0;
              playlistItemId = newItems
                  ?.firstWhereOrNull((x) => x.id == widget.song.id)
                  ?.playlistItemId;
              itemIsIncluded = true;
            });
            return true; // this is called before the state is updated
          }
          return false;
        }
      },
      enabled: !isOffline,
    );
  }
}
