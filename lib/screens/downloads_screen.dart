import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../components/DownloadsScreen/download_error_screen_button.dart';
import '../components/DownloadsScreen/downloaded_items_list.dart';
import '../components/DownloadsScreen/downloads_overview.dart';
import '../components/DownloadsScreen/repair_downloads_button.dart';
import '../components/DownloadsScreen/sync_downloads_button.dart';
import '../components/padded_custom_scrollview.dart';

class DownloadsScreen extends StatelessWidget {
  const DownloadsScreen({Key? key}) : super(key: key);

  static const routeName = "/downloads";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.downloads),
        actions: const [
          SyncDownloadsButton(),
          RepairDownloadsButton(),
          DownloadErrorScreenButton()
        ],
      ),
      body: PaddedCustomScrollview(
        slivers: [
          SliverList(
            delegate: SliverChildListDelegate([
              const Padding(
                // We don't have bottom padding here since the divider already provides bottom padding
                padding: EdgeInsets.fromLTRB(8, 8, 8, 0),
                child: DownloadsOverview(),
              ),
              const Divider(),
            ]),
          ),
          const DownloadedItemsList(),
          // CurrentDownloadsList(),
        ],
      ),
    );
  }
}
