import 'package:flutter/material.dart';

import '../components/DownloadsScreen/DownloadsOverview.dart';
import '../components/DownloadsScreen/DownloadedAlbumsList.dart';
import '../components/DownloadsScreen/DownloadErrorScreenButton.dart';
import '../components/DownloadsScreen/DownloadMissingImagesButton.dart';

class DownloadsScreen extends StatelessWidget {
  const DownloadsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Downloads"),
        actions: const [
          DownloadMissingImagesButton(),
          DownloadErrorScreenButton()
        ],
      ),
      body: Scrollbar(
        child: CustomScrollView(
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
            const DownloadedAlbumsList(),
            // CurrentDownloadsList(),
          ],
        ),
      ),
    );
  }
}
