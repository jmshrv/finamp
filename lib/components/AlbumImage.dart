import 'dart:typed_data';

import 'package:finamp/models/JellyfinModels.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../services/JellyfinApiData.dart';

class AlbumImage extends StatefulWidget {
  AlbumImage({Key key, @required this.item}) : super(key: key);

  final BaseItemDto item;

  @override
  _AlbumImageState createState() => _AlbumImageState();
}

class _AlbumImageState extends State<AlbumImage> {
  Future albumImageFuture;
  JellyfinApiData jellyfinApiData = GetIt.instance<JellyfinApiData>();

  @override
  void initState() {
    super.initState();
    albumImageFuture = jellyfinApiData.getAlbumPrimaryImage(widget.item);
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1 / 1,
      child: ClipRRect(
        borderRadius: BorderRadius.all(Radius.circular(4)),
        child: Container(
          color: Theme.of(context).cardColor,
          child: FutureBuilder<Uint8List>(
            future: albumImageFuture,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Image.memory(
                  snapshot.data,
                  fit: BoxFit.cover,
                );
              } else if (snapshot.hasError) {
                return Icon(Icons.album);
              } else {
                return Container();
              }
            },
          ),
        ),
      ),
    );
  }
}
