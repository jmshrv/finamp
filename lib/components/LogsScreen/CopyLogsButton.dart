import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../../services/FinampLogsHelper.dart';

class CopyLogsButton extends StatelessWidget {
  const CopyLogsButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.copy),
      onPressed: () async {
        final finampLogsHelper = GetIt.instance<FinampLogsHelper>();

        await finampLogsHelper.copyLogs();
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text("Logs copied.")));
      },
    );
  }
}
