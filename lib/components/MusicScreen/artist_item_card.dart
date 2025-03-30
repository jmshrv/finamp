import 'package:flutter/material.dart';
import 'package:hive_ce/hive.dart';

import '../../models/finamp_models.dart';
import '../../models/jellyfin_models.dart';
import '../../services/finamp_settings_helper.dart';
import '../../services/generate_subtitle.dart';
import '../album_image.dart';

/// Card content for AlbumItem. You probably shouldn't use this widget directly,
/// use AlbumItem instead.
class ArtistItemCard extends StatelessWidget {
  const ArtistItemCard({
    super.key,
    required this.item,
    this.onTap,
    this.addSettingsListener = false,
  });

  final BaseItemDto item;
  final void Function()? onTap;
  final bool addSettingsListener;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Stack(
          children: [
            AlbumImage(item: item, borderRadius: BorderRadius.circular(9999)),
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
        const SizedBox(
          height: 4,
        ),
        addSettingsListener
            ? // We need this ValueListenableBuilder to react to changes to
            // showTextOnGridView. When shown in a MusicScreen, this widget
            // would refresh anyway since MusicScreen also listens to
            // FinampSettings, but there may be cases where this widget is used
            // elsewhere.
            ValueListenableBuilder<Box<FinampSettings>>(
                valueListenable: FinampSettingsHelper.finampSettingsListener,
                builder: (_, box, __) {
                  if (box.get("FinampSettings")!.showTextOnGridView) {
                    return _ArtistItemCardText(item: item);
                  } else {
                    // ValueListenableBuilder doesn't let us return null, so we
                    // return a 0-sized SizedBox.
                    return const SizedBox.shrink();
                  }
                },
              )
            : FinampSettingsHelper.finampSettings.showTextOnGridView
                ? _ArtistItemCardText(item: item)
                : const SizedBox.shrink(),
      ],
    );
  }
}

class _ArtistItemCardText extends StatelessWidget {
  const _ArtistItemCardText({
    required this.item,
  });

  final BaseItemDto item;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Text(
        item.name ?? "Unknown Name",
        overflow: TextOverflow.ellipsis,
        maxLines: 3,
        style: Theme.of(context)
            .textTheme
            .bodySmall!
            .copyWith(fontWeight: FontWeight.w500),
      ),
    );
  }
}
