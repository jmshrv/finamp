import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:hive/hive.dart';

import '../models/JellyfinModels.dart';
import '../models/FinampModels.dart';
import '../services/JellyfinApiData.dart';
import '../services/FinampSettingsHelper.dart';
import '../services/DownloadsHelper.dart';
import '../components/NowPlayingBar.dart';
import '../components/AlbumScreen/AlbumScreenContent.dart';

class AlbumScreen extends StatefulWidget {
  const AlbumScreen({Key key}) : super(key: key);

  @override
  _AlbumScreenState createState() => _AlbumScreenState();
}

class _AlbumScreenState extends State<AlbumScreen> {
  Future<List<BaseItemDto>> albumScreenContentFuture;
  JellyfinApiData jellyfinApiData = GetIt.instance<JellyfinApiData>();

  @override
  Widget build(BuildContext context) {
    final BaseItemDto parent = ModalRoute.of(context).settings.arguments;

    return Scaffold(
      body: ValueListenableBuilder<Box<FinampSettings>>(
        valueListenable: FinampSettingsHelper.settingsListener,
        builder: (context, box, widget) {
          bool isOffline = box.get("FinampSettings").isOffline;

          if (isOffline) {
            DownloadsHelper downloadsHelper = GetIt.instance<DownloadsHelper>();
            DownloadedParent downloadedParent =
                downloadsHelper.getDownloadedParent(parent.id);

            return AlbumScreenContent(
              parent: downloadedParent.item,
              children: downloadedParent.downloadedChildren.values.toList(),
            );
          } else {
            if (albumScreenContentFuture == null) {
              albumScreenContentFuture = jellyfinApiData.getItems(
                  parentItem: parent,
                  sortBy: "SortName",
                  includeItemTypes: "Audio");
            }

            return FutureBuilder(
              future: albumScreenContentFuture,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final List<BaseItemDto> items = snapshot.data;
                  return AlbumScreenContent(parent: parent, children: items);
                } else if (snapshot.hasError) {
                  return Center(child: Text(snapshot.error));
                } else {
                  return Center(child: CircularProgressIndicator());
                }
              },
            );
          }
        },
      ),
      bottomNavigationBar: NowPlayingBar(),
    );
  }
}
