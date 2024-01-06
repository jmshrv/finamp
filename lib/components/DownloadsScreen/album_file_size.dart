import 'package:file_sizes/file_sizes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';

import '../../models/finamp_models.dart';
import '../../services/isar_downloads.dart';

class AlbumFileSize extends ConsumerWidget {
  const AlbumFileSize({super.key, required this.downloadedParent});

  final DownloadStub downloadedParent;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isarDownloader = GetIt.instance<IsarDownloads>();
    var downloadingText = AppLocalizations.of(context)!.activeDownloadSize;
    var sizeText = ref
        .watch(isarDownloader.stateProvider(downloadedParent).future)
        .then((value1) {
      switch (value1) {
        case DownloadItemState.notDownloaded:
        case DownloadItemState.failed:
        case DownloadItemState.complete:
          return isarDownloader
              .getFileSize(downloadedParent)
              .then((value2) => FileSize.getSize(value2));
        case DownloadItemState.downloading:
        case DownloadItemState.enqueued:
          return Future.value(downloadingText);
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
