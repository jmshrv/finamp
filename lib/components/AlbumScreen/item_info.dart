import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get_it/get_it.dart';

import '../../models/jellyfin_models.dart';
import '../../screens/artist_screen.dart';
import '../../services/jellyfin_api_helper.dart';
import '../../services/process_artist.dart';
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
        if (item.type != "Playlist") _ArtistIconAndText(album: item),
        _IconAndText(
            iconData: Icons.music_note,
            text: AppLocalizations.of(context)!.songCount(itemSongs)),
        _IconAndText(
            iconData: Icons.timer,
            text: printDuration(Duration(
                microseconds:
                    item.runTimeTicks == null ? 0 : item.runTimeTicks! ~/ 10))),
        if (item.type != "Playlist")
          _IconAndText(iconData: Icons.event, text: item.productionYearString)
      ],
    );
  }
}

class _IconAndText extends StatelessWidget {
  const _IconAndText({
    Key? key,
    required this.iconData,
    required this.text,
  }) : super(key: key);

  final IconData iconData;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            iconData,
            // Inactive icons have an opacity of 50% with dark theme and 38%
            // with bright theme
            // https://material.io/design/iconography/system-icons.html#color
            color: Theme.of(context).iconTheme.color?.withOpacity(
                Theme.of(context).brightness == Brightness.light ? 0.38 : 0.5),
          ),
          const Padding(padding: EdgeInsets.symmetric(horizontal: 2)),
          Expanded(
            child: Text(
              text,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          )
        ],
      ),
    );
  }
}

class _ArtistIconAndText extends StatelessWidget {
  const _ArtistIconAndText({Key? key, required this.album}) : super(key: key);

  final BaseItemDto album;

  @override
  Widget build(BuildContext context) {
    final jellyfinApiHelper = GetIt.instance<JellyfinApiHelper>();

    return GestureDetector(
      onTap: () => jellyfinApiHelper
          .getItemById(album.albumArtists!.first.id)
          .then((artist) => Navigator.of(context)
              .pushNamed(ArtistScreen.routeName, arguments: artist)),
      child: _IconAndText(
        iconData: Icons.person,
        text: processArtist(album.albumArtist, context),
      ),
    );
  }
}
