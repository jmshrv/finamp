import 'package:flutter/material.dart';

import '../../models/JellyfinModels.dart';
import '../../services/generateSubtitle.dart';
import '../AlbumImage.dart';

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
    final subtitle = generateSubtitle(item, parentType);

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
    );
  }
}
