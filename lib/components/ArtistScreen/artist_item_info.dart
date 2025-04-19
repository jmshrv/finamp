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
    this.resetGenreFilter,
  });

  final BaseItemDto item;
  final int itemTracks;
  final int itemAlbums;
  final BaseItemDto? genreFilter;
  final VoidCallback? resetGenreFilter;

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
            resetGenreFilter != null &&
            ((item.genreItems != null && item.genreItems!.isNotEmpty) ||
            genreFilter != null))
          _GenreIconAndText(
              genres: item.genreItems!,
              genreFilter: genreFilter,
              resetGenreFilter: resetGenreFilter!
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
  final BaseItemDto? genreFilter;
  final VoidCallback resetGenreFilter;

  @override
  Widget build(BuildContext context) {
    final jellyfinApiHelper = GetIt.instance<JellyfinApiHelper>();
    
    final genreNames = genreFilter?.name ?? genres.map((g) => g.name).join(", ");
    final bool hasFilter = genreFilter != null;
    final theme = Theme.of(context);

    Widget content = IconAndText(
      iconData: Icons.album,
      textSpan: TextSpan(
        text: genreNames,
        style: hasFilter
            ? TextStyle(color: Theme.of(context).colorScheme.onPrimary)
            : null,
      ),
      iconColor: hasFilter
            ? theme.colorScheme.onPrimary
            : null,
    );

    if (hasFilter) {
      return Container(
        decoration: BoxDecoration(
          color: theme.colorScheme.primary,
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
                  color: theme.colorScheme.onPrimary,
                ),
              ),
            ),
          ],
        ),
      );
    } else {
      return GestureDetector(
        onTap: () => jellyfinApiHelper
            .getItemById(genres.first.id)
            .then((genre) => Navigator.of(context)
                .pushNamed(ArtistScreen.routeName, arguments: genre)),
        child: content,
      );
    }
  }
}