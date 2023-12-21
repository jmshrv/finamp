import 'dart:async';
import 'dart:isolate';
import 'dart:ui';

import 'package:audio_service/audio_service.dart';
import 'package:audio_session/audio_session.dart';
import 'package:finamp/screens/playback_history_screen.dart';
import 'package:finamp/screens/queue_restore_screen.dart';
import 'package:finamp/services/finamp_settings_helper.dart';
import 'package:finamp/services/finamp_user_helper.dart';
import 'package:finamp/services/playback_history_service.dart';
import 'package:finamp/services/queue_service.dart';
import 'package:finamp/color_schemes.g.dart';
import 'package:finamp/services/offline_listen_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:logging/logging.dart';
import 'package:uuid/uuid.dart';

import 'models/finamp_models.dart';
import 'models/jellyfin_models.dart';
import 'models/locale_adapter.dart';
import 'models/theme_mode_adapter.dart';
import 'screens/add_download_location_screen.dart';
import 'screens/add_to_playlist_screen.dart';
import 'screens/album_screen.dart';
import 'screens/artist_screen.dart';
import 'screens/audio_service_settings_screen.dart';
import 'screens/downloads_error_screen.dart';
import 'screens/downloads_screen.dart';
import 'screens/downloads_settings_screen.dart';
import 'screens/language_selection_screen.dart';
import 'screens/layout_settings_screen.dart';
import 'screens/logs_screen.dart';
import 'screens/music_screen.dart';
import 'screens/player_screen.dart';
import 'screens/settings_screen.dart';
import 'screens/splash_screen.dart';
import 'screens/tabs_settings_screen.dart';
import 'screens/transcoding_settings_screen.dart';
import 'screens/user_selector.dart';
import 'screens/view_selector.dart';
import 'services/audio_service_helper.dart';
import 'services/download_update_stream.dart';
import 'services/downloads_helper.dart';
import 'services/jellyfin_api_helper.dart';
import 'services/locale_helper.dart';
import 'services/music_player_background_task.dart';
import 'services/theme_mode_helper.dart';
import 'setup_logging.dart';

void main() async {
  // If the app has failed, this is set to true. If true, we don't attempt to run the main app since the error app has started.
  bool hasFailed = false;
  try {
    setupLogging();
    await setupHive();
    _migrateDownloadLocations();
    _migrateSortOptions();
    _setupFinampUserHelper();
    _setupJellyfinApiData();
    _setupOfflineListenLogHelper();
    await _setupDownloader();
    await _setupDownloadsHelper();
    await _setupPlaybackServices();
  } catch (e) {
    hasFailed = true;
    runApp(FinampErrorApp(
      error: e,
    ));
  }

  if (!hasFailed) {
    final flutterLogger = Logger("Flutter");

    FlutterError.onError = (FlutterErrorDetails details) {
      FlutterError.presentError(details);
      flutterLogger.severe(details.exception, details.exception, details.stack);
    };
    // On iOS, the status bar will have black icons by default on the login
    // screen as it does not have an AppBar. To fix this, we set the
    // brightness to dark manually on startup.
    SystemChrome.setSystemUIOverlayStyle(
        const SystemUiOverlayStyle(statusBarBrightness: Brightness.dark));

    final String localeString = (LocaleHelper.locale != null)
        ? ((LocaleHelper.locale?.countryCode != null)
            ? "${LocaleHelper.locale?.languageCode.toLowerCase()}_${LocaleHelper.locale?.countryCode?.toUpperCase()}"
            : LocaleHelper.locale.toString())
        : "en_US";
    initializeDateFormatting(localeString, null);

    runApp(const Finamp());
  }
}

void _setupJellyfinApiData() {
  GetIt.instance.registerSingleton(JellyfinApiHelper());
}

void _setupOfflineListenLogHelper() {
  GetIt.instance.registerSingleton(OfflineListenLogHelper());
}

Future<void> _setupDownloadsHelper() async {
  GetIt.instance.registerSingleton(DownloadsHelper());
  final downloadsHelper = GetIt.instance<DownloadsHelper>();

  // We awkwardly cache this value since going from 0.6.14 -> 0.6.16 will switch
  // hasCompletedBlurhashImageMigration despite doing a fixed migration
  final shouldRunBlurhashImageMigrationIdFix =
      FinampSettingsHelper.finampSettings.shouldRunBlurhashImageMigrationIdFix;

  if (!FinampSettingsHelper.finampSettings.hasCompletedBlurhashImageMigration) {
    await downloadsHelper.migrateBlurhashImages();
    FinampSettingsHelper.setHasCompletedBlurhashImageMigration(true);
  }

  if (shouldRunBlurhashImageMigrationIdFix) {
    await downloadsHelper.fixBlurhashMigrationIds();
    FinampSettingsHelper.setHasCompletedBlurhashImageMigrationIdFix(true);
  }
}

Future<void> _setupDownloader() async {
  GetIt.instance.registerSingleton(DownloadUpdateStream());
  GetIt.instance<DownloadUpdateStream>().setupSendPort();

  WidgetsFlutterBinding.ensureInitialized();
  await FlutterDownloader.initialize(debug: true);

  // flutter_downloader sometimes crashes when adding downloads. For some
  // reason, adding this callback fixes it.
  // https://github.com/fluttercommunity/flutter_downloader/issues/445

  FlutterDownloader.registerCallback(_DummyCallback.callback);
}

Future<void> setupHive() async {
  await Hive.initFlutter();
  Hive.registerAdapter(BaseItemDtoAdapter());
  Hive.registerAdapter(UserItemDataDtoAdapter());
  Hive.registerAdapter(NameIdPairAdapter());
  Hive.registerAdapter(DownloadedSongAdapter());
  Hive.registerAdapter(DownloadedParentAdapter());
  Hive.registerAdapter(MediaSourceInfoAdapter());
  Hive.registerAdapter(MediaStreamAdapter());
  Hive.registerAdapter(AuthenticationResultAdapter());
  Hive.registerAdapter(FinampUserAdapter());
  Hive.registerAdapter(UserDtoAdapter());
  Hive.registerAdapter(SessionInfoAdapter());
  Hive.registerAdapter(UserConfigurationAdapter());
  Hive.registerAdapter(UserPolicyAdapter());
  Hive.registerAdapter(AccessScheduleAdapter());
  Hive.registerAdapter(PlayerStateInfoAdapter());
  Hive.registerAdapter(SessionUserInfoAdapter());
  Hive.registerAdapter(ClientCapabilitiesAdapter());
  Hive.registerAdapter(DeviceProfileAdapter());
  Hive.registerAdapter(DeviceIdentificationAdapter());
  Hive.registerAdapter(HttpHeaderInfoAdapter());
  Hive.registerAdapter(XmlAttributeAdapter());
  Hive.registerAdapter(DirectPlayProfileAdapter());
  Hive.registerAdapter(TranscodingProfileAdapter());
  Hive.registerAdapter(ContainerProfileAdapter());
  Hive.registerAdapter(ProfileConditionAdapter());
  Hive.registerAdapter(CodecProfileAdapter());
  Hive.registerAdapter(ResponseProfileAdapter());
  Hive.registerAdapter(SubtitleProfileAdapter());
  Hive.registerAdapter(FinampSettingsAdapter());
  Hive.registerAdapter(DownloadLocationAdapter());
  Hive.registerAdapter(ImageBlurHashesAdapter());
  Hive.registerAdapter(BaseItemAdapter());
  Hive.registerAdapter(QueueItemAdapter());
  Hive.registerAdapter(ExternalUrlAdapter());
  Hive.registerAdapter(NameLongIdPairAdapter());
  Hive.registerAdapter(TabContentTypeAdapter());
  Hive.registerAdapter(SortByAdapter());
  Hive.registerAdapter(SortOrderAdapter());
  Hive.registerAdapter(ContentViewTypeAdapter());
  Hive.registerAdapter(DownloadedImageAdapter());
  Hive.registerAdapter(ThemeModeAdapter());
  Hive.registerAdapter(LocaleAdapter());
  Hive.registerAdapter(FinampLoopModeAdapter());
  Hive.registerAdapter(FinampStorableQueueInfoAdapter());
  Hive.registerAdapter(QueueItemSourceAdapter());
  Hive.registerAdapter(QueueItemSourceTypeAdapter());
  Hive.registerAdapter(QueueItemSourceNameAdapter());
  Hive.registerAdapter(QueueItemSourceNameTypeAdapter());
  Hive.registerAdapter(OfflineListenAdapter());
  await Future.wait([
    Hive.openBox<DownloadedParent>("DownloadedParents"),
    Hive.openBox<DownloadedSong>("DownloadedItems"),
    Hive.openBox<DownloadedSong>("DownloadIds"),
    Hive.openBox<FinampUser>("FinampUsers"),
    Hive.openBox<String>("CurrentUserId"),
    Hive.openBox<FinampSettings>("FinampSettings"),
    Hive.openBox<DownloadedImage>("DownloadedImages"),
    Hive.openBox<String>("DownloadedImageIds"),
    Hive.openBox<ThemeMode>("ThemeMode"),
    Hive.openBox<FinampStorableQueueInfo>("Queues"),
    Hive.openBox<Locale?>(LocaleHelper.boxName),
    Hive.openBox<OfflineListen>("OfflineListens")
  ]);

  // If the settings box is empty, we add an initial settings value here.
  Box<FinampSettings> finampSettingsBox = Hive.box("FinampSettings");
  if (finampSettingsBox.isEmpty) {
    finampSettingsBox.put("FinampSettings", await FinampSettings.create());
  }

  // If no ThemeMode is set, we set it to the default (system)
  Box<ThemeMode> themeModeBox = Hive.box("ThemeMode");
  if (themeModeBox.isEmpty) ThemeModeHelper.setThemeMode(ThemeMode.system);
}

Future<void> _setupPlaybackServices() async {
  final session = await AudioSession.instance;
  session.configure(const AudioSessionConfiguration.music());

  final audioHandler = await AudioService.init(
    builder: () => MusicPlayerBackgroundTask(),
    config: AudioServiceConfig(
      androidStopForegroundOnPause:
          FinampSettingsHelper.finampSettings.androidStopForegroundOnPause,
      androidNotificationChannelName: "Playback",
      androidNotificationIcon: "mipmap/white",
      androidNotificationChannelId: "com.unicornsonlsd.finamp.audio",
    ),
  );
  // GetIt.instance.registerSingletonAsync<AudioHandler>(
  //     () async => );

  GetIt.instance.registerSingleton<MusicPlayerBackgroundTask>(audioHandler);
  GetIt.instance.registerSingleton(QueueService());
  GetIt.instance.registerSingleton(PlaybackHistoryService());
  GetIt.instance.registerSingleton(AudioServiceHelper());
}

/// Migrates the old DownloadLocations list to a map
void _migrateDownloadLocations() {
  final finampSettings = FinampSettingsHelper.finampSettings;

  // ignore: deprecated_member_use_from_same_package
  if (finampSettings.downloadLocations.isNotEmpty) {
    final Map<String, DownloadLocation> newMap = {};

    // ignore: deprecated_member_use_from_same_package
    for (var element in finampSettings.downloadLocations) {
      // Generate a UUID and set the ID field for the DownloadsLocation
      final id = const Uuid().v4();
      element.id = id;
      newMap[id] = element;
    }

    finampSettings.downloadLocationsMap = newMap;

    // ignore: deprecated_member_use_from_same_package
    finampSettings.downloadLocations = List.empty();

    FinampSettingsHelper.overwriteFinampSettings(finampSettings);
  }
}

/// Migrates the old SortBy/SortOrder to a map indexed by tab content type
void _migrateSortOptions() {
  final finampSettings = FinampSettingsHelper.finampSettings;

  var changed = false;

  if (finampSettings.tabSortBy.isEmpty) {
    for (var type in TabContentType.values) {
      // ignore: deprecated_member_use_from_same_package
      finampSettings.tabSortBy[type] = finampSettings.sortBy;
    }
    changed = true;
  }

  if (finampSettings.tabSortOrder.isEmpty) {
    for (var type in TabContentType.values) {
      // ignore: deprecated_member_use_from_same_package
      finampSettings.tabSortOrder[type] = finampSettings.sortOrder;
    }
    changed = true;
  }

  if (changed) {
    FinampSettingsHelper.overwriteFinampSettings(finampSettings);
  }
}

void _setupFinampUserHelper() {
  GetIt.instance.registerSingleton(FinampUserHelper());
}

class Finamp extends StatelessWidget {
  const Finamp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ProviderScope(
      child: GestureDetector(
        onTap: () {
          FocusScopeNode currentFocus = FocusScope.of(context);

          if (!currentFocus.hasPrimaryFocus &&
              currentFocus.focusedChild != null) {
            FocusManager.instance.primaryFocus?.unfocus();
          }
        },
        // We awkwardly have two ValueListenableBuilders for the locale and
        // theme because I didn't want every FinampSettings change to rebuild
        // the whole app
        child: ValueListenableBuilder(
          valueListenable: LocaleHelper.localeListener,
          builder: (_, __, ___) {
            return ValueListenableBuilder<Box<ThemeMode>>(
                valueListenable: ThemeModeHelper.themeModeListener,
                builder: (_, box, __) {
                  return MaterialApp(
                    title: "Finamp",
                    routes: {
                      SplashScreen.routeName: (context) => const SplashScreen(),
                      UserSelector.routeName: (context) => const UserSelector(),
                      ViewSelector.routeName: (context) => const ViewSelector(),
                      MusicScreen.routeName: (context) => const MusicScreen(),
                      AlbumScreen.routeName: (context) => const AlbumScreen(),
                      ArtistScreen.routeName: (context) => const ArtistScreen(),
                      AddToPlaylistScreen.routeName: (context) =>
                          const AddToPlaylistScreen(),
                      PlayerScreen.routeName: (context) => const PlayerScreen(),
                      DownloadsScreen.routeName: (context) =>
                          const DownloadsScreen(),
                      DownloadsErrorScreen.routeName: (context) =>
                          const DownloadsErrorScreen(),
                      PlaybackHistoryScreen.routeName: (context) =>
                          const PlaybackHistoryScreen(),
                      LogsScreen.routeName: (context) => const LogsScreen(),
                      QueueRestoreScreen.routeName: (context) =>
                          const QueueRestoreScreen(),
                      SettingsScreen.routeName: (context) =>
                          const SettingsScreen(),
                      TranscodingSettingsScreen.routeName: (context) =>
                          const TranscodingSettingsScreen(),
                      DownloadsSettingsScreen.routeName: (context) =>
                          const DownloadsSettingsScreen(),
                      AddDownloadLocationScreen.routeName: (context) =>
                          const AddDownloadLocationScreen(),
                      AudioServiceSettingsScreen.routeName: (context) =>
                          const AudioServiceSettingsScreen(),
                      TabsSettingsScreen.routeName: (context) =>
                          const TabsSettingsScreen(),
                      LayoutSettingsScreen.routeName: (context) =>
                          const LayoutSettingsScreen(),
                      LanguageSelectionScreen.routeName: (context) =>
                          const LanguageSelectionScreen(),
                    },
                    initialRoute: SplashScreen.routeName,
                    theme: ThemeData(
                      brightness: Brightness.light,
                      colorScheme: lightColorScheme,
                      appBarTheme: const AppBarTheme(
                        systemOverlayStyle: SystemUiOverlayStyle(
                          statusBarBrightness: Brightness.light,
                          statusBarIconBrightness: Brightness.dark,
                        ),
                      ),
                    ),
                    darkTheme: ThemeData(
                      brightness: Brightness.dark,
                      colorScheme: darkColorScheme,
                    ),
                    themeMode: box.get("ThemeMode"),
                    localizationsDelegates: const [
                      AppLocalizations.delegate,
                      GlobalMaterialLocalizations.delegate,
                      GlobalWidgetsLocalizations.delegate,
                      GlobalCupertinoLocalizations.delegate,
                    ],
                    supportedLocales: AppLocalizations.supportedLocales,
                    // We awkwardly put English as the first supported locale so
                    // that basicLocaleListResolution falls back to it instead of
                    // the first language in supportedLocales (Arabic as of writing)
                    localeListResolutionCallback: (locales, supportedLocales) =>
                        basicLocaleListResolution(locales,
                            [const Locale("en")].followedBy(supportedLocales)),
                    locale: LocaleHelper.locale,
                  );
                },
            );
          },
        ),
      ),
    );
  }
}

class FinampErrorApp extends StatelessWidget {
  const FinampErrorApp({Key? key, required this.error}) : super(key: key);

  final dynamic error;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Finamp",
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      home: ErrorScreen(error: error),
    );
  }
}

class ErrorScreen extends StatelessWidget {
  const ErrorScreen({super.key, this.error});

  final dynamic error;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          AppLocalizations.of(context)!.startupError(error.toString()),
        ),
      ),
    );
  }
}

class _DummyCallback {
  // https://github.com/fluttercommunity/flutter_downloader/issues/629
  @pragma('vm:entry-point')
  static void callback(String id, int status, int progress) {
    // Add the event to the DownloadUpdateStream instance.
    final SendPort? send =
        IsolateNameServer.lookupPortByName('downloader_send_port');
    send!.send([id, status, progress]);
  }
}
