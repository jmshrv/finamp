import 'dart:typed_data';

import 'package:cached_network_image/cached_network_image.dart';
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
  // TODO: Actually implement images once cached_network_image properly handles 404s during album load
  // https://github.com/Baseflow/flutter_cached_network_image/issues/273

  // Future<String> albumImageFuture;
  // JellyfinApiData jellyfinApiData = GetIt.instance<JellyfinApiData>();

  // @override
  // void initState() {
  //   super.initState();
  //   albumImageFuture = jellyfinApiData.getBaseUrl();
  // }

  // @override
  // Widget build(BuildContext context) {
  //   return FutureBuilder<String>(
  //       future: albumImageFuture,
  //       builder: (context, snapshot) {
  //         if (snapshot.hasData) {
  //           return ClipRRect(
  //             child: AspectRatio(
  //               aspectRatio: 1,
  //               child: LayoutBuilder(builder: (context, constraints) {
  //                 try {
  //                   return CachedNetworkImage(
  //                     imageUrl:
  //                         "${snapshot.data}/Items/${widget.item.id}/Images/Primary?format=webp&MaxWidth=${constraints.maxWidth.toInt()}&MaxHeight=${constraints.maxHeight.toInt()}",
  //                     fit: BoxFit.cover,
  //                     placeholder: (context, url) => Container(
  //                       color: Theme.of(context).cardColor,
  //                     ),
  //                     errorWidget: (context, url, error) => Icon(Icons.album),
  //                   );
  //                 } catch (e) {
  //                   print(e);
  //                   return Container(
  //                     color: Theme.of(context).cardColor,
  //                   );
  //                 }
  //               }),
  //             ),
  //           );
  //         } else {
  //           return ClipRRect(
  //               child: AspectRatio(
  //                   aspectRatio: 1,
  //                   child: Container(
  //                     color: Theme.of(context).cardColor,
  //                   )));
  //         }
  //       });
  // }
  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1,
      child: ClipRRect(
        borderRadius: BorderRadius.all(Radius.circular(4)),
        child: Container(
          color: Theme.of(context).cardColor,
        ),
      ),
    );
  }
}
