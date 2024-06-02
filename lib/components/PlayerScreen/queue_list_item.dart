import 'package:balanced_text/balanced_text.dart';
import 'package:finamp/components/AlbumScreen/song_menu.dart';
import 'package:finamp/components/PlayerScreen/queue_source_helper.dart';
import 'package:finamp/components/album_image.dart';
import 'package:finamp/models/finamp_models.dart';
import 'package:finamp/models/jellyfin_models.dart' as jellyfin_models;
import 'package:finamp/services/feedback_helper.dart';
import 'package:finamp/services/finamp_settings_helper.dart';
import 'package:finamp/services/process_artist.dart';
import 'package:finamp/services/queue_service.dart';
import 'package:flutter/material.dart' hide ReorderableList;
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:flutter_vibrate/flutter_vibrate.dart';
import 'package:get_it/get_it.dart';
import 'package:marquee/marquee.dart';

import '../../services/theme_provider.dart';

class QueueListItem extends StatefulWidget {
  final FinampQueueItem item;
  final int listIndex;
  final int actualIndex;
  final int indexOffset;
  final List<FinampQueueItem> subqueue;
  final bool isCurrentTrack;
  final bool isPreviousTrack;
  final bool allowReorder;
  final void Function() onTap;

  const QueueListItem({
    super.key,
    required this.item,
    required this.listIndex,
    required this.actualIndex,
    required this.indexOffset,
    required this.subqueue,
    required this.onTap,
    this.allowReorder = true,
    this.isCurrentTrack = false,
    this.isPreviousTrack = false,
  });
  @override
  State<QueueListItem> createState() => _QueueListItemState();
}

class _QueueListItemState extends State<QueueListItem>
    with AutomaticKeepAliveClientMixin {
  final _queueService = GetIt.instance<QueueService>();

  @override
  bool get wantKeepAlive => true;

  FinampTheme? _menuTheme;

  @override
  void dispose() {
    _menuTheme?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    jellyfin_models.BaseItemDto baseItem = jellyfin_models.BaseItemDto.fromJson(
        widget.item.item.extras?["itemJson"]);

    final cardBackground = Theme.of(context).brightness == Brightness.dark
        ? const Color.fromRGBO(255, 255, 255, 0.075)
        : const Color.fromRGBO(255, 255, 255, 0.125);

    void menuCallback() {
      var currentTrack = jellyfin_models.BaseItemDto.fromJson(
          _queueService.getCurrentTrack()?.item.extras?["itemJson"]);
      showModalSongMenu(
        context: context,
        item: baseItem,
        usePlayerTheme: widget.item.baseItem?.blurHash != null &&
            widget.item.baseItem?.blurHash == currentTrack.blurHash,
        themeProvider: _menuTheme,
        isInPlaylist: queueItemInPlaylist(widget.item),
        parentItem: widget.item.source.item,
        confirmPlaylistRemoval: true,
      );
    }

    return Dismissible(
      key: Key(widget.item.id),
      direction: FinampSettingsHelper.finampSettings.disableGesture
          ? DismissDirection.none
          : DismissDirection.horizontal,
      onDismissed: (direction) async {
        FeedbackHelper.feedback(FeedbackType.impact);
        await _queueService.removeAtOffset(widget.indexOffset);
        setState(() {});
      },
      child: GestureDetector(
          onTapDown: (_) {
            _menuTheme?.calculate(Theme.of(context).brightness);
          },
          onLongPressStart: (details) => menuCallback(),
          onSecondaryTapDown: (details) => menuCallback(),
          child: Opacity(
            opacity: widget.isPreviousTrack ? 0.8 : 1.0,
            child: Card(
                color: cardBackground,
                elevation: 0,
                margin:
                    const EdgeInsets.symmetric(horizontal: 16.0, vertical: 5.0),
                clipBehavior: Clip.antiAlias,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: ListTile(
                  visualDensity: VisualDensity.standard,
                  minVerticalPadding: 0.0,
                  horizontalTitleGap: 10.0,
                  contentPadding: const EdgeInsets.symmetric(
                      vertical: 0.0, horizontal: 0.0),
                  tileColor: widget.isCurrentTrack
                      ? Theme.of(context).colorScheme.secondary.withOpacity(0.1)
                      : null,
                  leading: AlbumImage(
                    item: widget.item.item.extras?["itemJson"] == null
                        ? null
                        : jellyfin_models.BaseItemDto.fromJson(
                            widget.item.item.extras?["itemJson"]),
                    borderRadius: BorderRadius.zero,
                    themeCallback: (x) => _menuTheme = x,
                  ),
                  title: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(0.0),
                        child: SizedBox(
                          height: 20,
                          child: LayoutBuilder(
                            builder: (context,
                                constraints) {
                              final textPainter =
                              TextPainter(
                                text: TextSpan(
                                  text: widget.item.item.title,
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: Theme.of(
                                        context)
                                        .brightness ==
                                        Brightness
                                            .light
                                        ? FontWeight
                                        .w500
                                        : FontWeight
                                        .w600,
                                  ),
                                ),
                                maxLines: 1,
                                textDirection:
                                TextDirection.ltr,
                              )..layout(
                                  maxWidth:
                                  constraints
                                      .maxWidth);

                              final isOverflowing =
                                  textPainter
                                      .didExceedMaxLines;

                              if (isOverflowing) {
                                return Container(
                                  alignment: Alignment
                                      .centerLeft,
                                  height: (TextStyle(
                                    fontSize: 16,
                                    fontWeight: Theme.of(context)
                                        .brightness ==
                                        Brightness
                                            .light
                                        ? FontWeight
                                        .w500
                                        : FontWeight
                                        .w600,
                                  ).fontSize ??
                                      16.0),
                                  width: constraints
                                      .maxWidth,
                                  child: Marquee(
                                    key: ValueKey(
                                        widget.item.item.id),
                                    text: widget.item.item.title,
                                    style: widget.isCurrentTrack
                                        ? TextStyle(
                                        color:
                                        Theme.of(context).colorScheme.secondary,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w400,
                                        overflow: TextOverflow.ellipsis)
                                        : null,
                                    scrollAxis: Axis
                                        .horizontal,
                                    blankSpace: 20.0,
                                    velocity: 50.0,
                                    pauseAfterRound:
                                    const Duration(
                                        seconds:
                                        3),
                                    accelerationDuration:
                                    const Duration(
                                        seconds:
                                        1),
                                    accelerationCurve:
                                    Curves.linear,
                                    decelerationDuration:
                                    const Duration(
                                        milliseconds:
                                        500),
                                    decelerationCurve:
                                    Curves
                                        .easeOut,
                                    textDirection:
                                    TextDirection
                                        .ltr,
                                  ),
                                );
                              } else {
                                return Container(
                                  width: constraints
                                      .maxWidth,
                                  child: BalancedText(
                                    widget.item.item.title,
                                    style: widget.isCurrentTrack
                                        ? TextStyle(
                                        color:
                                        Theme.of(context).colorScheme.secondary,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w400,
                                        overflow: TextOverflow.ellipsis)
                                        : null,
                                    overflow:
                                    TextOverflow
                                        .ellipsis,
                                    maxLines: 2,
                                    textAlign:
                                    TextAlign
                                        .start,
                                  ),
                                );
                              }
                            },
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 6.0),
                        child: Text(
                          processArtist(widget.item.item.artist, context),
                          style: TextStyle(
                              color: Theme.of(context)
                                  .textTheme
                                  .bodyMedium!
                                  .color!,
                              fontSize: 13,
                              fontWeight: FontWeight.w300,
                              overflow: TextOverflow.ellipsis),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  trailing: Container(
                    margin: const EdgeInsets.only(right: 8.0),
                    padding: const EdgeInsets.only(right: 6.0),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          "${widget.item.item.duration?.inMinutes.toString()}:${((widget.item.item.duration?.inSeconds ?? 0) % 60).toString().padLeft(2, '0')}",
                          textAlign: TextAlign.end,
                          style: TextStyle(
                            color: Theme.of(context).textTheme.bodySmall?.color,
                          ),
                        ),
                        if (FinampSettingsHelper.finampSettings.disableGesture)
                          IconButton(
                            padding: const EdgeInsets.only(left: 6.0),
                            visualDensity: VisualDensity.compact,
                            icon: const Icon(
                              TablerIcons.x,
                              color: Colors.white,
                              weight: 1.5,
                            ),
                            iconSize: 24.0,
                            onPressed: () async {
                              FeedbackHelper.feedback(FeedbackType.light);
                              await _queueService
                                  .removeAtOffset(widget.indexOffset);
                            },
                          ),
                        if (widget.allowReorder)
                          ReorderableDragStartListener(
                            index: widget.listIndex,
                            child: Padding(
                              padding: const EdgeInsets.only(left: 6.0),
                              child: Icon(
                                TablerIcons.grip_horizontal,
                                color: Theme.of(context)
                                        .textTheme
                                        .bodyMedium
                                        ?.color ??
                                    Colors.white,
                                size: 28.0,
                                weight: 1.5,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                  onTap: widget.onTap,
                )),
          )),
    );
  }
}
