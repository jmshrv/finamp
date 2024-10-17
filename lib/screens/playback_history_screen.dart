import 'package:finamp/components/PlaybackHistoryScreen/playback_history_list.dart';
import 'package:finamp/components/PlaybackHistoryScreen/share_offline_listens_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../components/now_playing_bar.dart';

class PlaybackHistoryScreen extends StatelessWidget {
  const PlaybackHistoryScreen({Key? key}) : super(key: key);

  static const routeName = "/playbackhistory";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 0.0,
        leadingWidth: 48 + 24,
        toolbarHeight: 75.0,
        backgroundColor: Colors.transparent,
        title: Text(AppLocalizations.of(context)!.playbackHistory),
        actions: const [
          ShareOfflineListensButton(),
        ],
      ),
      body: const Padding(
        padding: EdgeInsets.only(left: 0.0, right: 0.0, top: 16.0, bottom: 0.0),
        child: PlaybackHistoryList(),
      ),
      bottomNavigationBar: const NowPlayingBar(),
    );
  }
}
