import 'package:finamp/l10n/app_localizations.dart';
import 'package:finamp/services/finamp_settings_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';

import '../../models/jellyfin_models.dart';
import '../../screens/artist_screen.dart';
import '../../services/jellyfin_api_helper.dart';
import '../icon_and_text.dart';

class ArtistItemInfo extends ConsumerWidget {
  const ArtistItemInfo({
    super.key,
    required this.item,
    required this.itemTracks,
    required this.itemAlbums,
    this.genreFilter,
    required this.resetGenreFilter,
  });

  final BaseItemDto item;
  final int itemTracks;
  final int itemAlbums;
  final String? genreFilter;
  final VoidCallback resetGenreFilter;

// TODO: see if there's a way to expand this column to the row that it's in
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconAndText(
            iconData: Icons.music_note,
            textSpan: TextSpan(
              text: ref.watch(finampSettingsProvider.isOffline)
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
          _GenreIconAndText(
              genres: item.genreItems!,
              genreFilter: genreFilter,
              resetGenreFilter: resetGenreFilter
          )
      ],
    );
  }
}

class _GenreIconAndText extends StatelessWidget {
  const _GenreIconAndText({
    required this.genres,
    this.genreFilter,
    required this.resetGenreFilter
  });

  final List<NameLongIdPair> genres;
  final String? genreFilter;
  final VoidCallback resetGenreFilter;

  @override
  Widget build(BuildContext context) {
    final jellyfinApiHelper = GetIt.instance<JellyfinApiHelper>();
    final filteredGenres = genreFilter != null
        ? genres.where((g) => g.id == genreFilter).toList()
        : genres;
    final genreNames = filteredGenres.map((g) => g.name).join(", ");

    Widget content = IconAndText(
      iconData: Icons.album,
      textSpan: TextSpan(
        text: "$genreNames",
        style: (genreFilter != null)
            ? TextStyle(color: Theme.of(context).colorScheme.onPrimary)
            : null,
      ),
      iconColor: (genreFilter != null)
            ? Theme.of(context).colorScheme.onPrimary
            : null,
    );

    if (genreFilter != null) {
      return Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primary,
          borderRadius: BorderRadius.circular(6),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 1),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(child: content),
            GestureDetector(
              onTap: () {
                resetGenreFilter();
              },
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 1),
                child: Icon(
                  Icons.close,
                  size: 18,
                  color: Theme.of(context).colorScheme.onPrimary,
                ),
              ),
            ),
          ],
        ),
      );
    } else {
      return GestureDetector(
        onTap: () => jellyfinApiHelper
            .getItemById(filteredGenres.first.id)
            .then((artist) => Navigator.of(context)
                .pushNamed(ArtistScreen.routeName, arguments: artist)),
        child: content,
      );
    }
  }
}