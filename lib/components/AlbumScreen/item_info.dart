import 'package:finamp/components/PlayerScreen/artist_chip.dart';
import 'package:finamp/services/finamp_settings_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../models/jellyfin_models.dart';
import '../icon_and_text.dart';
import '../print_duration.dart';

class ItemInfo extends StatelessWidget {
  const ItemInfo({
    super.key,
    required this.item,
    required this.itemSongs,
  });

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
        if (item.type != "Playlist")
          ArtistChips(
            baseItem: item,
            useAlbumArtist: true,
          ),
        IconAndText(
            iconData: Icons.music_note,
            textSpan: TextSpan(
              text: (itemSongs == (item.childCount ?? itemSongs) ||
                      !FinampSettingsHelper.finampSettings.isOffline)
                  ? AppLocalizations.of(context)!.songCount(itemSongs)
                  : AppLocalizations.of(context)!
                      .offlineSongCount(item.childCount!, itemSongs),
            )),
        IconAndText(
          iconData: Icons.timer,
          textSpan: TextSpan(
            text: printDuration(item.runTimeTicksDuration()),
          ),
        ),
        if (item.type != "Playlist")
          IconAndText(
              iconData: Icons.event,
              textSpan: TextSpan(
                text: item.productionYearString,
              ))
      ],
    );
  }
}
