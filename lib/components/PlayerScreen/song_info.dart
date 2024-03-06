import 'package:finamp/models/finamp_models.dart';
import 'package:finamp/services/queue_service.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../../services/current_album_image_provider.dart';
import '../../services/jellyfin_api_helper.dart';
import '../../services/music_player_background_task.dart';
import 'song_name_content.dart';
import '../album_image.dart';

/// Album image and song name/album etc. We do this in one widget to share a
/// StreamBuilder and to make alignment easier.
class SongInfo extends StatefulWidget {
  const SongInfo({Key? key}) : super(key: key);

  @override
  State<SongInfo> createState() => _SongInfoState();
}

class _SongInfoState extends State<SongInfo> {
  final audioHandler = GetIt.instance<MusicPlayerBackgroundTask>();
  final jellyfinApiHelper = GetIt.instance<JellyfinApiHelper>();
  final queueService = GetIt.instance<QueueService>();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<FinampQueueInfo?>(
      stream: queueService.getQueueStream(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          // show loading indicator
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        final currentTrack = snapshot.data!.currentTrack!;

        final secondaryTextColour =
            Theme.of(context).textTheme.bodyMedium?.color?.withOpacity(0.8);

        return Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(child: _PlayerScreenAlbumImage(queueItem: currentTrack)),
            Padding(
              padding: const EdgeInsets.only(left: 20.0, right: 20.0, top: 8.0, bottom: 8.0),
              child: SongNameContent(
                currentTrack: currentTrack,
                secondaryTextColour: secondaryTextColour,
              ),
            ),
          ],
        );
      },
    );
  }
}

class _PlayerScreenAlbumImage extends StatelessWidget {
  const _PlayerScreenAlbumImage({
    Key? key,
    required this.queueItem,
  }) : super(key: key);

  final FinampQueueItem queueItem;

  @override
  Widget build(BuildContext context) {

    final screenWidth = MediaQuery.of(context).size.width;
    
    return Container(
      constraints: BoxConstraints(
        maxWidth: screenWidth * 0.92,
      ),
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            blurRadius: 32,
            offset: const Offset(0, 4),
            color: Colors.black.withOpacity(0.25),
          )
        ],
      ),
      //!!! don't apply center alignment here, otherwise the container will stretch to the full width of the screen, and the backdrop shadow will be stretched too
      child: AlbumImage(
        imageListenable: currentAlbumImageProvider,
      ),
    );
  }
}
