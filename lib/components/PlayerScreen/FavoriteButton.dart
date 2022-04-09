import 'package:audio_service/audio_service.dart';
import 'package:finamp/components/errorSnackbar.dart';
import 'package:finamp/models/JellyfinModels.dart';
import 'package:finamp/services/JellyfinApiData.dart';
import 'package:finamp/services/MusicPlayerBackgroundTask.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

class FavoriteButton extends StatefulWidget {
  const FavoriteButton({Key? key}) : super(key: key);

  @override
  _FavoriteButtonState createState() => _FavoriteButtonState();
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
    final _audioHandler = GetIt.instance<MusicPlayerBackgroundTask>();
    final _jellyfinApiData = GetIt.instance<JellyfinApiData>();

    return StreamBuilder<MediaItem?>(
        stream: _audioHandler.mediaItem,
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
                  UserItemDataDto? newUserData = null;
                  if (isFav) {
                    newUserData = await _jellyfinApiData.removeFavourite(id);
                  } else {
                    newUserData = await _jellyfinApiData.addFavourite(id);
                  }
                  setState(() {
                    dto.userData = newUserData;
                    _audioHandler.mediaItem.valueOrNull!.extras!['itemJson'] =
                        dto.toJson();
                  });
                } catch (e) {
                  errorSnackbar(e, context);
                }
              },
            );
          } else {
            return IconButton(
              icon: Icon(
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
