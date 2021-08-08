import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../components/LogsScreen/LogsView.dart';
import '../services/FinampLogsHelper.dart';

class LogsScreen extends StatefulWidget {
  const LogsScreen({Key? key}) : super(key: key);

  static const List<Tab> tabs = [
    Tab(text: "MAIN THREAD"),
    Tab(text: "AUDIO SERVICE"),
  ];

  @override
  _LogsScreenState createState() => _LogsScreenState();
}

class _LogsScreenState extends State<LogsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = new TabController(
      vsync: this,
      length: LogsScreen.tabs.length,
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    FinampLogsHelper finampLogsHelper = GetIt.instance<FinampLogsHelper>();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Logs"),
        bottom: TabBar(
          tabs: LogsScreen.tabs,
          controller: _tabController,
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.copy),
            onPressed: () async {
              if (_tabController.index == 0) {
                await finampLogsHelper.copyLogs();
                ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Main thread logs copied.")));
              } else {
                if (!AudioService.running) {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text("Audio service is not running.")));
                } else {
                  await AudioService.customAction("copyLogs");
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text("Audio service logs copied.")));
                }
              }
            },
          )
        ],
      ),
      body: TabBarView(
        controller: _tabController,
        children: const [
          LogsView(isMusicPlayerBackgroundTask: false),
          LogsView(isMusicPlayerBackgroundTask: true),
        ],
      ),
    );
  }
}
