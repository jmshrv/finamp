import 'package:clipboard/clipboard.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../../services/FinampLogsHelper.dart';
import '../../models/FinampModels.dart';
import '../errorSnackbar.dart';

class LogTile extends StatelessWidget {
  const LogTile({Key? key, required this.logRecord}) : super(key: key);

  final FinampLogRecord logRecord;

  @override
  Widget build(BuildContext context) {
    final _finampLogsHelper = GetIt.instance<FinampLogsHelper>();

    return GestureDetector(
      onLongPress: () async {
        try {
          await FlutterClipboard.copy(_finampLogsHelper.sanitiseLog(logRecord));
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Log record copied.")));
        } catch (e) {
          errorSnackbar(e, context);
        }
      },
      child: Card(
        color: _logColor(logRecord.level, context),
        child: ExpansionTile(
          leading: _LogIcon(level: logRecord.level),
          key: PageStorageKey(logRecord.time),
          title: RichText(
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
            text: TextSpan(
              children: <TextSpan>[
                TextSpan(
                  text: "[${logRecord.loggerName}] ",
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                TextSpan(
                  text: "[${logRecord.time}] ",
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                TextSpan(
                  text: logRecord.message,
                ),
              ],
            ),
          ),
          childrenPadding: const EdgeInsets.all(8.0),
          expandedCrossAxisAlignment: CrossAxisAlignment.start,
          expandedAlignment: Alignment.centerLeft,
          children: [
            Text(
              "Message",
              style: Theme.of(context).primaryTextTheme.headline5,
            ),
            Text(
              logRecord.message + "\n",
              style: Theme.of(context).primaryTextTheme.bodyText2,
            ),
            Text(
              "Stack Trace",
              style: Theme.of(context).primaryTextTheme.headline5,
            ),
            Text(
              logRecord.stackTrace.toString(),
              style: Theme.of(context).primaryTextTheme.bodyText2,
            )
          ],
        ),
      ),
    );
  }

  Color _logColor(FinampLevel level, BuildContext context) {
    if (level == FinampLevel.WARNING) {
      return Colors.orange;
    } else if (level == FinampLevel.SEVERE) {
      return Colors.red;
    }

    return Theme.of(context).colorScheme.secondary;
  }
}

class _LogIcon extends StatelessWidget {
  const _LogIcon({Key? key, required this.level}) : super(key: key);

  final FinampLevel level;

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).primaryIconTheme.color;

    if (level == FinampLevel.INFO) {
      return Icon(
        Icons.info,
        color: color,
      );
    } else if (level == FinampLevel.WARNING) {
      return Icon(
        Icons.warning,
        color: color,
      );
    } else if (level == FinampLevel.SEVERE) {
      return Icon(
        Icons.error,
        color: color,
      );
    }

    return Icon(
      Icons.info,
      color: color,
    );
  }
}
