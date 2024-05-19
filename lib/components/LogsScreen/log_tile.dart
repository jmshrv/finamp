import 'package:clipboard/clipboard.dart';
import 'package:finamp/services/censored_log.dart';
import 'package:finamp/services/contains_login.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:logging/logging.dart';

import '../global_snackbar.dart';

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
          key: PageStorageKey(widget.logRecord.time),
          leading: _LogIcon(level: widget.logRecord.level),
          title: RichText(
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            text: TextSpan(
              text:
                  "[${widget.logRecord.loggerName}]\n${widget.logRecord.time}",
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ),
          subtitle: RichText(
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            text: TextSpan(
              text: widget.logRecord.loginCensoredMessage,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
          expandedAlignment: Alignment.centerLeft,
          expandedCrossAxisAlignment: CrossAxisAlignment.start,
          textColor: _logTextColor(widget.logRecord.level, context),
          collapsedTextColor: _logTextColor(widget.logRecord.level, context),
          iconColor: _logTextColor(widget.logRecord.level, context),
          collapsedIconColor: _logTextColor(widget.logRecord.level, context),
          // Remove the border when expanded
          shape: const Border(),
          childrenPadding: const EdgeInsets.all(8.0),
          children: [
            Text(
              AppLocalizations.of(context)!.message,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            _LogMessageContent(widget.logRecord.message),
            const SizedBox(height: 16.0),
            if (widget.logRecord.stackTrace != null)
              Text(
                AppLocalizations.of(context)!.stackTrace,
                style: Theme.of(context).textTheme.titleLarge,
              ),
            if (widget.logRecord.stackTrace != null)
              _LogMessageContent(widget.logRecord.stackTrace.toString()),
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
      return Theme.of(context).colorScheme.tertiaryContainer;
    } else if (level == Level.SEVERE) {
      return Theme.of(context).colorScheme.errorContainer;
    } else {
      return Theme.of(context).colorScheme.primaryContainer;
    }
  }

  Color _logTextColor(Level level, BuildContext context) {
    if (level == Level.WARNING) {
      return Theme.of(context).colorScheme.onTertiaryContainer;
    } else if (level == Level.SEVERE) {
      return Theme.of(context).colorScheme.onErrorContainer;
    } else {
      return Theme.of(context).colorScheme.onPrimaryContainer;
    }
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

class _LogMessageContent extends StatelessWidget {
  const _LogMessageContent(this.content, {Key? key}) : super(key: key);

  final String content;

  @override
  Widget build(BuildContext context) {
    return Text(
      content,
      style: const TextStyle(
        fontSize: 12.0,
        fontFamily: "monospace",
      ),
    );
  }
}
