import 'package:finamp/components/artists_text_spans.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../models/jellyfin_models.dart';
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
        if (item.type != "Playlist")
          _IconAndText(
              iconData: Icons.person,
              textSpan: TextSpan(
                children: ArtistsTextSpans(
                  item,
                  Theme.of(context).colorScheme.onSurface,
                  context,
                  false,
                ),
              )),
        _IconAndText(
          iconData: Icons.music_note,
          textSpan: _buildStyledText(
            context: context,
            text: AppLocalizations.of(context)!.songCount(itemSongs),
          ),
        ),
        _IconAndText(
          iconData: Icons.timer,
          textSpan: _buildStyledText(
            context: context,
            text: printDuration(Duration(
              microseconds:
                  item.runTimeTicks == null ? 0 : item.runTimeTicks! ~/ 10,
            )),
          ),
        ),
        if (item.type != "Playlist")
          _IconAndText(
            iconData: Icons.event,
            textSpan: _buildStyledText(
              context: context,
              text: item.productionYearString,
            ),
          )
      ],
    );
  }

  TextSpan _buildStyledText({required BuildContext context, String? text}) {
    return TextSpan(
      text: text,
      style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
    );
  }
}

class _IconAndText extends StatelessWidget {
  const _IconAndText({
    Key? key,
    required this.iconData,
    required this.textSpan,
  }) : super(key: key);

  final IconData iconData;
  final TextSpan textSpan;

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
            color: Theme.of(context).disabledColor,
          ),
          const Padding(padding: EdgeInsets.symmetric(horizontal: 2)),
          Expanded(
            child: RichText(
              text: textSpan,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          )
        ],
      ),
    );
  }
}