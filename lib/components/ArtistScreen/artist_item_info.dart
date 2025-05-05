import 'package:finamp/components/PlayerScreen/genre_chip.dart';
import 'package:finamp/l10n/app_localizations.dart';
import 'package:finamp/services/finamp_settings_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';

import '../../models/jellyfin_models.dart';
import '../icon_and_text.dart';

class ArtistItemInfo extends ConsumerWidget {
  const ArtistItemInfo({
    super.key,
    required this.item,
    required this.itemTracks,
    required this.itemAlbums,
    this.genreFilter,
    this.updateGenreFilter,
  });

  final BaseItemDto item;
  final int itemTracks;
  final int itemAlbums;
  final BaseItemDto? genreFilter;
  final void Function(BaseItemDto?)? updateGenreFilter;

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
            iconData: TablerIcons.disc,
            textSpan: TextSpan(
              text: AppLocalizations.of(context)!.albumCount(itemAlbums),
            )),
        if (item.type != "MusicGenre" &&
            updateGenreFilter != null &&
            ((item.genreItems != null && item.genreItems!.isNotEmpty) ||
            genreFilter != null))
          _GenreIconAndText(
              genres: item.genreItems!,
              genreFilter: genreFilter,
              updateGenreFilter: updateGenreFilter!
          )
      ],
    );
  }
}

class _GenreIconAndText extends StatelessWidget {
  const _GenreIconAndText({
    required this.genres,
    this.genreFilter,
    required this.updateGenreFilter
  });

  final List<NameLongIdPair> genres;
  final BaseItemDto? genreFilter;
  final void Function(BaseItemDto?) updateGenreFilter;

  @override
  Widget build(BuildContext context) {
    final bool hasFilter = genreFilter != null;
    final theme = Theme.of(context);

    return Container(
      decoration: hasFilter
          ? BoxDecoration(
              color: theme.colorScheme.primary,
              borderRadius: BorderRadius.circular(6),
            )
          : null,
      padding: const EdgeInsets.symmetric(horizontal: 1),
      child: Row(
        children: [
          Icon(
            TablerIcons.color_swatch,
            color: hasFilter
                ? theme.colorScheme.onPrimary
                : theme.iconTheme.color?.withOpacity(
                    theme.brightness == Brightness.light ? 0.38 : 0.5,
                  ),
          ),
          const SizedBox(width: 4),
          Expanded(
            child: hasFilter
                ? Padding(
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    child: Text(
                      genreFilter?.name ?? "Unknown Genre",
                      style: TextStyle(color: theme.colorScheme.onPrimary),
                      overflow: TextOverflow.ellipsis,
                    ),
                  )
                : GenreChips(
                    genres: genres,
                    backgroundColor:
                      IconTheme.of(context).color!.withOpacity(0.1),
                    updateGenreFilter: updateGenreFilter,
                  ),
          ),
          if (hasFilter)
            GestureDetector(
              onTap: () {
                updateGenreFilter(null);
              },
              child: Padding(
                padding: const EdgeInsets.only(left: 4, right: 2),
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
  }
}