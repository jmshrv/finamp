import 'package:finamp/generate_material_color.dart';
import 'package:finamp/models/finamp_models.dart';
import 'package:finamp/services/album_image_provider.dart';
import 'package:finamp/services/queue_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
import 'package:palette_generator/palette_generator.dart';

import '../../models/jellyfin_models.dart';
import '../../screens/add_to_playlist_screen.dart';
import '../../screens/album_screen.dart';
import '../../services/audio_service_helper.dart';
import '../../services/current_album_image_provider.dart';
import '../../services/downloads_helper.dart';
import '../../services/finamp_settings_helper.dart';
import '../../services/jellyfin_api_helper.dart';
import '../../services/player_screen_theme_provider.dart';
import '../PlayerScreen/album_chip.dart';
import '../PlayerScreen/artist_chip.dart';
import '../PlayerScreen/song_info.dart';
import '../album_image.dart';
import '../error_snackbar.dart';

Future<void> showModalSongMenu(
    BuildContext context,
    BaseItemDto item,
    bool isInPlaylist,
    bool canGoToAlbum,
    Function? onDelete,
    String? parentId) async {
  final isOffline = FinampSettingsHelper.finampSettings.isOffline;
  await showModalBottomSheet(
      context: context,
      isDismissible: true,
      enableDrag: true,
      isScrollControlled: true,
      clipBehavior: Clip.hardEdge,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      useSafeArea: true,
      builder: (BuildContext context) {
        return SongMenu(
            item: item,
            isOffline: isOffline,
            isInPlaylist: isInPlaylist,
            canGoToAlbum: canGoToAlbum,
            onDelete: onDelete,
            parentId: parentId);
      });
}

class SongMenu extends StatefulWidget {
  const SongMenu({
    super.key,
    required this.item,
    required this.isOffline,
    required this.isInPlaylist,
    required this.canGoToAlbum,
    required this.onDelete,
    required this.parentId,
  });

  final BaseItemDto item;
  final bool isOffline;
  final bool isInPlaylist;
  final bool canGoToAlbum;
  final Function? onDelete;
  final String? parentId;

  @override
  State<SongMenu> createState() => _SongMenuState();
}

class _SongMenuState extends State<SongMenu> {
  final _jellyfinApiHelper = GetIt.instance<JellyfinApiHelper>();
  final _audioServiceHelper = GetIt.instance<AudioServiceHelper>();
  final _queueService = GetIt.instance<QueueService>();

  /// Sets the item's favourite on the Jellyfin server.
  Future<void> setFavourite() async {
    try {
      // We switch the widget state before actually doing the request to
      // make the app feel faster (without, there is a delay from the
      // user adding the favourite and the icon showing)
      setState(() {
        widget.item.userData!.isFavorite = !widget.item.userData!.isFavorite;
      });

      // Since we flipped the favourite state already, we can use the flipped
      // state to decide which API call to make
      final newUserData = widget.item.userData!.isFavorite
          ? await _jellyfinApiHelper.addFavourite(widget.item.id)
          : await _jellyfinApiHelper.removeFavourite(widget.item.id);

      if (!mounted) return;

      setState(() {
        widget.item.userData = newUserData;
      });
    } catch (e) {
      setState(() {
        widget.item.userData!.isFavorite = !widget.item.userData!.isFavorite;
      });
      errorSnackbar(e, context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      DraggableScrollableSheet(
        snap: true,
        initialChildSize: 0.45,
        minChildSize: 0.25,
        expand: false,
        builder: (context, scrollController) {
          return CustomScrollView(
            controller: scrollController,
            physics: const ClampingScrollPhysics(),
            slivers: [
              SliverPersistentHeader(
                delegate: SongMenuSliverAppBar(item: widget.item),
                pinned: true,
              ),
              SliverList(
                delegate: SliverChildListDelegate([
                  ListTile(
                    leading: const Icon(Icons.queue_music),
                    title: Text(AppLocalizations.of(context)!.addToQueue),
                    onTap: () async {
                      await _queueService.addToQueue(items: [widget.item], source: QueueItemSource(type: QueueItemSourceType.allSongs, name: QueueItemSourceName(type: QueueItemSourceNameType.preTranslated, pretranslatedName: widget.item.name), id: widget.item.id));

                      if (!mounted) return;

                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content:
                            Text(AppLocalizations.of(context)!.addedToQueue),
                      ));
                      Navigator.pop(context);
                    },
                  ),
                  widget.isInPlaylist
                      ? Visibility(
                          visible: !widget.isOffline,
                          child: ListTile(
                            leading: const Icon(Icons.playlist_remove),
                            title: Text(AppLocalizations.of(context)!
                                .removeFromPlaylistTitle),
                            enabled:
                                !widget.isOffline && widget.parentId != null,
                            onTap: () async {
                              try {
                                await _jellyfinApiHelper
                                    .removeItemsFromPlaylist(
                                        playlistId: widget.parentId!,
                                        entryIds: [
                                      widget.item.playlistItemId!
                                    ]);

                                if (!mounted) return;

                                await _jellyfinApiHelper.getItems(
                                  parentItem: await _jellyfinApiHelper
                                      .getItemById(widget.item.parentId!),
                                  sortBy:
                                      "ParentIndexNumber,IndexNumber,SortName",
                                  includeItemTypes: "Audio",
                                  isGenres: false,
                                );

                                if (!mounted) return;

                                if (widget.onDelete != null) widget.onDelete!();

                                ScaffoldMessenger.of(context)
                                    .showSnackBar(SnackBar(
                                  content: Text(AppLocalizations.of(context)!
                                      .removedFromPlaylist),
                                ));
                                Navigator.pop(context);
                              } catch (e) {
                                errorSnackbar(e, context);
                              }
                            },
                          ),
                        )
                      : Visibility(
                          visible: !widget.isOffline,
                          child: ListTile(
                            leading: const Icon(Icons.playlist_add),
                            title: Text(AppLocalizations.of(context)!
                                .addToPlaylistTitle),
                            enabled: !widget.isOffline,
                            onTap: () {
                              Navigator.of(context).pushNamed(
                                  AddToPlaylistScreen.routeName,
                                  arguments: widget.item.id);
                            },
                          ),
                        ),
                  Visibility(
                    visible: !widget.isOffline,
                    child: ListTile(
                      leading: const Icon(Icons.explore),
                      title: Text(AppLocalizations.of(context)!.instantMix),
                      enabled: !widget.isOffline,
                      onTap: () async {
                        await _audioServiceHelper
                            .startInstantMixForItem(widget.item);

                        if (!mounted) return;

                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text(
                              AppLocalizations.of(context)!.startingInstantMix),
                        ));
                        Navigator.pop(context);
                      },
                    ),
                  ),
                  Visibility(
                    visible: widget.canGoToAlbum,
                    child: ListTile(
                      leading: const Icon(Icons.album),
                      title: Text(AppLocalizations.of(context)!.goToAlbum),
                      enabled: widget.canGoToAlbum,
                      onTap: () async {
                        late BaseItemDto album;
                        if (FinampSettingsHelper.finampSettings.isOffline) {
                          // If offline, load the album's BaseItemDto from DownloadHelper.
                          final downloadsHelper =
                              GetIt.instance<DownloadsHelper>();

                          // downloadedParent won't be null here since the menu item already
                          // checks if the DownloadedParent exists.
                          album = downloadsHelper
                              .getDownloadedParent(widget.item.parentId!)!
                              .item;
                        } else {
                          // If online, get the album's BaseItemDto from the server.
                          try {
                            album = await _jellyfinApiHelper
                                .getItemById(widget.item.parentId!);
                          } catch (e) {
                            errorSnackbar(e, context);
                            return;
                          }
                        }
                        if (mounted) {
                          Navigator.of(context).pushNamed(AlbumScreen.routeName,
                              arguments: album);
                        }
                      },
                    ),
                  ),
                  widget.item.userData!.isFavorite
                      ? ListTile(
                          leading: const Icon(Icons.favorite_border),
                          title: Text(
                              AppLocalizations.of(context)!.removeFavourite),
                          onTap: () async {
                            await setFavourite();
                            if (mounted) Navigator.pop(context);
                          },
                        )
                      : ListTile(
                          leading: const Icon(Icons.favorite),
                          title:
                              Text(AppLocalizations.of(context)!.addFavourite),
                          onTap: () async {
                            await setFavourite();
                            if (mounted) Navigator.pop(context);
                          },
                        ),
                ]),
              )
            ],
          );
        },
      ),
    ]);
  }
}

class SongMenuSliverAppBar extends SliverPersistentHeaderDelegate {
  BaseItemDto item;

  SongMenuSliverAppBar({required this.item});

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return _SongInfo(item: item);
  }

  @override
  double get maxExtent => 150;

  @override
  double get minExtent => 100;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) =>
      true;
}

class _SongInfo extends StatefulWidget {
  const _SongInfo({required this.item});

  final BaseItemDto item;

  @override
  State<_SongInfo> createState() => _SongInfoState();
}

class _SongInfoState extends State<_SongInfo> {
  ColorScheme? _imageColorScheme;

  @override
  Widget build(BuildContext context) {
    return Container(
      // I'd rather use a theme here, but that would require splitting this
      // widget
      color: _imageColorScheme?.primary,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          AlbumImage(
            borderRadius: BorderRadius.zero,
            item: widget.item,
            imageProviderCallback: (imageProvider) async {
              if (_imageColorScheme == null && imageProvider != null) {
                final theme = Theme.of(context);

                final paletteGenerator =
                    await PaletteGenerator.fromImageProvider(imageProvider);

                final accent = paletteGenerator.dominantColor!.color;

                final newColorScheme = ColorScheme.fromSwatch(
                  primarySwatch: generateMaterialColor(accent),
                  accentColor: accent,
                  brightness: theme.brightness,
                );

                setState(() {
                  _imageColorScheme = newColorScheme;
                });
              }
            },
          ),
          Expanded(
            child: Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 0, 0),
                child: Column(
                  children: [
                    if (widget.item.name != null)
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(0, 0, 0, 8),
                          child: Text(
                            widget.item.name!,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 20,
                              height: 24 / 20,
                              // Show black text on white backgrounds, and
                              // vice-versa
                              color: (_imageColorScheme?.primary
                                              .computeLuminance() ??
                                          0) >
                                      0.5
                                  ? Colors.black
                                  : Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                            overflow: TextOverflow.fade,
                            softWrap: true,
                            maxLines: 2,
                          ),
                        ),
                      ),
                    if (widget.item.album != null)
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4),
                          child: ArtistChips(
                            baseItem: widget.item,
                            color: Colors.white.withOpacity(0.1),
                          )
                        ),
                      ),
                    if (widget.item.artists != null)
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4),
                          child: AlbumChip(
                            item: widget.item,
                            key: widget.item.album == null
                                ? null
                                : ValueKey("${widget.item.album}-album"),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
