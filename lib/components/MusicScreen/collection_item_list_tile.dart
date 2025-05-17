import 'package:finamp/components/favorite_button.dart';
import 'package:finamp/components/print_duration.dart';
import 'package:finamp/services/finamp_user_helper.dart';
import 'package:finamp/services/release_date_helper.dart';
import 'package:flutter/material.dart';
import 'package:finamp/l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';

import '../../models/finamp_models.dart';
import '../../models/jellyfin_models.dart';
import '../../services/generate_subtitle.dart';
import '../../services/jellyfin_api_helper.dart';
import '../AlbumScreen/downloaded_indicator.dart';
import '../album_image.dart';

/// ListTile content for CollectionItem. You probably shouldn't use this widget
/// directly, use CollectionItem instead.
class CollectionItemListTile extends ConsumerWidget {
  const CollectionItemListTile({
    super.key,
    required this.item,
    this.parentType,
    this.onTap,
    this.albumShowsYearAndDurationInstead = false,
    this.showFavoriteIconOnlyWhenFilterDisabled = false,
  });

  final BaseItemDto item;
  final String? parentType;
  final void Function()? onTap;
  final bool albumShowsYearAndDurationInstead;
  final bool showFavoriteIconOnlyWhenFilterDisabled;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final jellyfinApiHelper = GetIt.instance<JellyfinApiHelper>();
    final finampUserHelper = GetIt.instance<FinampUserHelper>();
    final library = finampUserHelper.currentUser?.currentView;
    final itemType = BaseItemDtoType.fromItem(item);
    final isArtistOrGenre = (itemType == BaseItemDtoType.artist ||
            itemType == BaseItemDtoType.genre);
    final subtitle = (itemType != BaseItemDtoType.album || !albumShowsYearAndDurationInstead)
        ? generateSubtitle(item, parentType, context) : null;
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
      size: Theme.of(context).textTheme.bodyMedium!.fontSize! + 3,
    );
    final titleText = Text(
      item.name ?? AppLocalizations.of(context)!.unknownName,
      overflow: TextOverflow.ellipsis,
    );
    final showSubtitle = (subtitle != null || 
        (itemType == BaseItemDtoType.album && albumShowsYearAndDurationInstead) || 
        downloadedIndicator.isVisible(ref));
    final releaseDate = ReleaseDateHelper.autoFormat(item) ?? AppLocalizations.of(context)!.noReleaseDate;
    final subtitleText = Text.rich(
      TextSpan(
        children: [
          WidgetSpan(
            child: Transform.translate(
              offset: const Offset(-3, 0),
              child: downloadedIndicator,
            ),
            alignment: PlaceholderAlignment.top,
          ),
          if (itemType == BaseItemDtoType.album && albumShowsYearAndDurationInstead) ...[
            TextSpan(
              text: releaseDate,
              style: TextStyle(
                color: Theme.of(context)
                    .textTheme
                    .bodyMedium
                    ?.color
                    ?.withOpacity(0.7),
              ),
            ),
            TextSpan(
              text: " · ${printDuration(item.runTimeTicksDuration())}",
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
