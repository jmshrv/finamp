import 'package:flutter/material.dart';
import 'package:finamp/l10n/app_localizations.dart';
import 'package:flutter_sticky_header/flutter_sticky_header.dart';

import '../../models/finamp_models.dart';
import 'download_error_list_tile.dart';

class DownloadErrorList extends StatelessWidget {
  const DownloadErrorList({required this.state, required this.children, super.key});

  final DownloadItemState state;
  final List<DownloadStub> children;

  @override
  Widget build(BuildContext context) {
    String title = AppLocalizations.of(context)!.activeDownloadsListHeader(state.name, children.length);

    Color headerColor = switch (state) {
      // TODO this is not very bold in light mode
      DownloadItemState.failed => Theme.of(context).colorScheme.errorContainer,
      DownloadItemState.syncFailed => Theme.of(context).colorScheme.errorContainer,
      _ => Theme.of(context).colorScheme.surfaceContainerHighest,
    };
    return SliverStickyHeader(
        header: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 16.0,
            vertical: 16.0,
          ),
          color: headerColor,
          child: Text(
            title,
            style: const TextStyle(fontSize: 20.0),
          ),
        ),
        sliver: SliverList.builder(
          itemCount: children.length,
          itemBuilder: (context, index) {
            return DownloadErrorListTile(
                downloadTask: children[index], showType: state == DownloadItemState.syncFailed);
          },
        ));
  }
}
