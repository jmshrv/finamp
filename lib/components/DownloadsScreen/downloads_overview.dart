import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get_it/get_it.dart';
import 'package:logging/logging.dart';

import '../../models/finamp_models.dart';
import '../../services/isar_downloads.dart';
import '../error_snackbar.dart';

const double downloadsOverviewCardLoadingHeight = 120;

class DownloadsOverview extends StatefulWidget {
  const DownloadsOverview({Key? key}) : super(key: key);

  @override
  State<DownloadsOverview> createState() => _DownloadsOverviewState();
}

class _DownloadsOverviewState extends State<DownloadsOverview> {
  final isarDownloads = GetIt.instance<IsarDownloads>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Map<DownloadItemState, int>>(
      stream: isarDownloads.downloadStatusesStream,
      initialData: isarDownloads.downloadStatuses,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          // We have to awkwardly get two strings like this because Flutter's
          // internationalisation stuff doesn't support multiple plurals.
          // https://github.com/flutter/flutter/issues/86906
          final downloadedItemsString = AppLocalizations.of(context)!
              .downloadedItemsCount(
                  isarDownloads.getDownloadCount(type: DownloadItemType.song));
          final downloadedImagesString = AppLocalizations.of(context)!
              .downloadedImagesCount(
                  isarDownloads.getDownloadCount(type: DownloadItemType.image));
          final downloadCount =
              (snapshot.data?[DownloadItemState.complete] ?? 0) +
                  (snapshot.data?[DownloadItemState.failed] ?? 0) +
                  (snapshot.data?[DownloadItemState.enqueued] ?? 0) +
                  (snapshot.data?[DownloadItemState.downloading] ?? 0);

          Logger("overview").severe("rebuilt");
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
                            AppLocalizations.of(context)!.downloadCount(downloadCount),
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
                                snapshot.data?[DownloadItemState.complete] ??
                                    -1),
                            style: const TextStyle(color: Colors.green),
                          ),
                          Text(
                            AppLocalizations.of(context)!.dlFailed(
                                snapshot.data?[DownloadItemState.failed] ?? -1),
                            style: const TextStyle(color: Colors.red),
                          ),
                          Text(
                            AppLocalizations.of(context)!.dlEnqueued(
                                snapshot.data?[DownloadItemState.enqueued] ??
                                    -1),
                            style: const TextStyle(color: Colors.grey),
                          ),
                          Text(
                            AppLocalizations.of(context)!.dlRunning(
                                snapshot.data?[DownloadItemState.downloading] ??
                                    -1),
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
