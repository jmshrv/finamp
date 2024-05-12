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
import '../global_snackbar.dart';
import 'new_playlist_dialog.dart';
import 'playlist_actions_menu.dart';

class AddToPlaylistList extends StatefulWidget {
  const AddToPlaylistList({
    super.key,
    required this.itemToAdd,
    this.hiddenPlaylists = const [],
    this.playlistsCallback,
  });

  final BaseItemDto itemToAdd;
  final List<BaseItemDto> hiddenPlaylists;
  final ValueNotifier<List<BaseItemDto>?>? playlistsCallback;

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
    addToPlaylistListFuture
        .then((value) => widget.playlistsCallback?.value = value);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<BaseItemDto>?>(
      future: addToPlaylistListFuture,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          var playlists = snapshot.data!
              .where((element) => !widget.hiddenPlaylists
                  .any((hidden) => element.id == hidden.id))
              .toList();
          return SliverList(
              delegate: SliverChildBuilderDelegate(
            (context, index) {
              if (index == playlists.length) {
                return addToPlaylistButton(context);
              }
              final playlistItem = playlists[index];
              bool isPartOfPlaylist = widget.hiddenPlaylists
                  .any((element) => element.id == playlistItem.id);
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
                  if (currentState) {
                    // part of playlist, remove
                    //TODO not currently possible, because we don't have the playlist item id after adding
                    return currentState;
                  } else {
                    // add to playlist
                    bool added = await addItemToPlaylist(
                        context, widget.itemToAdd, playlistItem);
                    if (added && playlistItem.childCount != null) {
                      setState(() {
                        playlistItem.childCount = playlistItem.childCount! + 1;
                      });
                    }
                    return added;
                  }
                },
                enabled: !isOffline,
              );
            },
            childCount: playlists.length + 1,
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

  Widget addToPlaylistButton(BuildContext context) {
    final isOffline = FinampSettingsHelper.finampSettings.isOffline;
    return ToggleableListTile(
      title: AppLocalizations.of(context)!.newPlaylist,
      leading: AspectRatio(
        aspectRatio: 1.0,
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary.withOpacity(0.3),
          ),
          child: const Center(
            child: Icon(
              TablerIcons.plus,
              size: 36.0,
              color: Colors.white,
            ),
          ),
        ),
      ),
      positiveIcon: TablerIcons.circle_check_filled,
      negativeIcon: TablerIcons
          .circle_dashed_check, // we don't actually know if the track is part of the playlist
      initialState: false,
      onToggle: (bool currentState) async {
        assert(currentState == false);
        // The dialog returns true if a playlist is created. If this is the
        // case, we also pop this page. It will return false if the user
        // cancels the dialog.
        final result = await await showDialog<Future<bool>>(
          context: context,
          builder: (context) =>
              NewPlaylistDialog(itemToAdd: widget.itemToAdd.id),
        );

        if (!context.mounted) return currentState;

        if (result ?? false) {
          Navigator.of(context).pop();
        }
        return currentState;
      },
      enabled: !isOffline,
    );
  }
}
