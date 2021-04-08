import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

import 'LogTile.dart';
import '../../services/FinampLogsHelper.dart';
import '../../models/FinampModels.dart';

class LogsView extends StatelessWidget {
  const LogsView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Box<FinampLogRecord>>(
      valueListenable: FinampLogsHelper.finampLogsListener,
      builder: (context, box, child) {
        return Scrollbar(
          child: ListView.builder(
            itemCount: FinampLogsHelper.finampLogs.length,
            itemBuilder: (context, index) {
              return LogTile(logRecord: box.getAt(index));
            },
          ),
        );
      },
    );
  }
}
