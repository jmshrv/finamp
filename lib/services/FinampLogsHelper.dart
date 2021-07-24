import 'package:clipboard/clipboard.dart';
import 'package:get_it/get_it.dart';

import '../services/JellyfinApiData.dart';
import '../models/FinampModels.dart';

class FinampLogsHelper {
  final List<FinampLogRecord> logs = [];

  void addLog(FinampLogRecord log) {
    logs.add(log);

    // We don't want to keep logs forever due to memory constraints.
    if (logs.length > 1000) {
      logs.removeAt(0);
    }
  }

  Future<void> copyLogs() async {
    final currentUser = GetIt.instance<JellyfinApiData>().currentUser;
    String logsString = "";

    for (final log in logs) {
      logsString +=
          "[${log.loggerName}/${log.level.name}] ${log.time}: ${log.message}\n\n${log.stackTrace.toString()}\n"
              .replaceAll(currentUser!.baseUrl, "BASEURL")
              .replaceAll(currentUser.accessToken,
                  "${currentUser.accessToken.substring(0, 4)}...");
    }

    await FlutterClipboard.copy(logsString);
  }
}
