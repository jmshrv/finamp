import 'package:finamp/models/JellyfinModels.dart';
import 'package:flutter/material.dart';
import 'package:filesize/filesize.dart';

class ItemMediaSourceInfo extends StatelessWidget {
  const ItemMediaSourceInfo({Key key, @required this.mediaSourceInfo})
      : super(key: key);

  final MediaSourceInfo mediaSourceInfo;

  @override
  Widget build(BuildContext context) {
    return Text(
        "${filesize(mediaSourceInfo.size)} ${mediaSourceInfo.container.toUpperCase()}");
  }
}
