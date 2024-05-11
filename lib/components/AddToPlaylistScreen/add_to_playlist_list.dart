import 'dart:async';

import 'package:finamp/components/PlayerScreen/queue_source_helper.dart';
import 'package:finamp/components/album_image.dart';
import 'package:finamp/services/finamp_settings_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:get_it/get_it.dart';

import '../../models/jellyfin_models.dart';
import '../../services/jellyfin_api_helper.dart';
import '../PlayerScreen/playlist_actions_menu.dart';
import '../global_snackbar.dart';

class AddToPlaylistList extends StatefulWidget {
  const AddToPlaylistList({
    super.key,
    required this.itemToAdd,
    required this.accentColor,
    required this.partOfPlaylists,
  });

  final BaseItemDto itemToAdd;
  final Color accentColor;
  final List<BaseItemDto>? partOfPlaylists;

  @override
  State<AddToPlaylistList> createState() => _AddToPlaylistListState();
}

class _AddToPlaylistListState extends State<AddToPlaylistList> {
  final jellyfinApiHelper = GetIt.instance<JellyfinApiHelper>();
  late Future<List<BaseItemDto>?> addToPlaylistListFuture;

  @override
  void initState() {
    super.initState();
    addToPlaylistListFuture = jellyfinApiHelper.getItems(
      includeItemTypes: "Playlist",
      sortBy: "SortName",
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<BaseItemDto>?>(
      future: addToPlaylistListFuture,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return SliverList(
              delegate: SliverChildBuilderDelegate(
            (context, index) {
              final playlistItem = snapshot.data![index];
              bool isPartOfPlaylist = false;
              if (widget.partOfPlaylists
                      ?.any((element) => element.id == playlistItem.id) ??
                  false) {
                isPartOfPlaylist = true;
              }
              final isOffline = FinampSettingsHelper.finampSettings.isOffline;
              return ToggleableListTile(
                title: playlistItem.name ??
                    AppLocalizations.of(context)!.unknownName,
                subtitle: AppLocalizations.of(context)!
                    .songCount(playlistItem.childCount ?? 0),
                leading: AlbumImage(item: playlistItem),
                positiveIcon: TablerIcons.circle_check_filled,
                negativeIcon: TablerIcons
                    .circle_dashed_check, // we don't actually know if the track is part of the playlist
                initialState: isPartOfPlaylist,
                onToggle: (bool currentState) async {
                  bool isPartOfPlaylist = currentState;
                  if (currentState) {
                    // part of playlist, remove
                    //TODO not currently possible, because we don't have the playlist item id after adding
                  } else {
                    // add to playlist
                    bool added = await addItemToPlaylist(
                        context, widget.itemToAdd, playlistItem);
                    isPartOfPlaylist = added;
                  }

                  return isPartOfPlaylist;
                },
                enabled: !isOffline,
                accentColor: widget.accentColor,
              );
            },
            childCount: snapshot.data!.length,
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
          return const SliverToBoxAdapter(
            child: Center(
              heightFactor: 3.0,
              child: CircularProgressIndicator.adaptive(),
            ),
          );
        }
      },
    );
  }
}
