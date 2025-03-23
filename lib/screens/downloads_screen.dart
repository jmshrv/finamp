import 'package:finamp/models/finamp_models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../components/DownloadsScreen/download_error_screen_button.dart';
import '../components/DownloadsScreen/downloaded_items_list.dart';
import '../components/DownloadsScreen/downloads_overview.dart';
import '../components/DownloadsScreen/repair_downloads_button.dart';
import '../components/DownloadsScreen/sync_downloads_button.dart';
import '../components/padded_custom_scrollview.dart';

class DownloadsScreen extends StatelessWidget {
  const DownloadsScreen({super.key});

  static const routeName = "/downloads";

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Text(localizations.downloads),
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
          DownloadedItemsTitle(title: localizations.specialDownloads),
          const DownloadedItemsList(type: DownloadsScreenCategory.special),
          DownloadedItemsTitle(title: localizations.playlists),
          const DownloadedItemsList(type: DownloadsScreenCategory.playlists),
          DownloadedItemsTitle(title: localizations.artists),
          const DownloadedItemsList(type: DownloadsScreenCategory.artists),
          DownloadedItemsTitle(title: localizations.albums),
          const DownloadedItemsList(type: DownloadsScreenCategory.albums),
          DownloadedItemsTitle(title: localizations.genres),
          const DownloadedItemsList(type: DownloadsScreenCategory.genres),
          DownloadedItemsTitle(title: localizations.tracks),
          const DownloadedItemsList(type: DownloadsScreenCategory.tracks),
        ],
      ),
    );
  }
}
