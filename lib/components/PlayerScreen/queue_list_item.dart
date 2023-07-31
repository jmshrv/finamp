import 'package:finamp/components/album_image.dart';
import 'package:finamp/services/music_player_background_task.dart';
import 'package:finamp/services/process_artist.dart';
import 'package:flutter/material.dart' hide ReorderableList;
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:finamp/models/finamp_models.dart';
import 'package:finamp/models/jellyfin_models.dart' as jellyfin_models;
import 'package:finamp/services/queue_service.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:get_it/get_it.dart';

class QueueListItem extends StatefulWidget {
  late QueueItem item;
  late int listIndex;
  late int actualIndex;
  late int indexOffset;
  late List<QueueItem> subqueue;
  late bool isCurrentTrack;
  late void Function() onTap;

  QueueListItem({
    Key? key,
    required this.item,
    required this.listIndex,
    required this.actualIndex,
    required this.indexOffset,
    required this.subqueue,
    required this.onTap,
    this.isCurrentTrack = false,
  }) : super(key: key);
  @override
  State<QueueListItem> createState() => _QueueListItemState();
}

class _QueueListItemState extends State<QueueListItem> {
  final _audioHandler = GetIt.instance<MusicPlayerBackgroundTask>();
  final _queueService = GetIt.instance<QueueService>();

  @override
  Widget build(BuildContext context) {
    return Card(
        color: const Color.fromRGBO(255, 255, 255, 0.05),
        elevation: 0,
        margin: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 5.0),
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: ListTile(
          visualDensity: VisualDensity.compact,
          minVerticalPadding: 0.0,
          contentPadding:
              const EdgeInsets.symmetric(vertical: 0.0, horizontal: 0.0),
          tileColor: widget.isCurrentTrack
              ? Theme.of(context).colorScheme.secondary.withOpacity(0.1)
              : null,
          leading: AlbumImage(
            item: widget.item.item.extras?["itemJson"] == null
                ? null
                : jellyfin_models.BaseItemDto.fromJson(
                    widget.item.item.extras?["itemJson"]),
          ),
          title: Padding(
            padding: const EdgeInsets.only(bottom: 4.0),
            child: Text(
              widget.item.item.title ??
                  AppLocalizations.of(context)!.unknownName,
              style: this.widget.isCurrentTrack
                  ? TextStyle(
                      color: Theme.of(context).colorScheme.secondary,
                      fontSize: 16,
                      fontFamily: 'Lexend Deca',
                      fontWeight: FontWeight.w400,
                      overflow: TextOverflow.ellipsis)
                  : null,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          subtitle: Text(
            processArtist(widget.item.item.artist, context),
            style: const TextStyle(
                color: Colors.white70,
                fontSize: 13,
                fontFamily: 'Lexend Deca',
                fontWeight: FontWeight.w300,
                overflow: TextOverflow.ellipsis),
            overflow: TextOverflow.ellipsis,
          ),
          trailing: Container(
            alignment: Alignment.centerRight,
            margin: const EdgeInsets.only(right: 8.0),
            width: 115.0,
            height: 50.0,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "${widget.item.item.duration?.inMinutes.toString().padLeft(2, '0')}:${((widget.item.item.duration?.inSeconds ?? 0) % 60).toString().padLeft(2, '0')}",
                  textAlign: TextAlign.end,
                  style: TextStyle(
                    color: Theme.of(context).textTheme.bodySmall?.color,
                  ),
                ),
                IconButton(
                  icon: const Icon(
                    TablerIcons.x,
                    color: Colors.white,
                    weight: 1.5,
                  ),
                  iconSize: 28.0,
                  onPressed: () async =>
                      await _queueService.removeAtOffset(widget.indexOffset),
                ),
                ReorderableDragStartListener(
                  index: widget.listIndex,
                  child: const Icon(
                    TablerIcons.grip_horizontal,
                    color: Colors.white,
                    size: 28.0,
                    weight: 1.5,
                  ),
                ),
              ],
            ),
          ),
          onTap: widget.onTap,
        ));
  }
}
