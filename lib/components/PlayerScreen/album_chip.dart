import 'package:finamp/l10n/app_localizations.dart';
import 'package:finamp/services/release_date_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';

import '../../models/jellyfin_models.dart';
import '../../screens/album_screen.dart';
import '../../services/downloads_service.dart';
import '../../services/finamp_settings_helper.dart';
import '../../services/jellyfin_api_helper.dart';

final _borderRadius = BorderRadius.circular(4);

class AlbumChips extends ConsumerWidget {
  const AlbumChips({
    super.key,
    this.baseItem,
    this.backgroundColor,
    this.color,
    this.includeReleaseDate,
  });

  final BaseItemDto? baseItem;
  final Color? backgroundColor;
  final Color? color;
  final bool? includeReleaseDate;

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
            children: [
              AlbumChip(
                key: const ValueKey(null),
                backgroundColor: backgroundColor,
                color: color,
                item: baseItem,
              ),
              if (((includeReleaseDate ?? false) ||
                      (includeReleaseDate == null &&
                          ref.watch(finampSettingsProvider
                              .showAlbumReleaseDateOnPlayerScreen))) &&
                  ReleaseDateHelper.autoFormat(baseItem) != null)
                _ReleaseDateChip(
                  baseItem: baseItem,
                  backgroundColor: backgroundColor,
                  color: color,
                )
            ]),
      ),
    );
  }
}

class AlbumChip extends StatelessWidget {
  const AlbumChip({
    super.key,
    this.item,
    this.backgroundColor,
    this.color,
  });

  final BaseItemDto? item;
  final Color? backgroundColor;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    if (item == null) return const _EmptyAlbumChip();

    return Container(
        constraints: const BoxConstraints(minWidth: 10),
        child: _AlbumChipContent(
          item: item!,
          color: color,
          backgroundColor: backgroundColor,
        ));
  }
}

class _EmptyAlbumChip extends StatelessWidget {
  const _EmptyAlbumChip();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 64,
      height: 20,
      child: Material(
        borderRadius: _borderRadius,
      ),
    );
  }
}

class _ReleaseDateChip extends StatelessWidget {
  const _ReleaseDateChip({
    this.baseItem,
    this.backgroundColor,
    this.color,
  });

  final BaseItemDto? baseItem;
  final Color? backgroundColor;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final releaseDate = ReleaseDateHelper.autoFormat(baseItem);

    return Semantics.fromProperties(
      properties: SemanticsProperties(
        label: "Release date: $releaseDate",
        button: true,
      ),
      excludeSemantics: true,
      container: true,
      child: Material(
        color: backgroundColor ?? Colors.white.withOpacity(0.1),
        borderRadius: _borderRadius,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 4),
          child: Text(
            releaseDate ?? "Unknown",
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
    );
  }
}

class _AlbumChipContent extends StatelessWidget {
  const _AlbumChipContent({
    required this.item,
    required this.backgroundColor,
    required this.color,
  });

  final BaseItemDto item;
  final Color? backgroundColor;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final jellyfinApiHelper = GetIt.instance<JellyfinApiHelper>();
    final isarDownloader = GetIt.instance<DownloadsService>();

    final albumName = item.album ?? AppLocalizations.of(context)!.noAlbum;

    return Semantics.fromProperties(
      properties: SemanticsProperties(
        label: "$albumName (${AppLocalizations.of(context)!.album})",
        button: true,
      ),
      excludeSemantics: true,
      container: true,
      child: Material(
        color: backgroundColor ?? Colors.white.withOpacity(0.1),
        borderRadius: _borderRadius,
        child: InkWell(
          borderRadius: _borderRadius,
          onTap: FinampSettingsHelper.finampSettings.isOffline
              ? () => isarDownloader.getCollectionInfo(id: item.albumId!).then(
                  (album) => Navigator.of(context).pushNamed(
                      AlbumScreen.routeName,
                      arguments: album!.baseItem!))
              : () => jellyfinApiHelper.getItemById(item.albumId!).then(
                  (album) => Navigator.of(context)
                      .pushNamed(AlbumScreen.routeName, arguments: album)),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 4),
            child: Text(
              albumName,
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
