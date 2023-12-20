import 'package:clipboard/clipboard.dart';
import 'package:finamp/services/censored_log.dart';
import 'package:finamp/services/contains_login.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:logging/logging.dart';

import '../error_snackbar.dart';

class LogTile extends StatefulWidget {
  const LogTile({Key? key, required this.logRecord}) : super(key: key);

  final LogRecord logRecord;

  @override
  State<LogTile> createState() => _LogTileState();
}

class _LogTileState extends State<LogTile> {
  final _controller = ExpansionTileController();

  /// Whether the user has confirmed. This is used to stop onExpansionChanged
  /// from infinitely asking the user to confirm.
  bool hasConfirmed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: () async {
        try {
          await FlutterClipboard.copy(widget.logRecord.censoredMessage);
        } catch (e) {
          errorSnackbar(e, context);
        }
      },
      child: Card(
        color: _logColor(widget.logRecord.level, context),
        child: ExpansionTile(
          controller: _controller,
          leading: _LogIcon(level: widget.logRecord.level),
          key: PageStorageKey(widget.logRecord.time),
          title: RichText(
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
            text: TextSpan(
              children: <TextSpan>[
                TextSpan(
                  text: "[${widget.logRecord.loggerName}] ",
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                TextSpan(
                  text: "[${widget.logRecord.time}] ",
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                TextSpan(
                  text: widget.logRecord.loginCensoredMessage,
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
              "${widget.logRecord.message}\n",
              style: Theme.of(context).primaryTextTheme.bodyMedium,
            ),
            Text(
              AppLocalizations.of(context)!.stackTrace,
              style: Theme.of(context).primaryTextTheme.headlineSmall,
            ),
            Text(
              widget.logRecord.stackTrace.toString(),
              style: Theme.of(context).primaryTextTheme.bodyMedium,
            )
          ],
          onExpansionChanged: (value) async {
            if (value && !hasConfirmed && widget.logRecord.containsLogin) {
              _controller.collapse();

              final confirmed = await showDialog<bool>(
                context: context,
                barrierDismissible: false,
                builder: (context) {
                  return AlertDialog(
                    title: Text(AppLocalizations.of(context)!.confirm),
                    content: Text(
                        AppLocalizations.of(context)!.showUncensoredLogMessage),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(false),
                        child: Text(MaterialLocalizations.of(context)
                            .cancelButtonLabel),
                      ),
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(true),
                        child: Text(AppLocalizations.of(context)!.confirm),
                      ),
                    ],
                  );
                },
              );

              hasConfirmed = confirmed!;

              if (confirmed) {
                _controller.expand();
              }
            } else if (hasConfirmed) {
              hasConfirmed = false;
            }
          },
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

    return Theme.of(context).colorScheme.surfaceVariant;
  }
}

class _LogIcon extends StatelessWidget {
  const _LogIcon({Key? key, required this.level}) : super(key: key);

  final Level level;

  @override
  Widget build(BuildContext context) {
    if (level == Level.INFO) {
      return const Icon(Icons.info);
    } else if (level == Level.WARNING) {
      return const Icon(Icons.warning);
    } else if (level == Level.SEVERE) {
      return const Icon(Icons.error);
    } else {
      return const Icon(Icons.info);
    }
  }
}