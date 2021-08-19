import 'dart:convert';

import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import 'LogTile.dart';
import '../../services/FinampLogsHelper.dart';
import '../../models/FinampModels.dart';
import '../errorSnackbar.dart';

class LogsView extends StatefulWidget {
  const LogsView({
    Key? key,
    required this.isMusicPlayerBackgroundTask,
  }) : super(key: key);

  final bool isMusicPlayerBackgroundTask;

  @override
  _LogsViewState createState() => _LogsViewState();
}

class _LogsViewState extends State<LogsView> {
  final _audioHandler = GetIt.instance<AudioHandler>();
  late Future<dynamic> logsViewFuture;

  @override
  void initState() {
    super.initState();
    if (widget.isMusicPlayerBackgroundTask &&
        _audioHandler.playbackState.hasValue &&
        _audioHandler.playbackState.value.processingState !=
            AudioProcessingState.idle) {
      logsViewFuture = _audioHandler.customAction("getLogs");
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.isMusicPlayerBackgroundTask) {
      if (_audioHandler.playbackState.hasValue &&
          _audioHandler.playbackState.value.processingState ==
              AudioProcessingState.idle) {
        return const Center(
          child: Text("Audio service is not running"),
        );
      }
      return FutureBuilder<dynamic>(
        future: logsViewFuture,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<FinampLogRecord> logs = [];

            for (final log in jsonDecode(snapshot.data!)) {
              logs.add(FinampLogRecord.fromJson(log));
            }

            return Scrollbar(
              child: ListView.builder(
                itemCount: logs.length,
                reverse: true,
                itemBuilder: (context, index) {
                  return LogTile(logRecord: logs.reversed.elementAt(index));
                },
              ),
            );
          } else if (snapshot.hasError) {
            errorSnackbar(snapshot.error, context);
            return const Center(
              child: Text("Audio service logs failed to load somehow."),
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      );
    } else {
      FinampLogsHelper finampLogsHelper = GetIt.instance<FinampLogsHelper>();

      return Scrollbar(
        child: ListView.builder(
          itemCount: finampLogsHelper.logs.length,
          reverse: true,
          itemBuilder: (context, index) {
            return LogTile(
                logRecord: finampLogsHelper.logs.reversed.elementAt(index));
          },
        ),
      );
    }
  }
}
