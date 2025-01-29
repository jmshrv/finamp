import 'package:finamp/models/jellyfin_models.dart' as jellyfin_models;
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get_it/get_it.dart';
import 'package:finamp/services/scrolling_text_helper.dart';
import 'package:marquee/marquee.dart';

import '../../models/jellyfin_models.dart';
import '../../screens/album_screen.dart';
import '../../services/downloads_service.dart';
import '../../services/finamp_settings_helper.dart';
import '../../services/jellyfin_api_helper.dart';

final _borderRadius = BorderRadius.circular(4);

class AlbumChip extends StatelessWidget {
  const AlbumChip({
    super.key,
    required this.item,
    required this.backgroundColor,
  });

  final jellyfin_models.BaseItemDto? item;
  final Color backgroundColor;

  @override
  Widget build(BuildContext context) {
    if (item?.album == null) return const SizedBox.shrink();

    // Calculate text width
    final textSpan = TextSpan(
      text: item?.album ?? '',
      style: Theme.of(context).textTheme.bodyMedium,
    );
    final textPainter = TextPainter(
      text: textSpan,
      textDirection: TextDirection.ltr,
    )..layout();

    final textWidth = textPainter.width + 24;
    final screenWidth = MediaQuery.of(context).size.width - 32;
    final shouldScroll = textWidth > screenWidth;

    return Container(
      height: 32,
      width: shouldScroll ? screenWidth : textWidth,
      decoration: BoxDecoration(
        color: backgroundColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Material(
        type: MaterialType.transparency,
        child: InkWell(
          borderRadius: BorderRadius.circular(4),
          onTap: () => Navigator.of(context).pushNamed(
            AlbumScreen.routeName,
            arguments: item?.albumId,
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Center(
              child: shouldScroll
                  ? Marquee(
                      text: item?.album ?? '',
                      style: Theme.of(context).textTheme.bodyMedium,
                      scrollAxis: Axis.horizontal,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      blankSpace: 50.0,
                      velocity: 30.0,
                      pauseAfterRound: const Duration(seconds: 1),
                      startAfter: const Duration(seconds: 1),
                      fadingEdgeStartFraction: 0.1,
                      fadingEdgeEndFraction: 0.1,
                    )
                  : Text(
                      item?.album ?? '',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
            ),
          ),
        ),
      ),
    );
  }
}

class _EmptyAlbumChip extends StatelessWidget {
  const _EmptyAlbumChip({Key? key}) : super(key: key);

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

class _AlbumChipContent extends StatelessWidget {
  const _AlbumChipContent({
    Key? key,
    required this.item,
    required this.backgroundColor,
    required this.color,
  }) : super(key: key);

  final BaseItemDto item;
  final Color? backgroundColor;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final jellyfinApiHelper = GetIt.instance<JellyfinApiHelper>();
    final _isarDownloader = GetIt.instance<DownloadsService>();

    return Material(
      color: backgroundColor ?? Colors.white.withOpacity(0.1),
      borderRadius: _borderRadius,
      child: InkWell(
        borderRadius: _borderRadius,
        onTap: FinampSettingsHelper.finampSettings.isOffline
            ? () => _isarDownloader.getCollectionInfo(id: item.albumId!).then(
                (album) => Navigator.of(context).pushNamed(
                    AlbumScreen.routeName,
                    arguments: album!.baseItem!))
            : () => jellyfinApiHelper.getItemById(item.albumId!).then((album) =>
                Navigator.of(context)
                    .pushNamed(AlbumScreen.routeName, arguments: album)),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 4),
          child: Text(
            item.album ?? AppLocalizations.of(context)!.noAlbum,
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
