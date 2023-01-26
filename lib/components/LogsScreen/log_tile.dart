import 'package:clipboard/clipboard.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get_it/get_it.dart';
import 'package:logging/logging.dart';

import '../../services/finamp_logs_helper.dart';
import '../error_snackbar.dart';

class LogTile extends StatelessWidget {
  const LogTile({Key? key, required this.logRecord}) : super(key: key);

  final LogRecord logRecord;

  @override
  Widget build(BuildContext context) {
    final finampLogsHelper = GetIt.instance<FinampLogsHelper>();

    return GestureDetector(
      onLongPress: () async {
        try {
          await FlutterClipboard.copy(finampLogsHelper.sanitiseLog(logRecord));
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
              AppLocalizations.of(context)!.message,
              style: Theme.of(context).primaryTextTheme.headlineSmall,
            ),
            Text(
              "${logRecord.message}\n",
              style: Theme.of(context).primaryTextTheme.bodyMedium,
            ),
            Text(
              AppLocalizations.of(context)!.stackTrace,
              style: Theme.of(context).primaryTextTheme.headlineSmall,
            ),
            Text(
              logRecord.stackTrace.toString(),
              style: Theme.of(context).primaryTextTheme.bodyMedium,
            )
          ],
        ),
      ),
    );
  }

  Color _logColor(Level level, BuildContext context) {
    if (level == Level.WARNING) {
      return Colors.orange;
    } else if (level == Level.SEVERE) {
      return Colors.red;
    }

    return Theme.of(context).colorScheme.secondary;
  }
}

class _LogIcon extends StatelessWidget {
  const _LogIcon({Key? key, required this.level}) : super(key: key);

  final Level level;

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).primaryIconTheme.color;

    if (level == Level.INFO) {
      return Icon(
        Icons.info,
        color: color,
      );
    } else if (level == Level.WARNING) {
      return Icon(
        Icons.warning,
        color: color,
      );
    } else if (level == Level.SEVERE) {
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
