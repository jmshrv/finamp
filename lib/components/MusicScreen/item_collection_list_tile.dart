import 'dart:io';

import 'package:finamp/components/favorite_button.dart';
import 'package:finamp/components/print_duration.dart';
import 'package:finamp/services/finamp_settings_helper.dart';
import 'package:finamp/services/finamp_user_helper.dart';
import 'package:finamp/services/datetime_helper.dart';
import 'package:flutter/material.dart';
import 'package:finamp/l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:get_it/get_it.dart';

import '../../models/finamp_models.dart';
import '../../models/jellyfin_models.dart';
import '../../services/generate_subtitle.dart';
import '../../services/jellyfin_api_helper.dart';
import '../AlbumScreen/downloaded_indicator.dart';
import '../album_image.dart';

/// ListTile content for CollectionItem. You probably shouldn't use this widget
/// directly, use CollectionItem instead.
class ItemCollectionListTile extends ConsumerWidget {
  const ItemCollectionListTile({
    super.key,
    required this.item,
    this.parentType,
    this.onTap,
    this.albumShowsYearAndDurationInstead = false,
    this.showAdditionalInfoForSortBy,
    this.showFavoriteIconOnlyWhenFilterDisabled = false,
  });

  final BaseItemDto item;
  final String? parentType;
  final void Function()? onTap;
  final bool albumShowsYearAndDurationInstead;
  final SortBy? showAdditionalInfoForSortBy;
  final bool showFavoriteIconOnlyWhenFilterDisabled;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final jellyfinApiHelper = GetIt.instance<JellyfinApiHelper>();
    final finampUserHelper = GetIt.instance<FinampUserHelper>();
    final library = finampUserHelper.currentUser?.currentView;
    final itemType = BaseItemDtoType.fromItem(item);
    final isArtistOrGenre = (itemType == BaseItemDtoType.artist ||
            itemType == BaseItemDtoType.genre);
    final isOnDesktop = Platform.isMacOS || Platform.isWindows || Platform.isLinux;
    final subtitle = (itemType != BaseItemDtoType.album || !albumShowsYearAndDurationInstead)
        ? generateSubtitle(
            item: item,
            parentType: parentType,
            context: context,
            artistType: ref.watch(finampSettingsProvider.artistListType),
          ) : null;
    final itemDownloadStub = isArtistOrGenre
          ? DownloadStub.fromFinampCollection(
                FinampCollection(
                  type: FinampCollectionType.collectionWithLibraryFilter,
                  library: library,
                  item: item
                )
            )
          : DownloadStub.fromItem(
                type: DownloadItemType.collection,
                item: item
            );
    final downloadedIndicator = DownloadedIndicator(
      item: itemDownloadStub,
      size: Theme.of(context).textTheme.bodyMedium!.fontSize! + 1,
    );
    final titleText = Text(
      item.name ?? AppLocalizations.of(context)!.unknownName,
      overflow: TextOverflow.ellipsis,
    );

    final sortIconMeta = {
      SortBy.runtime: (
        icon: TablerIcons.stopwatch,
        offset: isOnDesktop ? Offset(-1.5, 1.2) : Offset(-1.5, 0.5),
      ),
      SortBy.dateCreated: (
        icon: TablerIcons.calendar_plus,
        offset: isOnDesktop ? Offset(-1.5, 1.0) : Offset(-1.5, 0.2),
      ),
    };

    WidgetSpan? buildAdditionalInfoIcon(SortBy? sortBy) {
      if (sortBy == null) return null;
      final meta = sortIconMeta[sortBy];
      if (meta == null) return null;

      final textTheme = Theme.of(context).textTheme.bodyMedium!;
      final color = textTheme.color!.withOpacity(0.7);

      return WidgetSpan(
        alignment: PlaceholderAlignment.baseline,
        baseline: TextBaseline.alphabetic,
        child: Padding(
          padding: const EdgeInsets.only(right: 3),
          child: Transform.translate(
            offset: meta.offset,
            child: Icon(
              meta.icon,
              size: Theme.of(context)
                      .textTheme
                      .bodyMedium!
                      .fontSize! + 1,
              color: color,
            ),
          ),
        ),
      );
    }

    final additionalInfoIcon = buildAdditionalInfoIcon(showAdditionalInfoForSortBy);

    final additionalInfo = (() {
      final l10n = AppLocalizations.of(context)!;
      if ((itemType == BaseItemDtoType.album && albumShowsYearAndDurationInstead) ||
          showAdditionalInfoForSortBy == SortBy.premiereDate) {
        return TextSpan(
          text: ReleaseDateHelper.autoFormat(item) ?? l10n.noReleaseDate,
          style: TextStyle(
            color: Theme.of(context).textTheme.bodyMedium?.color?.withOpacity(0.7),
          ),
        );
      }
      switch (showAdditionalInfoForSortBy) {
        case SortBy.runtime:
          return TextSpan(
            text: printDuration(item.runTimeTicksDuration()),
            style: TextStyle(
              color: Theme.of(context).textTheme.bodyMedium?.color?.withOpacity(0.7),
            ),
          );
        case SortBy.dateCreated:
          return WidgetSpan(
            alignment: PlaceholderAlignment.baseline,
            baseline: TextBaseline.alphabetic,
            child: RelativeDateTimeTextFromString(
              dateString: item.dateCreated,
              fallback: l10n.noDateAdded,
              style: TextStyle(
                color: Theme.of(context).textTheme.bodyMedium?.color?.withOpacity(0.7),
              ),
              disableTextScaling: true,
            ),
          );
        default:
          return null;
      }
    })();

    final showSubtitle = (subtitle != null || 
        (itemType == BaseItemDtoType.album && albumShowsYearAndDurationInstead) || 
        (additionalInfo != null) ||
        downloadedIndicator.isVisible(ref));
    final subtitleText = Text.rich(
      TextSpan(
        children: [
          WidgetSpan(
            child: Transform.translate(
              offset: isOnDesktop ? Offset(-3, 1.3) : Offset(-3, 0.4),
              child: downloadedIndicator,
            ),
            alignment: PlaceholderAlignment.baseline,
            baseline: TextBaseline.alphabetic,
          ),
          if (downloadedIndicator.isVisible(ref))
              WidgetSpan(child: SizedBox(width: (additionalInfo != null) ? 5.0 : 2.0)),
          if (downloadedIndicator.isVisible(ref) && additionalInfoIcon != null)
              WidgetSpan(child: SizedBox(width: 2.25)),
          if (additionalInfo != null) ...[
            if (additionalInfoIcon != null)
              additionalInfoIcon,
            additionalInfo,
            TextSpan(
              text: (itemType == BaseItemDtoType.album && albumShowsYearAndDurationInstead)
                ? " · ${printDuration(item.runTimeTicksDuration())}"
                : (subtitle != null)
                  ? " · $subtitle"
                  : null,
              style: TextStyle(color: Theme.of(context).disabledColor),
            ),
          ] else ...[
            TextSpan(
              text: subtitle,
              style: TextStyle(color: Theme.of(context).disabledColor),
            ),
          ],
        ],
      ),
      overflow: TextOverflow.ellipsis,
    );

    return ListTile(
        // This widget is used on the add to playlist screen, so we allow a custom
        // onTap to be passed as an argument.
        contentPadding: EdgeInsets.symmetric(
          horizontal: 16.0,
          vertical: !showSubtitle ? 8.0 : 0.0,
        ),
        onTap: onTap,
        leading: AlbumImage(item: item),
        title: titleText,
        subtitle: (showSubtitle) ? subtitleText : null,
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            if ((itemType == BaseItemDtoType.artist
                    ? jellyfinApiHelper.selectedMixArtists
                    : (itemType == BaseItemDtoType.genre)
                        ? jellyfinApiHelper.selectedMixGenres
                        : jellyfinApiHelper.selectedMixAlbums)
                .contains(item))
              const Icon(Icons.explore),
            FavoriteButton(
              item: item,
              onlyIfFav: true,
              showFavoriteIconOnlyWhenFilterDisabled: showFavoriteIconOnlyWhenFilterDisabled,
            )
          ],
        ),
    );
  }
}