import 'package:finamp/components/PlayerScreen/artist_chip.dart';
import 'package:finamp/components/PlayerScreen/genre_chip.dart';
import 'package:finamp/l10n/app_localizations.dart';
import 'package:finamp/models/finamp_models.dart';
import 'package:finamp/services/finamp_settings_helper.dart';
import 'package:finamp/services/release_date_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';

import '../../models/jellyfin_models.dart';
import '../icon_and_text.dart';
import '../print_duration.dart';

class ItemInfo extends ConsumerWidget {
  const ItemInfo({
    super.key,
    required this.item,
    required this.itemTracks,
  });

  final BaseItemDto item;
  final int itemTracks;

// TODO: see if there's a way to expand this column to the row that it's in
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final trackCountString = (itemTracks == (item.childCount ?? itemTracks) ||
                      !ref.watch(finampSettingsProvider.isOffline))
                  ? AppLocalizations.of(context)!.trackCount(itemTracks)
                  : AppLocalizations.of(context)!
                      .offlineTrackCount(item.childCount!, itemTracks);
    final runtimeDuration = printDuration(item.runTimeTicksDuration());
    final trackDurationString = "$trackCountString ($runtimeDuration)";

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // if (item.type != "Playlist") IconAndText(
        //   iconData: TablerIcons.user,
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
            artistType: ArtistType.albumartist,
          ),
        IconAndText(
            iconData: Icons.music_note,
            textSpan: TextSpan(
              text: trackDurationString,
            )),
        /* Previously, we had the duration in one row
        IconAndText(
          iconData: Icons.timer,
          textSpan: TextSpan(
            text: printDuration(item.runTimeTicksDuration()),
          ),
        ),*/
        if (item.type != "Playlist")
          IconAndText(
              iconData: Icons.event,
              textSpan: TextSpan(
                text: ReleaseDateHelper.autoFormat(item),
              )),
        if (item.type != "Playlist" &&
            (item.genreItems != null && item.genreItems!.isNotEmpty))
          Row(
            children: [
              Icon(
                TablerIcons.color_swatch,
                color: theme.iconTheme.color?.withOpacity(
                        theme.brightness == Brightness.light ? 0.38 : 0.5,
                      ),
              ),
              const SizedBox(width: 4),
              Expanded(
                child: GenreChips(
                        genres: item.genreItems!,
                        backgroundColor:
                          IconTheme.of(context).color!.withOpacity(0.1),
                      ),
              ),
            ],
          ),
      ],
    );
  }
}
