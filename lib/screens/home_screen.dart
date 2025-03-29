import 'dart:async';
import 'dart:io';

import 'package:finamp/components/HomeScreen/finamp_home_screen_header.dart';
import 'package:finamp/components/HomeScreen/finamp_navigation_bar.dart';
import 'package:finamp/components/HomeScreen/home_screen_content.dart';
import 'package:finamp/services/downloads_service.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:finamp/l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
import 'package:hive_ce/hive.dart';
import 'package:logging/logging.dart';

import '../components/MusicScreen/music_screen_drawer.dart';
import '../components/MusicScreen/music_screen_tab_view.dart';
import '../components/MusicScreen/sort_by_menu_button.dart';
import '../components/MusicScreen/sort_order_button.dart';
import '../components/global_snackbar.dart';
import '../components/now_playing_bar.dart';
import '../models/finamp_models.dart';
import '../services/audio_service_helper.dart';
import '../services/finamp_settings_helper.dart';
import '../services/finamp_user_helper.dart';
import '../services/jellyfin_api_helper.dart';

final _homeScreenLogger = Logger("HomeScreen");

void postLaunchHook(WidgetRef ref) async {
  final downloadsService = GetIt.instance<DownloadsService>();

  // make sure playlist info is downloaded for users upgrading from older versions and new installations AFTER logging in and selecting their libraries/views
  if (!FinampSettingsHelper.finampSettings.hasDownloadedPlaylistInfo) {
    await downloadsService.addDefaultPlaylistInfoDownload().catchError((e) {
      // log error without snackbar, we don't want users to be greeted with errors on first launch
      _homeScreenLogger.severe("Failed to download playlist metadata: $e");
    });
    FinampSetters.setHasDownloadedPlaylistInfo(true);
  }
}

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  static const routeName = "/home";

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen>
    with TickerProviderStateMixin {
  final _audioServiceHelper = GetIt.instance<AudioServiceHelper>();
  final _finampUserHelper = GetIt.instance<FinampUserHelper>();
  final _jellyfinApiHelper = GetIt.instance<JellyfinApiHelper>();

  @override
  void initState() {
    super.initState();
    postLaunchHook(ref);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    FinampUser? currentUser =
        ref.watch(FinampUserHelper.finampCurrentUserProvider).value;
    FinampSettings finampSettings = ref.watch(finampSettingsProvider).value ??
        FinampSettingsHelper.finampSettings;

    return PopScope(
      canPop: true,
      onPopInvokedWithResult: (popped, _) {},
      child: Scaffold(
        extendBody: true,
        appBar: FinampHomeScreenHeader(),
        bottomNavigationBar: const FinampNavigationBar(),
        drawer: const MusicScreenDrawer(),
        body: HomeScreenContent(),
      ),
    );
  }
}
