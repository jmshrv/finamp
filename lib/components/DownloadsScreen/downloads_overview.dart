import 'package:auto_size_text/auto_size_text.dart';
import 'package:finamp/services/downloads_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get_it/get_it.dart';

import '../../models/finamp_models.dart';
import '../../services/download_update_stream.dart';
import '../../services/isar_downloads.dart';
import '../error_snackbar.dart';

const double downloadsOverviewCardLoadingHeight = 120;

class DownloadsOverview extends StatefulWidget {
  const DownloadsOverview({Key? key}) : super(key: key);

  @override
  State<DownloadsOverview> createState() => _DownloadsOverviewState();
}

class _DownloadsOverviewState extends State<DownloadsOverview> {
  late Future<List<DownloadTask>?> _downloadsOverviewFuture;
  final _downloadUpdateStream = GetIt.instance<DownloadUpdateStream>();
  final isarDownloads = GetIt.instance<IsarDownloads>();

  Map<String, DownloadTaskStatus>? _downloadTaskStatuses;

  final Map<DownloadTaskStatus, int> _downloadCount = {
    DownloadTaskStatus.undefined: 0,
    DownloadTaskStatus.enqueued: 0,
    DownloadTaskStatus.running: 0,
    DownloadTaskStatus.complete: 0,
    DownloadTaskStatus.failed: 0,
    DownloadTaskStatus.canceled: 0,
    DownloadTaskStatus.paused: 0,
  };

  bool _initialCountDone = false;

  @override
  void initState() {
    super.initState();
    _downloadsOverviewFuture = FlutterDownloader.loadTasks();

    // Like in DownloadedIndicator, we use our own listener instead of a
    // StreamBuilder to ensure that we capture all events.
    _downloadUpdateStream.stream.listen((event) {
      if (_downloadTaskStatuses != null &&
          _downloadTaskStatuses!.containsKey(event.id) &&
          _downloadTaskStatuses![event.id] != event.status) {
        setState(() {
          _downloadCount[_downloadTaskStatuses![event.id]!] =
              _downloadCount[_downloadTaskStatuses![event.id]]! - 1;
          _downloadCount[event.status] = _downloadCount[event.status]! + 1;
          _downloadTaskStatuses![event.id] = event.status;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<DownloadTask>?>(
      future: _downloadsOverviewFuture,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          _downloadTaskStatuses ??= Map.fromEntries(
              snapshot.data!.map((e) => MapEntry(e.taskId, e.status)));

          if (!_initialCountDone) {
            // Switch cases don't work for some reason
            for (var element in snapshot.data!) {
              if (element.status == DownloadTaskStatus.undefined) {
                _downloadCount[DownloadTaskStatus.undefined] =
                    _downloadCount[DownloadTaskStatus.undefined]! + 1;
              } else if (element.status == DownloadTaskStatus.enqueued) {
                _downloadCount[DownloadTaskStatus.enqueued] =
                    _downloadCount[DownloadTaskStatus.enqueued]! + 1;
              } else if (element.status == DownloadTaskStatus.running) {
                _downloadCount[DownloadTaskStatus.running] =
                    _downloadCount[DownloadTaskStatus.running]! + 1;
              } else if (element.status == DownloadTaskStatus.complete) {
                _downloadCount[DownloadTaskStatus.complete] =
                    _downloadCount[DownloadTaskStatus.complete]! + 1;
              } else if (element.status == DownloadTaskStatus.failed) {
                _downloadCount[DownloadTaskStatus.failed] =
                    _downloadCount[DownloadTaskStatus.failed]! + 1;
              } else if (element.status == DownloadTaskStatus.canceled) {
                _downloadCount[DownloadTaskStatus.canceled] =
                    _downloadCount[DownloadTaskStatus.canceled]! + 1;
              } else if (element.status == DownloadTaskStatus.paused) {
                _downloadCount[DownloadTaskStatus.paused] =
                    _downloadCount[DownloadTaskStatus.paused]! + 1;
              }
            }
            _initialCountDone = true;
          }

          // We have to awkwardly get two strings like this because Flutter's
          // internationalisation stuff doesn't support multiple plurals.
          // https://github.com/flutter/flutter/issues/86906
          final downloadedItemsString = AppLocalizations.of(context)!
              .downloadedItemsCount(isarDownloads.getDownloadCount(DownloadItemType.song));
          final downloadedImagesString = AppLocalizations.of(context)!
              .downloadedImagesCount(isarDownloads.getDownloadCount(DownloadItemType.image));

          return Card(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AutoSizeText(
                            AppLocalizations.of(context)!
                                .downloadCount(snapshot.data!.length),
                            style: const TextStyle(fontSize: 28),
                            maxLines: 1,
                          ),
                          Text(
                            AppLocalizations.of(context)!
                                .downloadedItemsImagesCount(
                                    downloadedItemsString,
                                    downloadedImagesString),
                            style: const TextStyle(color: Colors.grey),
                          )
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            AppLocalizations.of(context)!.dlComplete(
                                _downloadCount[DownloadTaskStatus.complete]!),
                            style: const TextStyle(color: Colors.green),
                          ),
                          Text(
                            AppLocalizations.of(context)!.dlFailed(
                                _downloadCount[DownloadTaskStatus.failed]!),
                            style: const TextStyle(color: Colors.red),
                          ),
                          Text(
                            AppLocalizations.of(context)!.dlEnqueued(
                                _downloadCount[DownloadTaskStatus.enqueued]!),
                            style: const TextStyle(color: Colors.grey),
                          ),
                          Text(
                            AppLocalizations.of(context)!.dlRunning(
                                _downloadCount[DownloadTaskStatus.running]!),
                            style: const TextStyle(color: Colors.grey),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
        } else if (snapshot.hasError) {
          errorSnackbar(snapshot.error, context);
          return const SizedBox(
            height: downloadsOverviewCardLoadingHeight,
            child: Card(
              child: Icon(Icons.error),
            ),
          );
        } else {
          return const SizedBox(
            height: downloadsOverviewCardLoadingHeight,
            child: Card(
              child: Center(child: CircularProgressIndicator.adaptive()),
            ),
          );
        }
      },
    );
  }
}
