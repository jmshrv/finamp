import 'package:clipboard/clipboard.dart';
import 'package:flutter/material.dart';

import '../../models/FinampModels.dart';
import '../errorSnackbar.dart';

class LogTile extends StatelessWidget {
  const LogTile({Key? key, required this.logRecord}) : super(key: key);

  final FinampLogRecord logRecord;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: () async {
        try {
          String logsString =
              "[${logRecord.loggerName}/${logRecord.level.name}] ${logRecord.time}: ${logRecord.message}\n\n${logRecord.stackTrace.toString()}";
          await FlutterClipboard.copy(logsString);
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text("Log record copied")));
        } catch (e) {
          errorSnackbar(e, context);
        }
      },
      child: Card(
        color: _logColor(logRecord.level, context),
        child: ExpansionTile(
          leading: _logIcon(logRecord.level, context),
          key: PageStorageKey(logRecord.time),
          title: RichText(
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
            text: TextSpan(
              children: <TextSpan>[
                TextSpan(
                  text: "[${logRecord.loggerName}] ",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                TextSpan(
                  text: "[${logRecord.time}] ",
                  style: TextStyle(fontWeight: FontWeight.bold),
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
              style: Theme.of(context).textTheme.headline5,
            ),
            Text(logRecord.message),
            // This empty bit of text adds some space between the message and trace
            Text(""),
            Text("Stack Trace", style: Theme.of(context).textTheme.headline5),
            Text(logRecord.stackTrace.toString())
          ],
        ),
      ),
    );
  }

  Icon _logIcon(FinampLevel level, BuildContext context) {
    Color? iconColor = Theme.of(context).iconTheme.color;

    if (level == FinampLevel.INFO) {
      return Icon(
        Icons.info,
        color: iconColor,
      );
    } else if (level == FinampLevel.WARNING) {
      return Icon(
        Icons.warning,
        color: iconColor,
      );
    } else if (level == FinampLevel.SEVERE) {
      return Icon(
        Icons.error,
        color: iconColor,
      );
    } else {
      return Icon(
        Icons.info,
        color: iconColor,
      );
    }
  }

  Color _logColor(FinampLevel level, BuildContext context) {
    if (level == FinampLevel.INFO) {
      return Colors.blue;
    } else if (level == FinampLevel.WARNING) {
      return Colors.orange;
    } else if (level == FinampLevel.SEVERE) {
      return Colors.red;
    } else {
      return Theme.of(context).cardColor;
    }
  }
}
