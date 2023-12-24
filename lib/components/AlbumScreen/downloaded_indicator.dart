import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
import 'package:hive/hive.dart';

import '../../models/finamp_models.dart';
import '../../models/jellyfin_models.dart';
import '../../services/isar_downloads.dart';
import '../global_snackbar.dart';

class DownloadedIndicator extends ConsumerWidget {
  const DownloadedIndicator({
    Key? key,
    required this.item,
    this.size,
  }) : super(key: key);

  final DownloadStub item;
  final double? size;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isarDownloads = GetIt.instance<IsarDownloads>();
    AsyncValue<DownloadItemState> status =
        ref.watch(isarDownloads.stateProvider(item));
    if (status.hasValue) {
      switch (status.valueOrNull) {
        case null:
        case DownloadItemState.notDownloaded:
          return const SizedBox.shrink();
        case DownloadItemState.enqueued:
        case DownloadItemState.downloading:
          return Icon( //TODO invisible in light mode
            Icons.download_outlined,
            color: Colors.white.withOpacity(0.5),
            size: size,
          );
        case DownloadItemState.failed:
          return Icon(
            Icons.error,
            color: Colors.red,
            size: size,
          );
        case DownloadItemState.complete:
          return Icon(
            Icons.download,
            color: Theme.of(context).colorScheme.secondary,
            size: size,
          );
        /*case DownloadItemState.deleting:
          return Icon(
            Icons.pause,
            color: Colors.yellow,
            size: size,
          );
        case DownloadItemState.paused:
          return Icon(
            Icons.pause,
            color: Colors.yellow,
            size: size,
          );*/
      }
    } else if (status.hasError) {
      GlobalSnackbar.error(status.error);
      return const SizedBox.shrink();
    } else {
      return const SizedBox.shrink();
    }
  }
}
