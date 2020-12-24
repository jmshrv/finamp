import 'dart:isolate';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:get_it/get_it.dart';

import '../../models/JellyfinModels.dart';
import '../../services/DownloadsHelper.dart';

class DownloadButton extends StatefulWidget {
  DownloadButton({Key key, @required this.parent, @required this.items})
      : super(key: key);

  final BaseItemDto parent;
  final List<BaseItemDto> items;

  @override
  _DownloadButtonState createState() => _DownloadButtonState();
}

class _DownloadButtonState extends State<DownloadButton> {
  // TODO: See if there's a way to use mixins or something so that the callback stuff doesn't have to be duplicated
  ReceivePort _port = ReceivePort();
  Future<List<DownloadTask>> downloadButtonFuture;
  DownloadsHelper downloadsHelper = GetIt.instance<DownloadsHelper>();

  static const Icon downloadIcon = Icon(Icons.file_download);
  static const Icon deleteIcon = Icon(Icons.delete);

  @override
  void initState() {
    super.initState();
    downloadButtonFuture = downloadsHelper
        .getDownloadStatus(widget.items.map((e) => e.id).toList());
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

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<DownloadTask>>(
      future: downloadButtonFuture,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List<DownloadTask> downloadTasks = snapshot.data;
          if (downloadTasks
              .where((element) => element.status == DownloadTaskStatus.complete)
              .toList()
              .isNotEmpty) {
            return IconButton(
              icon: deleteIcon,
              onPressed: () async =>
                  await downloadsHelper.deleteDownloads(downloadTasks),
            );
          } else {
            return IconButton(
              icon: downloadIcon,
              onPressed: () async => await downloadsHelper.addDownloads(
                  items: widget.items, parent: widget.parent),
            );
          }
        } else {
          return IconButton(icon: downloadIcon, onPressed: null);
        }
      },
    );
  }

  static void downloadCallback(
      String id, DownloadTaskStatus status, int progress) {
    final SendPort send =
        IsolateNameServer.lookupPortByName('downloader_send_port');
    send.send([id, status, progress]);
  }
}
