import 'package:flutter/material.dart';

import '../components/LogsScreen/LogsView.dart';
import '../services/FinampLogsHelper.dart';

class LogsScreen extends StatelessWidget {
  const LogsScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Logs"),
        actions: [
          IconButton(
            icon: Icon(Icons.copy),
            onPressed: () async {
              await FinampLogsHelper.copyLogs();
              ScaffoldMessenger.of(context)
                  .showSnackBar(SnackBar(content: Text("Logs copied")));
            },
          )
        ],
      ),
      body: LogsView(),
    );
  }
}
