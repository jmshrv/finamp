import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import 'LogTile.dart';
import '../../services/FinampLogsHelper.dart';

class LogsView extends StatelessWidget {
  const LogsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
