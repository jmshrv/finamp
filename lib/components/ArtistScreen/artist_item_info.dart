import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get_it/get_it.dart';

import '../../models/jellyfin_models.dart';
import '../../screens/artist_screen.dart';
import '../../services/jellyfin_api_helper.dart';
import '../../services/process_artist.dart';
import '../icon_and_text.dart';
import '../print_duration.dart';

class ArtistItemInfo extends StatelessWidget {
  const ArtistItemInfo({
    Key? key,
    required this.item,
    required this.itemSongs,
    required this.itemAlbums,
  }) : super(key: key);

  final BaseItemDto item;
  final int itemSongs;
  final int itemAlbums;

// TODO: see if there's a way to expand this column to the row that it's in
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconAndText(
            iconData: Icons.music_note,
            text: AppLocalizations.of(context)!.songCount(itemSongs)),
        IconAndText(
            iconData: Icons.book,
            text: AppLocalizations.of(context)!.albumCount(itemAlbums)),
        if (item.type != "MusicGenre" &&
            item.genreItems != null &&
            item.genreItems!.isNotEmpty)
          _GenreIconAndText(genres: item.genreItems!)
      ],
    );
  }
}

class _GenreIconAndText extends StatelessWidget {
  const _GenreIconAndText({Key? key, required this.genres}) : super(key: key);

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
        text: genres.map((genre) => genre.name).join(", "),
      ),
    );
  }
}
