import 'package:finamp/components/AlbumScreen/downloaded_indicator.dart';
import 'package:finamp/components/album_image.dart';
import 'package:finamp/components/favourite_button.dart';
import 'package:finamp/components/print_duration.dart';
import 'package:finamp/models/finamp_models.dart';
import 'package:finamp/models/jellyfin_models.dart';
import 'package:finamp/screens/player_screen.dart';
import 'package:finamp/services/release_date_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class MusicVideoListTile extends StatefulWidget {
  final BaseItemDto item;

  const MusicVideoListTile({super.key, required this.item});

  @override
  State<MusicVideoListTile> createState() => _MusicVideoListTileState();
}

class _MusicVideoListTileState extends State<MusicVideoListTile> {
  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: AlbumImage(item: widget.item, isMusicVideo: true),
      title: RichText(
        text: TextSpan(
          children: [
            TextSpan(
              text:
                  widget.item.name ?? AppLocalizations.of(context)!.unknownName,
            ),
          ],
          style: Theme.of(context).textTheme.titleMedium,
        ),
      ),
      subtitle: RichText(
        text: TextSpan(
          children: [
            // TODO: Add downloaded indicator
            // WidgetSpan(
            //   child: Transform.translate(
            //     offset: const Offset(-3, 0),
            //     child: DownloadedIndicator(
            //       item: DownloadStub.fromItem(
            //           type: DownloadItemType.collection, item: widget.item),
            //       size: Theme.of(context).textTheme.bodyMedium!.fontSize! + 3,
            //     ),
            //   ),
            //   alignment: PlaceholderAlignment.top,
            // ),
            TextSpan(
              text: ReleaseDateHelper.autoFormat(widget.item),
              style: TextStyle(
                  color: Theme.of(context)
                      .textTheme
                      .bodyMedium
                      ?.color
                      ?.withOpacity(0.7)),
            ),
            TextSpan(
              text: " · ${printDuration(widget.item.runTimeTicksDuration())}",
              style: TextStyle(color: Theme.of(context).disabledColor),
            ),
          ],
        ),
        overflow: TextOverflow.ellipsis,
      ),
      trailing: FavoriteButton(
        item: widget.item,
        onlyIfFav: true,
      ),
      onTap: () {
        Navigator.of(context)
            .pushNamed(PlayerScreen.routeName, arguments: widget.item);
      },
    );
  }
}
