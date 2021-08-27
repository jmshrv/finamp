import 'package:flutter/material.dart';

import '../../models/JellyfinModels.dart';
import '../../services/generateSubtitle.dart';
import '../AlbumImage.dart';

/// Card content for AlbumItem. You probably shouldn't use this widget directly,
/// use AlbumItem instead.
class AlbumItemCard extends StatelessWidget {
  const AlbumItemCard({
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

    return Card(
      child: ClipRRect(
        borderRadius: AlbumImage.borderRadius,
        child: Stack(
          children: [
            AlbumImage(itemId: item.id),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [
                      // We fade from half transparent black to transparent so that text is visible on bright images
                      Colors.black.withOpacity(0.5),
                      Colors.transparent,
                    ],
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Align(
                    alignment: Alignment.bottomLeft,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.name ?? "Unknown Name",
                          overflow: TextOverflow.ellipsis,
                          maxLines: 3,
                          style: Theme.of(context)
                              .textTheme
                              .headline6!
                              .copyWith(color: Colors.white),
                        ),
                        if (subtitle != null)
                          Text(
                            subtitle,
                            style: Theme.of(context)
                                .textTheme
                                .caption!
                                .copyWith(color: Colors.white.withOpacity(0.7)),
                          )
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Positioned.fill(
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: onTap,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
