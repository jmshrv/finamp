import 'package:finamp/components/favourite_button.dart';
import 'package:finamp/services/finamp_user_helper.dart';
import 'package:flutter/material.dart';
import 'package:finamp/l10n/app_localizations.dart';
import 'package:get_it/get_it.dart';

import '../../models/finamp_models.dart';
import '../../models/jellyfin_models.dart';
import '../../services/generate_subtitle.dart';
import '../../services/jellyfin_api_helper.dart';
import '../AlbumScreen/downloaded_indicator.dart';
import '../album_image.dart';

/// ListTile content for AlbumItem. You probably shouldn't use this widget
/// directly, use AlbumItem instead.
class AlbumItemListTile extends StatelessWidget {
  const AlbumItemListTile({
    super.key,
    required this.item,
    this.parentType,
    this.onTap,
  });

  final BaseItemDto item;
  final String? parentType;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    final jellyfinApiHelper = GetIt.instance<JellyfinApiHelper>();
    final finampUserHelper = GetIt.instance<FinampUserHelper>();
    final subtitle = generateSubtitle(item, parentType, context);
    final library = finampUserHelper.currentUser?.currentView;
    final itemType = BaseItemDtoType.fromItem(item);
    final isArtistOrGenre = (itemType == BaseItemDtoType.artist ||
            itemType == BaseItemDtoType.genre);
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

    return ListTile(
        // This widget is used on the add to playlist screen, so we allow a custom
        // onTap to be passed as an argument.
        onTap: onTap,
        leading: AlbumImage(item: item),
        title: Text(
          item.name ?? AppLocalizations.of(context)!.unknownName,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Text.rich(
          TextSpan(children: [
            WidgetSpan(
              child: Transform.translate(
                offset: const Offset(-3, 0),
                child: DownloadedIndicator(
                  item: itemDownloadStub,
                  size: Theme.of(context).textTheme.bodyMedium!.fontSize! + 3,
                ),
              ),
              alignment: PlaceholderAlignment.top,
            ),
            if (subtitle != null)
              TextSpan(
                  text: subtitle,
                  style: TextStyle(color: Theme.of(context).disabledColor))
          ]),
          overflow: TextOverflow.ellipsis,
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            if ((item.type == "MusicArtist"
                    ? jellyfinApiHelper.selectedMixArtists
                    : jellyfinApiHelper.selectedMixAlbums)
                .contains(item))
              const Icon(Icons.explore),
            FavoriteButton(
              item: item,
              onlyIfFav: true,
            )
          ],
        ));
  }
}
