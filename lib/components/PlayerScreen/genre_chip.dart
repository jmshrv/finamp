import 'package:finamp/screens/genre_screen.dart';
import 'package:finamp/services/downloads_service.dart';
import 'package:finamp/services/finamp_settings_helper.dart';
import 'package:finamp/services/jellyfin_api_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';

import '../../models/jellyfin_models.dart';


final _borderRadius = BorderRadius.circular(4);

class GenreChips extends ConsumerWidget {
  const GenreChips({
    super.key,
    required this.genres,
    this.backgroundColor,
    this.color,
    this.updateGenreFilter,
  });

  final List<NameLongIdPair> genres;
  final Color? backgroundColor;
  final Color? color;
  final void Function(BaseItemDto?)? updateGenreFilter;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Wrap(
            spacing: 4.0,
            runSpacing: 4.0,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: genres.map((genre) {
              return GenreChip(
                key: ValueKey(genre.id),
                backgroundColor: backgroundColor,
                color: color,
                genre: genre,
                updateGenreFilter: updateGenreFilter,
              );
            }).toList(),
        ),
      ),
    );
  }
}

class GenreChip extends StatelessWidget {
  const GenreChip({
    super.key,
    required this.genre,
    this.backgroundColor,
    this.color,
    this.updateGenreFilter,
  });

  final NameLongIdPair genre;
  final Color? backgroundColor;
  final Color? color;
  final void Function(BaseItemDto?)? updateGenreFilter;

  @override
  Widget build(BuildContext context) {
    return Container(
        constraints: const BoxConstraints(minWidth: 10),
        child: _GenreChipContent(
          genre: genre,
          color: color,
          backgroundColor: backgroundColor,
          updateGenreFilter: updateGenreFilter,
        ));
  }
}

class _GenreChipContent extends ConsumerWidget {
  const _GenreChipContent({
    required this.genre,
    this.backgroundColor,
    this.color,
    this.updateGenreFilter,
  });

  final NameLongIdPair genre;
  final Color? backgroundColor;
  final Color? color;
  final void Function(BaseItemDto?)? updateGenreFilter;

  void _handleGenreTap(BuildContext context, WidgetRef ref) {
    final isOffline = ref.watch(finampSettingsProvider.isOffline);
    final artistGenreChipsApplyFilter = ref.watch(finampSettingsProvider.artistGenreChipsApplyFilter);
    final jellyfinApiHelper = GetIt.instance<JellyfinApiHelper>();
    final isarDownloader = GetIt.instance<DownloadsService>();
    
    if (isOffline) {
      isarDownloader.getCollectionInfo(id: genre.id!).then((genreItem) {
        if (genreItem?.baseItem != null) {
          if (artistGenreChipsApplyFilter && updateGenreFilter != null) {
            return updateGenreFilter!(genreItem!.baseItem!);
          } else {
            Navigator.of(context).pushNamed(
              GenreScreen.routeName,
              arguments: genreItem!.baseItem!,
            );
          }
        }
      });
    } else {
      jellyfinApiHelper.getItemById(genre.id!).then((genreItem) {
        if (artistGenreChipsApplyFilter && updateGenreFilter != null) {
            return updateGenreFilter!(genreItem);
          } else {
            Navigator.of(context).pushNamed(
              GenreScreen.routeName,
              arguments: genreItem,
            );
          }
      });
    }
  }


  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final genreName = genre.name ?? "";

    return Semantics.fromProperties(
      properties: SemanticsProperties(
        label: genreName,
        button: true,
      ),
      excludeSemantics: true,
      container: true,
      child: Material(
        color: backgroundColor ?? Colors.white.withOpacity(0.1),
        borderRadius: _borderRadius,
        child: InkWell(
          borderRadius: _borderRadius,
          onTap: () => _handleGenreTap(context, ref),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 4),
            child: Text(
              genreName,
              overflow: TextOverflow.ellipsis,
              softWrap: false,
              style: TextStyle(
                color: color ??
                    Theme.of(context).textTheme.bodySmall!.color ??
                    Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
