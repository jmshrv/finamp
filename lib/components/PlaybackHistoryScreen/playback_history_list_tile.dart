import 'package:finamp/components/AlbumScreen/song_menu.dart';
import 'package:finamp/components/favourite_button.dart';
import 'package:finamp/models/finamp_models.dart';
import 'package:finamp/services/audio_service_helper.dart';
import 'package:finamp/services/jellyfin_api_helper.dart';
import 'package:finamp/services/queue_service.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get_it/get_it.dart';

import '../../models/jellyfin_models.dart' as jellyfin_models;
import '../album_image.dart';
import '../../services/process_artist.dart';

import 'package:finamp/components/error_snackbar.dart';
import 'package:finamp/services/downloads_helper.dart';
import 'package:finamp/services/finamp_settings_helper.dart';
import 'package:flutter/material.dart' hide ReorderableList;

class PlaybackHistoryListTile extends StatefulWidget {
  PlaybackHistoryListTile({
    super.key,
    required this.actualIndex,
    required this.item,
    required this.audioServiceHelper,
    required this.onTap,
  });

  final int actualIndex;
  final FinampHistoryItem item;
  final AudioServiceHelper audioServiceHelper;
  final void Function() onTap;

  final _jellyfinApiHelper = GetIt.instance<JellyfinApiHelper>();

  @override
  State<PlaybackHistoryListTile> createState() =>
      _PlaybackHistoryListTileState();
}

class _PlaybackHistoryListTileState extends State<PlaybackHistoryListTile> {
  @override
  Widget build(BuildContext context) {
    final baseItem = jellyfin_models.BaseItemDto.fromJson(
        widget.item.item.item.extras?["itemJson"]);

    return GestureDetector(
        onLongPressStart: (details) async {
          Feedback.forLongPress(context);
          showModalSongMenu(context: context, item: baseItem, parentId: baseItem.parentId);
        },
        child: Card(
            margin: EdgeInsets.all(0.0),
            elevation: 0,
            clipBehavior: Clip.antiAlias,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: ListTile(
              visualDensity: VisualDensity.standard,
              minVerticalPadding: 0.0,
              horizontalTitleGap: 10.0,
              contentPadding: const EdgeInsets.only(right: 4.0),
              leading: AlbumImage(
                item: widget.item.item.item.extras?["itemJson"] == null
                    ? null
                    : baseItem,
              ),
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(0.0),
                    child: Text(
                      widget.item.item.item.title ??
                          AppLocalizations.of(context)!.unknownName,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 6.0),
                    child: Text(
                      processArtist(widget.item.item.item.artist, context),
                      style: TextStyle(
                          color: Theme.of(context).textTheme.bodyMedium!.color!,
                          fontSize: 13,
                          fontFamily: 'Lexend Deca',
                          fontWeight: FontWeight.w300,
                          overflow: TextOverflow.ellipsis),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              // subtitle: Container(
              //   alignment: Alignment.centerLeft,
              //   height: 40.5, // has to be above a certain value to get rid of vertical padding
              //   child: Padding(
              //     padding: const EdgeInsets.only(bottom: 2.0),
              //     child: Text(
              //       processArtist(widget.item.item.item.artist, context),
              //       style: const TextStyle(
              //           color: Colors.white70,
              //           fontSize: 13,
              //           fontFamily: 'Lexend Deca',
              //           fontWeight: FontWeight.w300,
              //           overflow: TextOverflow.ellipsis),
              //       overflow: TextOverflow.ellipsis,
              //     ),
              //   ),
              // ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "${widget.item.item.item.duration?.inMinutes.toString()}:${((widget.item.item.item.duration?.inSeconds ?? 0) % 60).toString().padLeft(2, '0')}",
                    textAlign: TextAlign.end,
                    style: TextStyle(
                      color: Theme.of(context).textTheme.bodySmall?.color,
                    ),
                  ),
                  FavoriteButton(
                    item: baseItem,
                    onToggle: (isFavorite) => setState(() {
                      if (baseItem.userData != null) {
                        baseItem.userData!.isFavorite = isFavorite;
                        widget.item.item.item.extras?["itemJson"] =
                            baseItem.toJson();
                      }
                    }),
                  )
                ],
              ),
              onTap: widget.onTap,
            )));
  }

}
