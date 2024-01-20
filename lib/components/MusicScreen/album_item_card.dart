import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

import '../../models/jellyfin_models.dart';
import '../../models/finamp_models.dart';
import '../../services/finamp_settings_helper.dart';
import '../../services/generate_subtitle.dart';
import '../album_image.dart';

/// Card content for AlbumItem. You probably shouldn't use this widget directly,
/// use AlbumItem instead.
class AlbumItemCard extends StatelessWidget {
  const AlbumItemCard({
    Key? key,
    required this.item,
    this.parentType,
    this.onTap,
    this.addSettingsListener = false,
  }) : super(key: key);

  final BaseItemDto item;
  final String? parentType;
  final void Function()? onTap;
  final bool addSettingsListener;

  @override
  Widget build(BuildContext context) {
    return Card(
      // In AlbumItem, the OpenContainer handles padding.
      margin: EdgeInsets.zero,
      child: ClipRRect(
        borderRadius: AlbumImage.defaultBorderRadius,
        child: Stack(
          children: [
            AlbumImage(item: item),
            addSettingsListener
                ? // We need this ValueListenableBuilder to react to changes to
                // showTextOnGridView. When shown in a MusicScreen, this widget
                // would refresh anyway since MusicScreen also listens to
                // FinampSettings, but there may be cases where this widget is used
                // elsewhere.
                ValueListenableBuilder<Box<FinampSettings>>(
                    valueListenable:
                        FinampSettingsHelper.finampSettingsListener,
                    builder: (_, box, __) {
                      if (box.get("FinampSettings")!.showTextOnGridView) {
                        return _AlbumItemCardText(
                            item: item, parentType: parentType);
                      } else {
                        // ValueListenableBuilder doesn't let us return null, so we
                        // return a 0-sized SizedBox.
                        return const SizedBox.shrink();
                      }
                    },
                  )
                : FinampSettingsHelper.finampSettings.showTextOnGridView
                    ? _AlbumItemCardText(item: item, parentType: parentType)
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

class _AlbumItemCardText extends StatelessWidget {
  const _AlbumItemCardText({
    Key? key,
    required this.item,
    required this.parentType,
  }) : super(key: key);

  final BaseItemDto item;
  final String? parentType;

  @override
  Widget build(BuildContext context) {
    final subtitle = generateSubtitle(item, parentType, context);

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
                      .titleLarge!
                      .copyWith(color: Colors.white),
                ),
                if (subtitle != null)
                  Text(
                    subtitle,
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