import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../../models/jellyfin_models.dart';
import '../../services/jellyfin_api_helper.dart';
import '../../services/generate_subtitle.dart';
import '../album_image.dart';

/// ListTile content for AlbumItem. You probably shouldn't use this widget
/// directly, use AlbumItem instead.
class AlbumItemListTile extends StatelessWidget {
  const AlbumItemListTile({
    Key? key,
    required this.item,
    this.parentType,
    this.onTap,
  }) : super(key: key);

  final BaseItemDto item;
  final String? parentType;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    final jellyfinApiHelper = GetIt.instance<JellyfinApiHelper>();
    final subtitle = generateSubtitle(item, parentType, context);

    return ListTile(
      // This widget is used on the add to playlist screen, so we allow a custom
      // onTap to be passed as an argument.
      onTap: onTap,
      leading: AlbumImage(item: item),
      title: Text(
        item.name ?? "Unknown Name",
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: subtitle == null ? null : Text(subtitle),
      trailing: jellyfinApiHelper.selectedMixAlbumIds.contains(item.id)
          ? const Icon(Icons.explore)
          : null,
    );
  }
}
