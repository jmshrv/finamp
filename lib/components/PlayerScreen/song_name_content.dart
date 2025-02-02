import 'package:finamp/screens/player_screen.dart';
import 'package:finamp/services/finamp_settings_helper.dart';
import 'package:finamp/services/scrolling_text_helper.dart';
import 'package:flutter/material.dart';
import 'package:finamp/components/AddToPlaylistScreen/add_to_playlist_button.dart';
import 'package:finamp/components/PlayerScreen/player_buttons_more.dart';
import 'package:finamp/models/finamp_models.dart';
import 'package:finamp/models/jellyfin_models.dart' as jellyfin_models;
import 'package:get_it/get_it.dart';

import '../../services/queue_service.dart';
import 'artist_chip.dart';

class SongNameContent extends StatelessWidget {
  const SongNameContent(
    this.controller, {
    super.key,
  });

  final PlayerHideableController controller;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<FinampQueueInfo?>(
      stream: GetIt.instance<QueueService>().getQueueStream(),
      builder: (context, snapshot) {
        if (!snapshot.hasData || snapshot.data!.currentTrack == null) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        final currentTrack = snapshot.data!.currentTrack!;
        final jellyfin_models.BaseItemDto? songBaseItemDto =
            currentTrack.baseItem;

        return LayoutBuilder(builder: (context, constraints) {
          double padding = ((constraints.maxWidth - 260) / 4).clamp(0, 20);
          return Padding(
            padding:
                EdgeInsets.only(left: padding, right: padding, bottom: 4.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(
                  child: Container(
                    constraints: const BoxConstraints(maxWidth: 280),
                    child: Builder(
                      builder: (context) {
                        final text = currentTrack.item.title;
                        final isTwoLineMode =
                            controller.shouldShow(PlayerHideable.twoLineTitle);
                        final isMarqueeEnabled = FinampSettingsHelper
                            .finampSettings.oneLineMarqueeTextButton;

                        final textStyle = TextStyle(
                          fontSize: 20,
                          height: 1.2,
                          fontWeight:
                              Theme.of(context).brightness == Brightness.light
                                  ? FontWeight.w500
                                  : FontWeight.w600,
                        );

                        final textSpan = TextSpan(text: text, style: textStyle);
                        final textPainter = TextPainter(
                          text: textSpan,
                          textDirection: TextDirection.ltr,
                          maxLines: 2,
                        )..layout(maxWidth: 280);

                        final wouldOverflow = textPainter.didExceedMaxLines;

                        if (!isTwoLineMode) {
                          return Text(
                            text,
                            style: textStyle,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.center,
                          );
                        } else {
                          if (!wouldOverflow) {
                            return Text(
                              text,
                              style: textStyle,
                              textAlign: TextAlign.center,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            );
                          } else {
                            if (isMarqueeEnabled) {
                              return SizedBox(
                                width: 280,
                                height: 30,
                                child: ScrollingTextHelper(
                                  id: ValueKey(currentTrack.item.id),
                                  text: text,
                                  style: textStyle,
                                  alignment: TextAlign.center,
                                ),
                              );
                            } else {
                              return Text(
                                text,
                                style: textStyle,
                                textAlign: TextAlign.center,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              );
                            }
                          }
                        }
                      },
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    PlayerButtonsMore(
                        item: songBaseItemDto, queueItem: currentTrack),
                    Flexible(
                      child: ArtistChips(
                        baseItem: songBaseItemDto,
                        backgroundColor:
                            IconTheme.of(context).color!.withOpacity(0.1),
                      ),
                    ),
                    AddToPlaylistButton(
                      item: songBaseItemDto,
                      queueItem: currentTrack,
                    ),
                  ],
                ),
                Center(
                  child: Builder(
                    builder: (context) {
                      final text = currentTrack.item.album ?? "";
                      final textStyle = TextStyle(
                        fontSize: 14,
                        height: 1.0,
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      );

                      final textSpan = TextSpan(text: text, style: textStyle);
                      final textPainter = TextPainter(
                        text: textSpan,
                        textDirection: TextDirection.ltr,
                        maxLines: 1,
                      )..layout();

                      final contentWidth = textPainter.width + 16.0;
                      final needsMarquee = contentWidth > 280.0;
                      final width = needsMarquee ? 280.0 : contentWidth;

                      return Container(
                        width: width,
                        height: 20.0,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 4.0, vertical: 2.0),
                        decoration: BoxDecoration(
                          color: Theme.of(context)
                              .colorScheme
                              .surfaceVariant
                              .withOpacity(0.5),
                          borderRadius: BorderRadius.circular(4.0),
                        ),
                        child: needsMarquee
                            ? ScrollingTextHelper(
                                id: ValueKey('album-${currentTrack.item.id}'),
                                text: text,
                                style: textStyle,
                                alignment: TextAlign.center,
                              )
                            : Text(
                                text,
                                style: textStyle,
                                textAlign: TextAlign.center,
                                maxLines: 1,
                              ),
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        });
      },
    );
  }
}
