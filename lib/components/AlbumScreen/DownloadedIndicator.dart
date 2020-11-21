import 'dart:isolate';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:get_it/get_it.dart';

import '../../services/DownloadsHelper.dart';
import '../../models/JellyfinModels.dart';
import '../../components/errorSnackbar.dart';

class DownloadedIndicator extends StatefulWidget {
  DownloadedIndicator({Key key, @required this.item}) : super(key: key);

  final BaseItemDto item;

  @override
  _DownloadedIndicatorState createState() => _DownloadedIndicatorState();
}

class _DownloadedIndicatorState extends State<DownloadedIndicator> {
  ReceivePort _port = ReceivePort();

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

  @override
  Widget build(BuildContext context) {
    DownloadsHelper downloadsHelper = GetIt.instance<DownloadsHelper>();

    return FutureBuilder<DownloadTask>(
      // I know it's usually bad practice to directly call a function in a FutureBuilder but I want the function to rerun every setState.
      future: downloadsHelper.getDownloadStatus(widget.item.id),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          DownloadTask downloadTask = snapshot.data;
          if (downloadTask.status == DownloadTaskStatus.complete) {
            return Icon(
              Icons.file_download,
              color: Colors.green,
            );
          } else if (downloadTask.status == DownloadTaskStatus.failed ||
              downloadTask.status == DownloadTaskStatus.undefined) {
            return Icon(
              Icons.error,
              color: Colors.red,
            );
          } else if (downloadTask.status == DownloadTaskStatus.paused) {
            return Icon(
              Icons.pause,
              color: Colors.yellow,
            );
          } else if (downloadTask.status == DownloadTaskStatus.enqueued ||
              downloadTask.status == DownloadTaskStatus.running) {
            return Icon(
              Icons.download_outlined,
              color: Colors.white.withOpacity(0.5),
            );
          } else {
            return Container(width: 0, height: 0);
          }
        } else if (snapshot.hasError) {
          errorSnackbar(snapshot.error, context);
          return Container(width: 0, height: 0);
        } else {
          return Container(width: 0, height: 0);
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
