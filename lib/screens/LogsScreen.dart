import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../components/LogsScreen/LogsView.dart';
import '../services/FinampLogsHelper.dart';
import '../services/MusicPlayerBackgroundTask.dart';

class LogsScreen extends StatelessWidget {
  const LogsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    FinampLogsHelper finampLogsHelper = GetIt.instance<FinampLogsHelper>();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Logs"),
        actions: [
          IconButton(
            icon: const Icon(Icons.copy),
            onPressed: () async {
              await finampLogsHelper.copyLogs();
              ScaffoldMessenger.of(context)
                  .showSnackBar(const SnackBar(content: Text("Logs copied.")));
            },
          )
        ],
      ),
      body: const LogsView(),
    );
  }
}
