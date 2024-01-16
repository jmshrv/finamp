import 'package:file_sizes/file_sizes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';

import '../../models/finamp_models.dart';
import '../../services/isar_downloads.dart';

class ItemFileSize extends ConsumerWidget {
  const ItemFileSize({super.key, required this.item});

  final DownloadStub item;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isarDownloader = GetIt.instance<IsarDownloads>();
    var downloadingText = AppLocalizations.of(context)!.activeDownloadSize;
    var deletingText = AppLocalizations.of(context)!.missingDownloadSize;
    var syncingText = AppLocalizations.of(context)!.syncingDownloadSize;
    Future<String> sizeText =
        ref.watch(isarDownloader.stateProvider(item).future).then((value1) {
      switch (value1) {
        case DownloadItemState.notDownloaded:
          if (isarDownloader.getStatus(item, null).isRequired) {
            return Future.value(syncingText);
          } else {
            return Future.value(deletingText);
          }
        case DownloadItemState.syncFailed:
          return Future.value(syncingText);
        case DownloadItemState.failed:
        case DownloadItemState.complete:
          if (item.type == DownloadItemType.song) {
            var mediaSourceInfo = item.baseItem?.mediaSources?[0];
            if (mediaSourceInfo == null) {
              return "??? MB Unknown";
            } else {
              return "${FileSize.getSize(mediaSourceInfo.size)} ${mediaSourceInfo.container?.toUpperCase()}";
            }
          } else {
            return isarDownloader
                .getFileSize(item)
                .then((value) => FileSize.getSize(value));
          }
        case DownloadItemState.downloading:
        case DownloadItemState.enqueued:
          return Future.value(downloadingText);
        case null:
          return Future.value(deletingText);
      }
    });
    return FutureBuilder(
        future: sizeText,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Text(snapshot.data!);
          }
          return const Text("");
        });
  }
}
