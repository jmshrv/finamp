import 'package:finamp/components/PlayerScreen/artist_chip.dart';
import 'package:finamp/components/PlayerScreen/genre_chip.dart';
import 'package:finamp/l10n/app_localizations.dart';
import 'package:finamp/models/finamp_models.dart';
import 'package:finamp/services/finamp_settings_helper.dart';
import 'package:finamp/services/datetime_helper.dart';
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
        // We display the title of a playlist here, because we have
        // too many actions in the AppBar:
        if (item.type == "Playlist")
          Padding(
            padding: EdgeInsets.only(left: 6, right: 6, top: 0, bottom: 6),
            child: Text(
              item.name ?? "Unknown Playlist",
              style: Theme.of(context).textTheme.titleMedium,
              maxLines: 3,
              overflow: TextOverflow.ellipsis, 
            ),
          ),
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
        if (item.type != "Playlist")
          IconAndText(
              iconData: Icons.event,
              textSpan: TextSpan(
                text: ReleaseDateHelper.autoFormat(item) ??
                    AppLocalizations.of(context)!.noReleaseDate,
              )),
        if (item.type != "Playlist")
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
                child: (item.genreItems != null && item.genreItems!.isNotEmpty)
                  ? GenreChips(
                      genres: item.genreItems!,
                      backgroundColor:
                        IconTheme.of(context).color!.withOpacity(0.1),
                    )
                  : Text(
                      AppLocalizations.of(context)!.noGenres
                    ),
              ),
            ],
          ),
      ],
    );
  }
}
