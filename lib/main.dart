import 'dart:async';

import 'package:audio_service/audio_service.dart';
import 'package:audio_session/audio_session.dart';
import 'package:background_downloader/background_downloader.dart';
import 'package:finamp/color_schemes.g.dart';
import 'package:finamp/screens/downloads_settings_screen.dart';
import 'package:finamp/screens/interaction_settings_screen.dart';
import 'package:finamp/screens/login_screen.dart';
import 'package:finamp/screens/playback_history_screen.dart';
import 'package:finamp/screens/player_settings_screen.dart';
import 'package:finamp/screens/queue_restore_screen.dart';
import 'package:finamp/services/downloads_service.dart';
import 'package:finamp/services/downloads_service_backend.dart';
import 'package:finamp/services/finamp_settings_helper.dart';
import 'package:finamp/services/finamp_user_helper.dart';
import 'package:finamp/services/offline_listen_helper.dart';
import 'package:finamp/services/playback_history_service.dart';
import 'package:finamp/services/queue_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:isar/isar.dart';
import 'package:logging/logging.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';

import 'components/LogsScreen/copy_logs_button.dart';
import 'components/LogsScreen/share_logs_button.dart';
import 'components/global_snackbar.dart';
import 'models/finamp_models.dart';
import 'models/jellyfin_models.dart';
import 'models/locale_adapter.dart';
import 'models/theme_mode_adapter.dart';
import 'screens/active_downloads_screen.dart';
import 'screens/add_download_location_screen.dart';
import 'screens/add_to_playlist_screen.dart';
import 'screens/album_screen.dart';
import 'screens/artist_screen.dart';
import 'screens/audio_service_settings_screen.dart';
import 'screens/downloads_location_screen.dart';
import 'screens/downloads_screen.dart';
import 'screens/language_selection_screen.dart';
import 'screens/layout_settings_screen.dart';
import 'screens/logs_screen.dart';
import 'screens/music_screen.dart';
import 'screens/player_screen.dart';
import 'screens/replay_gain_settings_screen.dart';
import 'screens/settings_screen.dart';
import 'screens/splash_screen.dart';
import 'screens/tabs_settings_screen.dart';
import 'screens/transcoding_settings_screen.dart';
import 'screens/view_selector.dart';
import 'services/audio_service_helper.dart';
import 'services/jellyfin_api_helper.dart';
import 'services/locale_helper.dart';
import 'services/music_player_background_task.dart';
import 'services/theme_mode_helper.dart';
import 'setup_logging.dart';

void main() async {
  // If the app has failed, this is set to true. If true, we don't attempt to run the main app since the error app has started.
  bool hasFailed = false;
  try {
    await setupLogging();
    await setupHive();
    _migrateDownloadLocations();
    _migrateSortOptions();
    await _setupFinampUserHelper();
    await _setupJellyfinApiData();
    _setupOfflineListenLogHelper();
    await _setupDownloadsHelper();
    await _setupPlaybackServices();
  } catch (error, trace) {
    hasFailed = true;
    Logger("ErrorApp").severe(error, null, trace);
    runApp(FinampErrorApp(error: error));
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
    await initializeDateFormatting(localeString, null);

    runApp(const Finamp());
  }
}

Future<void> _setupJellyfinApiData() async {
  GetIt.instance.registerSingleton(JellyfinApiHelper());
}

void _setupOfflineListenLogHelper() {
  GetIt.instance.registerSingleton(OfflineListenLogHelper());
}

Future<void> _setupDownloadsHelper() async {
  await Future.wait(FinampSettingsHelper
      .finampSettings.downloadLocationsMap.values
      .map((element) => element.updateCurrentPath()));
  FileDownloader(persistentStorage: IsarPersistentStorage());
  await FileDownloader().ready;
  WidgetsFlutterBinding.ensureInitialized();
  // There is additional FileDownloader setup inside downloadsService constructor
  GetIt.instance.registerSingleton(DownloadsService());
  final downloadsService = GetIt.instance<DownloadsService>();

  if (!FinampSettingsHelper
      .finampSettings.hasCompleteddownloadsServiceMigration) {
    await downloadsService.migrateFromHive();
    FinampSettingsHelper.setHasCompleteddownloadsServiceMigration(true);
  }

  await FileDownloader()
      .configure(globalConfig: (Config.checkAvailableSpace, 1024));
  await FileDownloader().resumeFromBackground();
  await downloadsService.startQueues();
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
  Hive.registerAdapter(MediaUrlAdapter());
  Hive.registerAdapter(BaseItemPersonAdapter());
  Hive.registerAdapter(NameLongIdPairAdapter());
  Hive.registerAdapter(TabContentTypeAdapter());
  Hive.registerAdapter(SortByAdapter());
  Hive.registerAdapter(SortOrderAdapter());
  Hive.registerAdapter(ContentViewTypeAdapter());
  Hive.registerAdapter(DownloadedImageAdapter());
  Hive.registerAdapter(ThemeModeAdapter());
  Hive.registerAdapter(LocaleAdapter());
  Hive.registerAdapter(FinampLoopModeAdapter());
  Hive.registerAdapter(ReplayGainModeAdapter());
  Hive.registerAdapter(FinampStorableQueueInfoAdapter());
  Hive.registerAdapter(QueueItemSourceAdapter());
  Hive.registerAdapter(QueueItemSourceTypeAdapter());
  Hive.registerAdapter(QueueItemSourceNameAdapter());
  Hive.registerAdapter(QueueItemSourceNameTypeAdapter());
  Hive.registerAdapter(OfflineListenAdapter());
  Hive.registerAdapter(DownloadLocationTypeAdapter());
  Hive.registerAdapter(FinampTranscodingCodecAdapter());
  Hive.registerAdapter(TranscodeDownloadsSettingAdapter());
  Hive.registerAdapter(LyricMetadataAdapter());
  Hive.registerAdapter(LyricLineAdapter());
  Hive.registerAdapter(LyricDtoAdapter());

  await Future.wait([
    Hive.openBox<FinampSettings>("FinampSettings"),
    Hive.openBox<ThemeMode>("ThemeMode"),
    Hive.openBox<FinampStorableQueueInfo>("Queues"),
    Hive.openBox<Locale?>(LocaleHelper.boxName),
    Hive.openBox<OfflineListen>("OfflineListens")
  ]);

  // If the settings box is empty, we add an initial settings value here.
  Box<FinampSettings> finampSettingsBox = Hive.box("FinampSettings");
  if (finampSettingsBox.isEmpty) {
    await finampSettingsBox.put(
        "FinampSettings", await FinampSettings.create());
  }

  // If no ThemeMode is set, we set it to the default (system)
  Box<ThemeMode> themeModeBox = Hive.box("ThemeMode");
  if (themeModeBox.isEmpty) ThemeModeHelper.setThemeMode(ThemeMode.system);

  final dir = await getApplicationDocumentsDirectory();
  final isar = await Isar.open(
    [DownloadItemSchema, IsarTaskDataSchema, FinampUserSchema, DownloadedLyricsSchema],
    directory: dir.path,
    name: isarDatabaseName,
  );
  GetIt.instance.registerSingleton(isar);
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

Future<void> _setupFinampUserHelper() async {
  GetIt.instance.registerSingleton(FinampUserHelper());
  if (!FinampSettingsHelper.finampSettings.hasCompletedIsarUserMigration) {
    await GetIt.instance<FinampUserHelper>().migrateFromHive();
    FinampSettingsHelper.setHasCompletedIsarUserMigration(true);
  }
  await GetIt.instance<FinampUserHelper>().setAuthHeader();
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
                    LoginScreen.routeName: (context) => const LoginScreen(),
                    ViewSelector.routeName: (context) => const ViewSelector(),
                    MusicScreen.routeName: (context) => const MusicScreen(),
                    AlbumScreen.routeName: (context) => const AlbumScreen(),
                    ArtistScreen.routeName: (context) => const ArtistScreen(),
                    AddToPlaylistScreen.routeName: (context) =>
                        const AddToPlaylistScreen(),
                    PlayerScreen.routeName: (context) => const PlayerScreen(),
                    DownloadsScreen.routeName: (context) =>
                        const DownloadsScreen(),
                    ActiveDownloadsScreen.routeName: (context) =>
                        const ActiveDownloadsScreen(),
                    PlaybackHistoryScreen.routeName: (context) =>
                        const PlaybackHistoryScreen(),
                    LogsScreen.routeName: (context) => const LogsScreen(),
                    QueueRestoreScreen.routeName: (context) =>
                        const QueueRestoreScreen(),
                    SettingsScreen.routeName: (context) =>
                        const SettingsScreen(),
                    TranscodingSettingsScreen.routeName: (context) =>
                        const TranscodingSettingsScreen(),
                    DownloadsLocationScreen.routeName: (context) =>
                        const DownloadsLocationScreen(),
                    DownloadsSettingsScreen.routeName: (context) =>
                        const DownloadsSettingsScreen(),
                    AddDownloadLocationScreen.routeName: (context) =>
                        const AddDownloadLocationScreen(),
                    AudioServiceSettingsScreen.routeName: (context) =>
                        const AudioServiceSettingsScreen(),
                    ReplayGainSettingsScreen.routeName: (context) =>
                        const ReplayGainSettingsScreen(),
                    InteractionSettingsScreen.routeName: (context) =>
                        const InteractionSettingsScreen(),
                    TabsSettingsScreen.routeName: (context) =>
                        const TabsSettingsScreen(),
                    LayoutSettingsScreen.routeName: (context) =>
                        const LayoutSettingsScreen(),
                    PlayerSettingsScreen.routeName: (context) =>
                        const PlayerSettingsScreen(),
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
                    snackBarTheme: const SnackBarThemeData(
                      //TODO get rid of floating action buttons and re-enable the floating behavior and insetPadding
                      // behavior: SnackBarBehavior.floating,
                      elevation: 10.0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(12.0)),
                      ),
                      // insetPadding: EdgeInsets.symmetric(
                      //   horizontal: 12.0,
                      //   vertical: 0.0,
                      // ),
                      dismissDirection: DismissDirection.horizontal,
                    ),
                  ),
                  darkTheme: ThemeData(
                    brightness: Brightness.dark,
                    colorScheme: darkColorScheme,
                    snackBarTheme: const SnackBarThemeData(
                      //TODO get rid of floating action buttons and re-enable the floating behavior and insetPadding
                      // behavior: SnackBarBehavior.floating,
                      elevation: 10.0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(12.0)),
                      ),
                      // insetPadding: EdgeInsets.symmetric(
                      //   horizontal: 12.0,
                      //   vertical: 0.0,
                      // ),
                      dismissDirection: DismissDirection.horizontal,
                    ),
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
                  scaffoldMessengerKey: GlobalSnackbar.materialAppScaffoldKey,
                  navigatorKey: GlobalSnackbar.materialAppNavigatorKey,
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
  const FinampErrorApp({super.key, required this.error});

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
      scaffoldMessengerKey: GlobalSnackbar.materialAppScaffoldKey,
      navigatorKey: GlobalSnackbar.materialAppNavigatorKey,
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
      bottomNavigationBar: const Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [ShareLogsButton(), CopyLogsButton()],
      ),
    );
  }
}
