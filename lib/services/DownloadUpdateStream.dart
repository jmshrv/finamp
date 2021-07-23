import 'dart:async';
import 'dart:isolate';
import 'dart:ui';

import 'package:flutter_downloader/flutter_downloader.dart';

class DownloadUpdate {
  DownloadUpdate({
    required this.id,
    required this.status,
    required this.progress,
  });

  final String id;
  final DownloadTaskStatus status;
  final int progress;
}

/// This stream is used to provide download updates in the UI. A single callback
/// in main.dart adds all of flutter_downloader's events to this stream so that
/// changes can be easily listened to in widgets.
class DownloadUpdateStream {
  ReceivePort _port = ReceivePort();
  // ignore: close_sinks
  final _controller = StreamController<DownloadUpdate>.broadcast();

  Stream<DownloadUpdate> get stream => _controller.stream;

  void setupSendPort() {
    IsolateNameServer.registerPortWithName(
        _port.sendPort, 'downloader_send_port');
    _port.listen((dynamic data) {
      String id = data[0];
      DownloadTaskStatus status = data[1];
      int progress = data[2];

      add(DownloadUpdate(
        id: id,
        status: status,
        progress: progress,
      ));
    });
  }

  void addPrintListener() => stream.listen((event) {
        print("NEW EVENT ${event.id} ${event.status} ${event.progress}");
        if (event.status == DownloadTaskStatus.complete) {
          print("PRINT LISTENER COMPLETE ${event.id}");
        }
      });

  /// Add a new download update to the download update stream.
  void add(DownloadUpdate downloadUpdate) => _controller.add(downloadUpdate);
}
