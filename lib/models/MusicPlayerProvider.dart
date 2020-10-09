import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';
import 'package:just_audio/just_audio.dart';

import 'JellyfinModels.dart';
import '../services/JellyfinApiData.dart';

/// This provider handles the currently playing music so that multiple widgets can control music.
class MusicPlayerProvider with ChangeNotifier {
  JellyfinApiData _jellyfinApiData = GetIt.instance<JellyfinApiData>();

  final player = AudioPlayer();

  Future<void> setUrl(BaseItemDto item) async {
    String baseUrl = await _jellyfinApiData.getBaseUrl();
    print(
        "Setting audio URL to $baseUrl/Audio/${item.id}/stream?Container=flac");
    player.setUrl("$baseUrl/Audio/${item.id}/stream?Container=flac");
    player.play();
    notifyListeners();
  }
}
