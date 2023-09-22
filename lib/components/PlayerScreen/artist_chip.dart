import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get_it/get_it.dart';

import '../../models/jellyfin_models.dart';
import '../../screens/artist_screen.dart';
import '../../services/finamp_settings_helper.dart';
import '../../services/jellyfin_api_helper.dart';
import '../album_image.dart';

const _radius = Radius.circular(4);
const _borderRadius = BorderRadius.all(_radius);
const _height = 24.0; // I'm sure this magic number will work on all devices
final _defaultColour = Colors.white.withOpacity(0.1);
const _textStyle = TextStyle(
  overflow: TextOverflow.fade,
);

class ArtistChip extends StatefulWidget {
  const ArtistChip({
    Key? key,
    this.color,
    this.item,
  }) : super(key: key);

  final BaseItemDto? item;
  final Color? color;

  @override
  State<ArtistChip> createState() => _ArtistChipState();
}

class _ArtistChipState extends State<ArtistChip> {
  final _jellyfinApiHelper = GetIt.instance<JellyfinApiHelper>();

  // We make the future nullable since if the item is null it is not initialised
  // in initState.
  Future<BaseItemDto>? _artistChipFuture;

  @override
  void initState() {
    super.initState();

    if (widget.item != null) {
      final albumArtistId = widget.item!.albumArtists?.first.id;

      if (albumArtistId != null) {
        // This is a terrible hack but since offline artists aren't yet
        // implemented it's kind of needed. When offline, we make a fake item
        // with the required amount of data to show an artist chip.
        _artistChipFuture = FinampSettingsHelper.finampSettings.isOffline
            ? Future.sync(
                () => BaseItemDto(
                  id: widget.item!.id,
                  name: widget.item!.albumArtist,
                  type: "MusicArtist",
                ),
              )
            : _jellyfinApiHelper.getItemById(albumArtistId);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_artistChipFuture == null) return const _EmptyArtistChip();

    return FutureBuilder<BaseItemDto>(
      future: _artistChipFuture,
      builder: (context, snapshot) {
        final color = widget.color ?? _defaultColour;
        return _ArtistChipContent(item: snapshot.data ?? widget.item!, color: color);
      }
    );
  }
}

class _EmptyArtistChip extends StatelessWidget {
  const _EmptyArtistChip({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      height: _height,
      width: 72,
      child: Material(
        borderRadius: _borderRadius,
      ),
    );
  }
}

class _ArtistChipContent extends StatelessWidget {
  const _ArtistChipContent({
    Key? key,
    required this.item,
    required this.color,
  }) : super(key: key);

  final BaseItemDto item;
  final Color color;

  @override
  Widget build(BuildContext context) {
    // We do this so that we can pass the song item here to show an actual value
    // instead of empty
    final name = item.isArtist ? item.name : item.albumArtist;

    return SizedBox(
      height: 24,
      child: Material(
        color: color,
        borderRadius: _borderRadius,
        child: InkWell(
          // Offline artists aren't implemented and we shouldn't click through
          // to artists if not passed one
          onTap: FinampSettingsHelper.finampSettings.isOffline || !item.isArtist
              ? null
              : () => Navigator.of(context)
                  .popAndPushNamed(ArtistScreen.routeName, arguments: item),
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
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 6),
                  child: Text(
                    name ?? AppLocalizations.of(context)!.unknownArtist,
                    style: _textStyle,
                    softWrap: false,
                    overflow: TextOverflow.fade,
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
