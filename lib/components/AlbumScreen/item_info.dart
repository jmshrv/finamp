import 'package:finamp/components/PlayerScreen/artist_chip.dart';
import 'package:finamp/components/artists_text_spans.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get_it/get_it.dart';

import '../../models/jellyfin_models.dart';
import '../../screens/artist_screen.dart';
import '../../services/jellyfin_api_helper.dart';
import '../../services/process_artist.dart';
import '../artist_text_spans.dart';
import '../icon_and_text.dart';
import '../print_duration.dart';

class ItemInfo extends StatelessWidget {
  const ItemInfo({
    Key? key,
    required this.item,
    required this.itemSongs,
  }) : super(key: key);

  final BaseItemDto item;
  final int itemSongs;

// TODO: see if there's a way to expand this column to the row that it's in
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // if (item.type != "Playlist") IconAndText(
        //   iconData: Icons.person,
        //   textSpan: TextSpan(
        //     children: getArtistsTextSpans(
        //       item,
        //       context,
        //       false,
        //     ),
        //   ),
        // ),
        if (item.type != "Playlist") ArtistChips(
          baseItem: item,
          useAlbumArtist: true,
        ),
        IconAndText(
            iconData: Icons.music_note,
            textSpan: TextSpan(
              text: AppLocalizations.of(context)!.songCount(itemSongs),
              style: Theme.of(context).textTheme.bodyMedium,
            )),
        IconAndText(
            iconData: Icons.timer,
            textSpan: TextSpan(
              text: printDuration(Duration(
                microseconds:
                    item.runTimeTicks == null ? 0 : item.runTimeTicks! ~/ 10,
              )),
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
        if (item.type != "Playlist")
          IconAndText(iconData: Icons.event, textSpan: TextSpan(
            text: item.productionYearString,
            style: Theme.of(context).textTheme.bodyMedium,
          ))
      ],
    );
  }

}
