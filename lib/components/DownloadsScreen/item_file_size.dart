import 'package:file_sizes/file_sizes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';

import '../../models/finamp_models.dart';
import '../../services/downloads_service.dart';

class ItemFileSize extends ConsumerWidget {
  const ItemFileSize({super.key, required this.stub});

  final DownloadStub stub;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isarDownloader = GetIt.instance<DownloadsService>();
    var downloadingText = AppLocalizations.of(context)!.activeDownloadSize;
    var deletingText = AppLocalizations.of(context)!.missingDownloadSize;
    var syncingText = AppLocalizations.of(context)!.syncingDownloadSize;
    Future<String> sizeText =
        ref.watch(isarDownloader.itemProvider(stub).future).then((item) {
      switch (item?.state) {
        case DownloadItemState.notDownloaded:
          if (isarDownloader.getStatus(item!, null) ==
              DownloadItemStatus.notNeeded) {
            return Future.value(deletingText);
          } else {
            return Future.value(syncingText);
          }
        case DownloadItemState.syncFailed:
          return Future.value(syncingText);
        case DownloadItemState.failed:
        case DownloadItemState.complete:
        case DownloadItemState.needsRedownloadComplete:
          if (item!.type == DownloadItemType.song) {
            String codec = "";
            String bitrate = "null";
            if (item.fileTranscodingProfile == null ||
                item.fileTranscodingProfile?.codec ==
                    FinampTranscodingCodec.original) {
              codec = item.baseItem?.mediaSources?[0].container ?? "";
            } else {
              codec = item.fileTranscodingProfile?.codec.name ?? "";
              bitrate = item.fileTranscodingProfile?.bitrateKbps ?? "null";
            }
            return isarDownloader.getFileSize(item).then((value) =>
                AppLocalizations.of(context)!.downloadInfo(
                    bitrate, codec.toUpperCase(), FileSize.getSize(value)));
          } else {
            var profile =
                item.userTranscodingProfile ?? item.syncTranscodingProfile;
            var codec =
                profile?.codec.name ?? FinampTranscodingCodec.original.name;
            return isarDownloader.getFileSize(item).then((value) =>
                AppLocalizations.of(context)!.collectionDownloadInfo(
                    profile?.bitrateKbps ?? "null",
                    codec.toUpperCase(),
                    FileSize.getSize(value)));
          }
        case DownloadItemState.downloading:
        case DownloadItemState.enqueued:
        case DownloadItemState.needsRedownload:
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
