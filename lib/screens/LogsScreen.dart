import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../components/LogsScreen/LogsView.dart';
import '../services/FinampLogsHelper.dart';

class LogsScreen extends StatelessWidget {
  const LogsScreen({Key key}) : super(key: key);

  static const List<Tab> tabs = [
    Tab(text: "Main Thread"),
    Tab(text: "Audio Service"),
  ];

  @override
  Widget build(BuildContext context) {
    FinampLogsHelper finampLogsHelper = GetIt.instance<FinampLogsHelper>();

    return DefaultTabController(
      length: tabs.length,
      child: Scaffold(
        appBar: AppBar(
          title: Text("Logs"),
          bottom: TabBar(tabs: LogsScreen.tabs),
          actions: [
            IconButton(
              icon: Icon(Icons.copy),
              onPressed: () async {
                await finampLogsHelper.copyLogs();
                ScaffoldMessenger.of(context)
                    .showSnackBar(SnackBar(content: Text("Logs copied")));
              },
            )
          ],
        ),
        body: TabBarView(
          children: [
            LogsView(isMusicPlayerBackgroundTask: false),
            LogsView(isMusicPlayerBackgroundTask: true),
          ],
        ),
        // body: LogsView(),
      ),
    );
  }
}
