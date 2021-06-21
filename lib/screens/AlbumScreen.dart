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
  const AlbumScreen({Key? key}) : super(key: key);

  @override
  _AlbumScreenState createState() => _AlbumScreenState();
}

class _AlbumScreenState extends State<AlbumScreen> {
  Future<List<BaseItemDto>?>? albumScreenContentFuture;
  JellyfinApiData jellyfinApiData = GetIt.instance<JellyfinApiData>();

  @override
  Widget build(BuildContext context) {
    final BaseItemDto parent =
        ModalRoute.of(context)!.settings.arguments as BaseItemDto;

    return Scaffold(
      body: ValueListenableBuilder<Box<FinampSettings>>(
        valueListenable: FinampSettingsHelper.finampSettingsListener,
        builder: (context, box, widget) {
          bool isOffline = box.get("FinampSettings")?.isOffline ?? false;

          if (isOffline) {
            final downloadsHelper = GetIt.instance<DownloadsHelper>();

            // The downloadedParent won't be null here if we've already
            // navigated to it in offline mode
            final downloadedParent =
                downloadsHelper.getDownloadedParent(parent.id)!;

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

            return FutureBuilder<List<BaseItemDto>?>(
              future: albumScreenContentFuture,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final List<BaseItemDto> items = snapshot.data!;

                  return AlbumScreenContent(parent: parent, children: items);
                } else if (snapshot.hasError) {
                  return CustomScrollView(
                    physics: NeverScrollableScrollPhysics(),
                    slivers: [
                      SliverAppBar(
                        title: Text("Error"),
                      ),
                      SliverFillRemaining(
                        child: Center(child: Text(snapshot.error.toString())),
                      )
                    ],
                  );
                } else {
                  // We return all of this so that we can have an app bar while loading.
                  // This is especially important for iOS, where there isn't a hardware back button.
                  return CustomScrollView(
                    physics: NeverScrollableScrollPhysics(),
                    slivers: [
                      SliverAppBar(
                        title: Text("Loading..."),
                      ),
                      SliverFillRemaining(
                        child: Center(
                          child: CircularProgressIndicator(),
                        ),
                      )
                    ],
                  );
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
