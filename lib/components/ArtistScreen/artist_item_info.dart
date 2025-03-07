import 'package:finamp/services/finamp_settings_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get_it/get_it.dart';

import '../../models/jellyfin_models.dart';
import '../../screens/artist_screen.dart';
import '../../services/jellyfin_api_helper.dart';
import '../icon_and_text.dart';

class ArtistItemInfo extends StatelessWidget {
  const ArtistItemInfo({
    super.key,
    required this.item,
    required this.itemTracks,
    required this.itemAlbums,
  });

  final BaseItemDto item;
  final int itemTracks;
  final int itemAlbums;

// TODO: see if there's a way to expand this column to the row that it's in
  @override
  Widget build(BuildContext context) {
    bool isOffline = FinampSettingsHelper.finampSettings.isOffline;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconAndText(
            iconData: Icons.music_note,
            textSpan: TextSpan(
              text: isOffline
                  ? AppLocalizations.of(context)!
                      .offlineTrackCountArtist(itemTracks)
                  : AppLocalizations.of(context)!.trackCount(itemTracks),
            )),
        IconAndText(
            iconData: Icons.book,
            textSpan: TextSpan(
              text: AppLocalizations.of(context)!.albumCount(itemAlbums),
            )),
        if (item.type != "MusicGenre" &&
            item.genreItems != null &&
            item.genreItems!.isNotEmpty)
          _GenreIconAndText(genres: item.genreItems!)
      ],
    );
  }
}

class _GenreIconAndText extends StatelessWidget {
  const _GenreIconAndText({required this.genres});

  final List<NameLongIdPair> genres;

  @override
  Widget build(BuildContext context) {
    final jellyfinApiHelper = GetIt.instance<JellyfinApiHelper>();

    return GestureDetector(
      onTap: () => jellyfinApiHelper.getItemById(genres.first.id).then(
          (artist) => Navigator.of(context)
              .pushNamed(ArtistScreen.routeName, arguments: artist)),
      child: IconAndText(
        iconData: Icons.album,
        textSpan: TextSpan(
          text: genres.map((genre) => genre.name).join(", "),
        ),
      ),
    );
  }
}
