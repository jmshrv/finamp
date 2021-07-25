import 'dart:isolate';
import 'dart:ui';

import 'package:finamp/services/DownloadsHelper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:get_it/get_it.dart';

import '../errorSnackbar.dart';
import '../AlbumImage.dart';

class CurrentDownloadsList extends StatefulWidget {
  CurrentDownloadsList({Key? key}) : super(key: key);

  @override
  _CurrentDownloadsListState createState() => _CurrentDownloadsListState();
}

class _CurrentDownloadsListState extends State<CurrentDownloadsList> {
  ReceivePort _port = ReceivePort();
  DownloadsHelper _downloadsHelper = GetIt.instance<DownloadsHelper>();

  @override
  void initState() {
    super.initState();

    IsolateNameServer.registerPortWithName(
        _port.sendPort, 'downloader_send_port');
    _port.listen((dynamic data) {
      setState(() {});
    });

    FlutterDownloader.registerCallback(downloadCallback);
  }

  @override
  void dispose() {
    IsolateNameServer.removePortNameMapping('downloader_send_port');
    super.dispose();
  }

  static void downloadCallback(
      String id, DownloadTaskStatus status, int progress) {
    final SendPort? send =
        IsolateNameServer.lookupPortByName('downloader_send_port');
    send?.send([id, status, progress]);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<DownloadTask>?>(
      future: _downloadsHelper.getIncompleteDownloads(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return SliverList(
            delegate:
                SliverChildBuilderDelegate((BuildContext context, int index) {
              return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CurrentDownloadListTile(
                    downloadTask: snapshot.data![index],
                  ));
            }, childCount: snapshot.data!.length),
          );
        } else if (snapshot.hasError) {
          errorSnackbar(snapshot.error, context);
          return SliverList(
              delegate: SliverChildListDelegate(
                  [Text("An error occured while getting current downloads")]));
        } else {
          return SliverList(delegate: SliverChildListDelegate([]));
        }
      },
    );
  }
}

class CurrentDownloadListTile extends StatelessWidget {
  const CurrentDownloadListTile({Key? key, required this.downloadTask})
      : super(key: key);

  final DownloadTask downloadTask;

  @override
  Widget build(BuildContext context) {
    DownloadsHelper downloadsHelper = GetIt.instance<DownloadsHelper>();
    DownloadedSong? item =
        downloadsHelper.getJellyfinItemFromDownloadId(downloadTask.taskId);

    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        LinearProgressIndicator(
          value: downloadTask.progress / 100,
          backgroundColor: Colors.transparent,
        ),
        ListTile(
          leading: AlbumImage(
            itemId: item?.song.parentId,
            blurHash: item?.song.imageBlurHashes?.primary?.values.first,
          ),
          title: Text(item?.song.name ?? "???"),
          subtitle: Text(item?.song.albumArtist ?? "???"),
        )
      ],
    );
  }
}
