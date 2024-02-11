import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get_it/get_it.dart';

import '../../models/jellyfin_models.dart';
import '../../screens/artist_screen.dart';
import '../../services/finamp_settings_helper.dart';
import '../../services/isar_downloads.dart';
import '../../services/jellyfin_api_helper.dart';
import '../album_image.dart';

const _radius = Radius.circular(4);
const _borderRadius = BorderRadius.all(_radius);
const _height = 24.0; // I'm sure this magic number will work on all devices
final _defaultBackgroundColour = Colors.white.withOpacity(0.1);

class ArtistChips extends StatelessWidget {
  const ArtistChips({
    super.key,
    this.backgroundColor,
    this.color,
    this.baseItem,
    this.useAlbumArtist = false,
  });

  final BaseItemDto? baseItem;
  final Color? backgroundColor;
  final Color? color;
  final bool useAlbumArtist;

  @override
  Widget build(BuildContext context) {
    final artists =
        useAlbumArtist ? baseItem?.albumArtists : baseItem?.artistItems;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Wrap(
          spacing: 4.0,
          runSpacing: 4.0,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: List.generate(artists?.length ?? 0, (index) {
            final currentArtist = artists![index];

            return ArtistChip(
              backgroundColor: backgroundColor,
              color: color,
              artist: BaseItemDto(
                id: currentArtist.id,
                name: currentArtist.name,
                type: "MusicArtist",
              ),
            );
          }),
        ),
      ),
    );
  }
}

class ArtistChip extends StatefulWidget {
  const ArtistChip({
    Key? key,
    this.backgroundColor,
    this.color,
    this.artist,
  }) : super(key: key);

  final BaseItemDto? artist;
  final Color? backgroundColor;
  final Color? color;

  @override
  State<ArtistChip> createState() => _ArtistChipState();
}

class _ArtistChipState extends State<ArtistChip> {
  final _jellyfinApiHelper = GetIt.instance<JellyfinApiHelper>();
  final _isarDownloader = GetIt.instance<IsarDownloads>();

  // We make the future nullable since if the item is null it is not initialised
  // in initState.
  Future<BaseItemDto>? _artistChipFuture;

  @override
  void initState() {
    super.initState();

    if (widget.artist != null) {
      final albumArtistId = widget.artist!.id;

      _artistChipFuture = FinampSettingsHelper.finampSettings.isOffline
          ? _isarDownloader
              .getCollectionInfo(id: albumArtistId)
              .then((value) => value!.baseItem!)
          : _jellyfinApiHelper.getItemById(albumArtistId);
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<BaseItemDto>(
        future: _artistChipFuture,
        builder: (context, snapshot) {
          final backgroundColor =
              widget.backgroundColor ?? _defaultBackgroundColour;
          final color = widget.color ??
              Theme.of(context).textTheme.bodySmall?.color ??
              Colors.white;
          return _ArtistChipContent(
            item: snapshot.data ?? widget.artist!,
            backgroundColor: backgroundColor,
            color: color,
          );
        });
  }
}

class _ArtistChipContent extends StatelessWidget {
  const _ArtistChipContent({
    super.key,
    required this.item,
    required this.backgroundColor,
    required this.color,
  });

  final BaseItemDto item;
  final Color backgroundColor;
  final Color color;

  @override
  Widget build(BuildContext context) {
    // We do this so that we can pass the song item here to show an actual value
    // instead of empty
    final name =
        item.isArtist ? item.name : (item.artists?.first ?? item.albumArtist);

    return SizedBox(
      height: _height,
      child: Material(
        color: backgroundColor,
        borderRadius: _borderRadius,
        child: InkWell(
          // We shouldn't click through to artists if not passed one
          onTap: !item.isArtist
              ? null
              : () => Navigator.of(context)
                  .pushNamed(ArtistScreen.routeName, arguments: item),
          borderRadius: _borderRadius,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (item.isArtist && item.imageId != null)
                AlbumImage(
                  item: item,
                  borderRadius: const BorderRadius.only(
                    topLeft: _radius,
                    bottomLeft: _radius,
                  ),
                ),
              Center(
                child: Container(
                  constraints: const BoxConstraints(maxWidth: 220),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 6),
                    child: Text(
                      name ?? AppLocalizations.of(context)!.unknownArtist,
                      style: TextStyle(
                          color: color, overflow: TextOverflow.ellipsis),
                      softWrap: false,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
