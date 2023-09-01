import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';


import '../../models/jellyfin_models.dart';
import '../../services/jellyfin_api_helper.dart';
import '../../services/audio_service_helper.dart';

class ArtistPlayButton extends StatefulWidget {
  const ArtistPlayButton({
    Key? key,
    required this.artist,
  }) : super(key: key);

  final BaseItemDto artist;
  

  @override
  State<ArtistPlayButton> createState() => _ArtistPlayButtonState();
}

class _ArtistPlayButtonState extends State<ArtistPlayButton> {
  static const _disabledButton = IconButton(
    onPressed: null,
    icon: Icon(Icons.play_arrow)
    );
    Future<List<BaseItemDto>?>? artistPlayButtonFuture;

    final jellyfinApiHelper = GetIt.instance<JellyfinApiHelper>();
    final audioServiceHelper = GetIt.instance<AudioServiceHelper>();

    @override
    initState() {
       artistPlayButtonFuture ??= jellyfinApiHelper.getItems(
            parentItem: widget.artist,
            includeItemTypes: "Audio",
            sortBy: 'PremiereDate,Album,SortName',
            isGenres: false,
          );
          super.initState();
    }
    
    @override
    Widget build(BuildContext context) {
      return FutureBuilder<List<BaseItemDto>?>(
        future: artistPlayButtonFuture,
        builder: (context, snapshot) {
          if (snapshot.hasData){
            final List<BaseItemDto> items = snapshot.data!;

            return IconButton(
              onPressed: () async {
                await audioServiceHelper
                       .replaceQueueWithItem(itemList: items);
              }, 
              icon: const Icon(Icons.play_arrow),
              );
          } else {
            return _disabledButton;
          }
        },
      );
    }

}