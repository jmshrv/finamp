import 'package:finamp/models/finamp_models.dart';
import 'package:finamp/services/feedback_helper.dart';
import 'package:finamp/services/finamp_settings_helper.dart';
import 'package:finamp/services/music_player_background_task.dart';
import 'package:finamp/services/queue_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vibrate/flutter_vibrate.dart';
import 'package:get_it/get_it.dart';
import 'package:simple_gesture_detector/simple_gesture_detector.dart';

import '../../services/current_album_image_provider.dart';
import '../album_image.dart';

class PlayerScreenAlbumImage extends StatelessWidget {
  const PlayerScreenAlbumImage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<FinampQueueInfo?>(
      stream: GetIt.instance<QueueService>().getQueueStream(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          // show loading indicator
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        return SimpleGestureDetector(
          //TODO replace with PageView, this is just a placeholder
          onTap: () {
            final audioService = GetIt.instance<MusicPlayerBackgroundTask>();
            audioService.togglePlayback();
            FeedbackHelper.feedback(FeedbackType.selection);
          },
          onHorizontalSwipe: (direction) {
            final queueService = GetIt.instance<QueueService>();
            if (direction == SwipeDirection.left) {
              if (!FinampSettingsHelper.finampSettings.disableGesture) {
                queueService.skipByOffset(1);
                FeedbackHelper.feedback(FeedbackType.selection);
              }
            } else if (direction == SwipeDirection.right) {
              if (!FinampSettingsHelper.finampSettings.disableGesture) {
                queueService.skipByOffset(-1);
                FeedbackHelper.feedback(FeedbackType.selection);
              }
            }
          },
          child: AspectRatio(
            aspectRatio: 1.0,
            //aspectRatio: 0.5,
            child: Align(
              alignment: Alignment.center,
              child: LayoutBuilder(builder: (context, constraints) {
                //print(
                //    "control height is ${MediaQuery.sizeOf(context).height - 53.0 - constraints.maxHeight - 24}");
                final horizontalPadding = constraints.maxWidth *
                    (FinampSettingsHelper
                            .finampSettings.playerScreenCoverMinimumPadding /
                        100.0);
                return Padding(
                  padding: EdgeInsets.only(
                    left: horizontalPadding,
                    right: horizontalPadding,
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          blurRadius: 24,
                          offset: const Offset(0, 4),
                          color: Colors.black.withOpacity(0.3),
                        )
                      ],
                    ),
                    child: AlbumImage(
                      imageListenable: currentAlbumImageProvider,
                      borderRadius: BorderRadius.circular(8.0),
                      // Load player cover at max size to allow more seamless scaling
                      autoScale: false,
                    ),
                  ),
                );
              }),
            ),
          ),
        );
      },
    );
  }
}
