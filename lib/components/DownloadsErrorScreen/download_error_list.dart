import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_sticky_header/flutter_sticky_header.dart';

import '../../models/finamp_models.dart';
import 'download_error_list_tile.dart';

class DownloadErrorList extends StatelessWidget {
  const DownloadErrorList(
      {required this.state, required this.children, Key? key})
      : super(key: key);

  final DownloadItemState state;
  final List<DownloadStub> children;

  @override
  Widget build(BuildContext context) {
    String title = AppLocalizations.of(context)!
        .activeDownloadsListHeader(state.name, children.length);

    Color headerColor = switch (state) {
      DownloadItemState.failed => Theme.of(context).colorScheme.onError,
      _ => Theme.of(context).colorScheme.surfaceVariant,
    };
    return SliverStickyHeader(
        header: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 16.0,
            vertical: 16.0,
          ),
          color: headerColor, // TODO is still just white on error in light mode
          child: Text(
            title,
            style: const TextStyle(fontSize: 20.0),
          ),
        ),
        sliver: SliverList.builder(
          itemCount: children.length,
          itemBuilder: (context, index) {
            return DownloadErrorListTile(downloadTask: children[index]);
          },
        ));
  }
}
