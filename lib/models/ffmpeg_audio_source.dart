import 'dart:io';

import 'package:ffmpeg_kit_flutter/ffmpeg_kit.dart';
import 'package:ffmpeg_kit_flutter/ffmpeg_kit_config.dart';
import 'package:ffmpeg_kit_flutter/ffmpeg_session.dart';
import 'package:just_audio/just_audio.dart';

class FFmpegAudioSource extends StreamAudioSource {
  final Uri _uri;

  File? _pipe;
  FFmpegSession? _session;

  FFmpegAudioSource(Uri uri, {super.tag}) : _uri = uri;

  Future<FFmpegSession> createSession() async {
    final newPipe = await FFmpegKitConfig.registerNewFFmpegPipe();

    if (newPipe == null) {
      throw "Pipe is null!";
    }

    _pipe = File(newPipe);

    return await FFmpegKit.executeAsync(
      "-i $_uri -map 0:a -f wav -y $newPipe",
      null,
      (log) => print(log.getMessage()),
    );
  }

  @override
  Future<StreamAudioResponse> request([int? start, int? end]) async {
    _session ??= await createSession();

    final stat = await _pipe!.stat();
    final size = stat.size;

    start ??= 0;
    end ??= size;

    print("FD size: $size");

    return StreamAudioResponse(
        sourceLength: size,
        contentLength: end - start,
        offset: start,
        stream: _pipe!.openRead(start, end),
        contentType: "audio/vnd.wave");
  }
}
