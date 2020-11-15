import 'dart:convert';
import 'dart:io';

import 'package:finamp/models/JellyfinModels.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:get_it/get_it.dart';
import 'package:path_provider/path_provider.dart';

import '../services/JellyfinApiData.dart';

class DownloadsProvider with ChangeNotifier {
  List<String> queue = [];
  Directory _songDir;
  JellyfinApiData _jellyfinApiData = GetIt.instance<JellyfinApiData>();

  Future<void> addDownload(BaseItemDto id) async {
    Directory songDir = await _getSongDir();

    List<BaseItemDto> songs = await _jellyfinApiData.getItems(
      parentItem: id,
      includeItemTypes: "Audio",
    );

    String baseUrl = await _jellyfinApiData.getBaseUrl();

    for (BaseItemDto song in songs) {
      String songUrl = baseUrl + "/Items/${song.id}/File";
      Future songInfoFuture =
          File("${songDir.path}/${song.id}-BaseItemDto.json")
              .writeAsString(json.encode(song));

      List<MediaSourceInfo> mediaSourceInfo =
          await _jellyfinApiData.getPlaybackInfo(song.id);

      Future mediaSourceInfoFuture =
          File("${songDir.path}/${song.id}-MediaSourceInfo.json")
              .writeAsString(json.encode(mediaSourceInfo[0]));

      queue.add(await FlutterDownloader.enqueue(
        url: songUrl,
        savedDir: songDir.path,
        headers: {
          // "X-Emby-Authorization": await _jellyfinApiData.getAuthHeader(),
          "X-Emby-Token": await _jellyfinApiData.getTokenHeader()
        },
        fileName: song.id + ".${mediaSourceInfo[0].container}",
        openFileFromNotification: false,
        showNotification: false,
      ));
      await Future.wait([songInfoFuture, mediaSourceInfoFuture]);
    }
    notifyListeners();
  }

  Future<Directory> _getSongDir() async {
    if (_songDir == null) {
      Directory appDir = await getApplicationDocumentsDirectory();
      _songDir = Directory(appDir.path + "/songs");
      if (!await _songDir.exists()) {
        await _songDir.create();
      }
      return _songDir;
    } else {
      return _songDir;
    }
  }
}
