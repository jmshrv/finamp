import 'dart:isolate';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';

import '../../components/errorSnackbar.dart';
import 'DownloadsFileSize.dart';

class DownloadsOverview extends StatefulWidget {
  DownloadsOverview({Key key}) : super(key: key);

  @override
  _DownloadsOverviewState createState() => _DownloadsOverviewState();
}

class _DownloadsOverviewState extends State<DownloadsOverview> {
  ReceivePort _port = ReceivePort();
  static const double cardLoadingHeight = 120;

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
    final SendPort send =
        IsolateNameServer.lookupPortByName('downloader_send_port');
    send.send([id, status, progress]);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<DownloadTask>>(
      future: FlutterDownloader.loadTasks(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List<DownloadTask> downloadTasks = snapshot.data;
          return Card(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    RichText(
                      text: TextSpan(
                        children: <TextSpan>[
                          TextSpan(
                            text: downloadTasks.length.toString(),
                            style: TextStyle(fontSize: 48),
                          ),
                          TextSpan(
                            text: " downloads",
                            style: TextStyle(fontSize: 24, color: Colors.grey),
                          ),
                        ],
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          "${downloadTasks.where((element) => element.status == DownloadTaskStatus.complete).length} complete",
                          style: TextStyle(color: Colors.green),
                        ),
                        Text(
                          "${downloadTasks.where((element) => element.status == DownloadTaskStatus.failed).length} failed",
                          style: TextStyle(color: Colors.red),
                        ),
                        Text(
                          "${downloadTasks.where((element) => element.status == DownloadTaskStatus.enqueued).length} enqueued",
                          style: TextStyle(color: Colors.grey),
                        ),
                        Text(
                          "${downloadTasks.where((element) => element.status == DownloadTaskStatus.running).length} running",
                          style: TextStyle(color: Colors.grey),
                        ),
                        Text(
                          "${downloadTasks.where((element) => element.status == DownloadTaskStatus.paused).length} paused",
                          style: TextStyle(color: Colors.grey),
                        ),
                        DownloadsFileSize(),
                      ],
                    )
                  ],
                ),
              ),
            ),
          );
        } else if (snapshot.hasError) {
          errorSnackbar(snapshot.error, context);
          return SizedBox(
            height: cardLoadingHeight,
            child: Card(
              child: Icon(Icons.error),
            ),
          );
        } else {
          return SizedBox(
            height: cardLoadingHeight,
            child: Card(
              child: Center(child: CircularProgressIndicator()),
            ),
          );
        }
      },
    );
  }
}
