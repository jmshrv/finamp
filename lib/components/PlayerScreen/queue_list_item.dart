import 'package:finamp/components/album_image.dart';
import 'package:finamp/services/music_player_background_task.dart';
import 'package:finamp/services/process_artist.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:finamp/models/finamp_models.dart';
import 'package:finamp/models/jellyfin_models.dart' as jellyfin_models;
import 'package:finamp/services/queue_service.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:get_it/get_it.dart';

class QueueListItem extends StatefulWidget {

  late QueueItem item;
  late int actualIndex;
  late int indexOffset;
  late List<QueueItem> subqueue;
  late bool isCurrentTrack;
  
  QueueListItem({
    Key? key,
    required this.item,
    required this.actualIndex,
    required this.indexOffset,
    required this.subqueue,
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
    return ListTile(
      visualDensity: VisualDensity.compact,
      minVerticalPadding: 0.0,
      contentPadding: const EdgeInsets.symmetric(vertical: 0.0, horizontal: 8.0),
      tileColor: widget.isCurrentTrack
          ? Theme.of(context).colorScheme.secondary.withOpacity(0.1)
          : null,
      leading: AlbumImage(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(7.0),
          bottomLeft: Radius.circular(7.0),
        ),
        item: widget.item.item
                    .extras?["itemJson"] == null
                ? null
                : jellyfin_models.BaseItemDto.fromJson(widget.item.item.extras?["itemJson"]),
      ),
      title: Text(
          widget.item.item.title ?? AppLocalizations.of(context)!.unknownName,
          style: this.widget.isCurrentTrack
              ? TextStyle(
                  color:
                      Theme.of(context).colorScheme.secondary)
              : null),
      subtitle: Text(processArtist(
          widget.item.item.artist,
          context)),
      trailing: Container(
        alignment: Alignment.centerRight,
        margin: const EdgeInsets.only(right: 32.0),
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
            // IconButton(
            //   icon: const Icon(TablerIcons.dots_vertical),
            //   iconSize: 28.0,
            //   onPressed: () async => {},
            // ),
            IconButton(
              icon: const Icon(TablerIcons.x),
              iconSize: 28.0,
              onPressed: () async => await _queueService.removeAtOffset(widget.indexOffset),
            ),
            Draggable(
              data: widget.item,
              axis: Axis.vertical,
              dragAnchorStrategy: (draggable, context, position) => Offset(MediaQuery.of(context).size.width - 62.0, 0.0),
              // feedback: QueueListItemGhost(
              //   item: widget.item,
              //   isCurrentTrack: widget.isCurrentTrack,
              // ),
              feedback: Container(),
              childWhenDragging: Container(),
              // key: ValueKey("${_queue![actualIndex].item.id}$actualIndex-drag"),
              child: Icon(
                TablerIcons.grip_horizontal,
                color: IconTheme.of(context).color,
                size: 28.0,
              ),
            ),
          ],
        ),  
      ),
      onTap: () async =>
          await _queueService.skipByOffset(widget.indexOffset),
    );
  }
}

class QueueListItemGhost extends StatelessWidget {

  final QueueItem item;
  final bool isCurrentTrack;
  
  const QueueListItemGhost({
    Key? key,
    required this.item,
    this.isCurrentTrack = false,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 400.0,
      // height: 90.0,
      child: Card(
        elevation: 8.0,
        margin: EdgeInsets.zero,
        child: ListTile(
          visualDensity: VisualDensity.compact,
          minVerticalPadding: 0.0,
          contentPadding: const EdgeInsets.symmetric(vertical: 0.0, horizontal: 8.0),
          tileColor: this.isCurrentTrack
              ? Theme.of(context).colorScheme.secondary.withOpacity(0.1)
              : null,
          leading: AlbumImage(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(7.0),
              bottomLeft: Radius.circular(7.0),
            ),
            item: this.item.item
                        .extras?["itemJson"] == null
                    ? null
                    : jellyfin_models.BaseItemDto.fromJson(this.item.item.extras?["itemJson"]),
          ),
          title: Text(
              this.item.item.title ?? AppLocalizations.of(context)!.unknownName,
              style: this.isCurrentTrack
                  ? TextStyle(
                      color:
                          Theme.of(context).colorScheme.secondary)
                  : null),
          subtitle: Text(processArtist(
              this.item.item.artist,
              context)),
          trailing: Container(
            alignment: Alignment.centerRight,
            margin: const EdgeInsets.only(right: 32.0),
            width: 115.0,
            height: 50.0,
          ),
          onTap: () async => {},
        ),
      ),
    );
  }

}

