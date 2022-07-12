import 'package:audio_service/audio_service.dart';
import 'package:finamp/components/error_snackbar.dart';
import 'package:finamp/models/jellyfin_models.dart';
import 'package:finamp/services/jellyfin_api_helper.dart';
import 'package:finamp/services/music_player_background_task.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

class FavoriteButton extends StatefulWidget {
  const FavoriteButton({Key? key}) : super(key: key);

  @override
  State<FavoriteButton> createState() => _FavoriteButtonState();
}

class _FavoriteButtonState extends State<FavoriteButton> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final audioHandler = GetIt.instance<MusicPlayerBackgroundTask>();
    final jellyfinApiHelper = GetIt.instance<JellyfinApiHelper>();

    return StreamBuilder<MediaItem?>(
        stream: audioHandler.mediaItem,
        builder: (context, snapshot) {
          if (snapshot.data != null) {
            BaseItemDto dto =
                BaseItemDto.fromJson(snapshot.data!.extras!["itemJson"]);
            bool isFav = dto.userData!.isFavorite;
            String id = dto.id;

            return IconButton(
              icon: Icon(
                isFav ? Icons.star : Icons.star_outline,
                size: 24.0,
              ),
              onPressed: () async {
                try {
                  UserItemDataDto? newUserData;
                  if (isFav) {
                    newUserData = await jellyfinApiHelper.removeFavourite(id);
                  } else {
                    newUserData = await jellyfinApiHelper.addFavourite(id);
                  }
                  setState(() {
                    dto.userData = newUserData;
                    audioHandler.mediaItem.valueOrNull!.extras!['itemJson'] =
                        dto.toJson();
                  });
                } catch (e) {
                  errorSnackbar(e, context);
                }
              },
            );
          } else {
            return IconButton(
              icon: const Icon(
                Icons.favorite,
                color: Colors.grey,
                size: 24.0,
              ),
              onPressed: () {},
            );
          }
        });
  }
}
