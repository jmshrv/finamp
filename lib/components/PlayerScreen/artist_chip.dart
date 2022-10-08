import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get_it/get_it.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../models/jellyfin_models.dart';
import '../../screens/artist_screen.dart';
import '../../services/finamp_settings_helper.dart';
import '../../services/jellyfin_api_helper.dart';
import '../album_image.dart';

const _radius = Radius.circular(4);
const _borderRadius = BorderRadius.all(_radius);
const _height = 24.0;
final _colour = Colors.white.withOpacity(0.1);

class ArtistChip extends StatefulWidget {
  ArtistChip({
    Key? key,
    this.item,
  }) : super(key: key);

  final BaseItemDto? item;

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
        if (snapshot.data == null) return const _EmptyArtistChip();

        return _ArtistChipContent(item: snapshot.data!);
      },
    );
  }
}

class _EmptyArtistChip extends StatelessWidget {
  const _EmptyArtistChip({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: _height,
      width: 72,
      child: Material(
        color: _colour,
        borderRadius: _borderRadius,
      ),
    );
  }
}

class _ArtistChipContent extends StatelessWidget {
  const _ArtistChipContent({
    Key? key,
    required this.item,
  }) : super(key: key);

  final BaseItemDto item;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: _height,
      child: Material(
        color: _colour,
        borderRadius: _borderRadius,
        child: InkWell(
          onTap: FinampSettingsHelper.finampSettings.isOffline
              ? null
              : () => Navigator.of(context)
                  .popAndPushNamed(ArtistScreen.routeName, arguments: item),
          borderRadius: _borderRadius,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (item.imageId != null)
                AlbumImage(
                  item: item,
                  borderRadius: const BorderRadius.only(
                    topLeft: _radius,
                    bottomLeft: _radius,
                  ),
                ),
              Center(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 6, vertical: 4.5),
                  child: Text(
                      item.name ?? AppLocalizations.of(context)!.unknownArtist,
                      style: GoogleFonts.lexendDeca(
                        fontSize: 12,
                        height: 15 / 12,
                      )),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
