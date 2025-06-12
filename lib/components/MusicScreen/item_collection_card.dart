import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../models/jellyfin_models.dart';
import '../../services/finamp_settings_helper.dart';
import '../../services/generate_subtitle.dart';
import '../album_image.dart';

/// Card content for ItemCollection. You probably shouldn't use this widget directly,
/// use CollectionItem instead.
class ItemCollectionCard extends ConsumerWidget {
  const ItemCollectionCard({
    super.key,
    required this.item,
    this.parentType,
    this.onTap,
  });

  final BaseItemDto item;
  final String? parentType;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      // In CollectionItem, the OpenContainer handles padding.
      margin: EdgeInsets.zero,
      child: ClipRRect(
        borderRadius: AlbumImage.defaultBorderRadius,
        child: Stack(
          children: [
            AlbumImage(item: item),
            ref.watch(finampSettingsProvider.showTextOnGridView)
                ? _ItemCollectionCardText(item: item, parentType: parentType)
                : const SizedBox.shrink(),
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

class _ItemCollectionCardText extends ConsumerWidget {
  const _ItemCollectionCardText({
    required this.item,
    required this.parentType,
  });

  final BaseItemDto item;
  final String? parentType;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final subtitle = generateSubtitle(
      context: context,
      item: item, 
      parentType: parentType,
      artistType: ref.watch(finampSettingsProvider.defaultArtistType),
    );

    return Align(
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
            child: Wrap(
              // Runs must be horizontal to constrain child width.  Use large
              // spacing to force subtitle to wrap to next run
              spacing: 1000,
              children: [
                Text(
                  item.name ?? "Unknown Name",
                  overflow: TextOverflow.ellipsis,
                  maxLines: 3,
                  style: Theme.of(context)
                      .textTheme
                      .titleLarge!
                      .copyWith(color: Colors.white),
                ),
                if (subtitle != null)
                  Text(
                    subtitle,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 3,
                    style: Theme.of(context)
                        .textTheme
                        .bodySmall!
                        .copyWith(color: Colors.white.withOpacity(0.7)),
                  )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
