import 'package:flutter/material.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:get_it/get_it.dart';

import 'downloads_helper.dart';

class ConnectivityChangeNotifier extends ChangeNotifier {
  DownloadsHelper downloadsHelper = GetIt.instance<DownloadsHelper>();
  ConnectivityResult connectivityResult = ConnectivityResult.none;

  ConnectivityChangeNotifier() {
    Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
      resultHandler(result);
    });
  }

  // TODO: Load the initial load from main.dart
  void initialLoad() async {
    ConnectivityResult connectivityResult =
        await (Connectivity().checkConnectivity());
    resultHandler(connectivityResult);
  }

  void resultHandler(ConnectivityResult result) async {
    if (connectivityResult != result) {
      connectivityResult = result;
      // TODO: ... and check for switch
      if (connectivityResult == ConnectivityResult.mobile) {
        downloadsHelper.pause(await getRunningDownloadTaskIds());
        // TODO: ... and check for switch
      } else if (connectivityResult == ConnectivityResult.wifi) {}
      downloadsHelper.resume(await getPausedDownloadTaskIds());
    }
    notifyListeners();
  }

  Future<List<String>> getRunningDownloadTaskIds() async {
    List<DownloadTask> downloads = [];
    downloads.addAll(await downloadsHelper
            .getDownloadsWithStatus(DownloadTaskStatus.enqueued) ??
        []);
    downloads.addAll(await downloadsHelper
            .getDownloadsWithStatus(DownloadTaskStatus.running) ??
        []);
    return downloads.map((e) => e.taskId).toList();
  }

  Future<List<String>> getPausedDownloadTaskIds() async {
    List<DownloadTask> downloads = [];
    downloads.addAll(await downloadsHelper
        .getDownloadsWithStatus(DownloadTaskStatus.paused) ??
        []);
    return downloads.map((e) => e.taskId).toList();
  }
}
