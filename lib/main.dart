import 'dart:async';
import 'dart:isolate';
import 'dart:ui';

import 'package:audio_service/audio_service.dart';
import 'package:audio_session/audio_session.dart';
import 'package:finamp/services/FinampSettingsHelper.dart';
import 'package:finamp/services/FinampUserHelper.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:get_it/get_it.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:logging/logging.dart';
import 'package:uuid/uuid.dart';

import 'generateMaterialColor.dart';
import 'models/ThemeModeAdapter.dart';
import 'services/ThemeModeHelper.dart';
import 'setupLogging.dart';
import 'screens/UserSelector.dart';
import 'screens/MusicScreen.dart';
import 'screens/ViewSelector.dart';
import 'screens/AlbumScreen.dart';
import 'screens/PlayerScreen.dart';
import 'screens/SplashScreen.dart';
import 'screens/DownloadsErrorScreen.dart';
import 'screens/DownloadsScreen.dart';
import 'screens/ArtistScreen.dart';
import 'screens/LogsScreen.dart';
import 'screens/SettingsScreen.dart';
import 'screens/TranscodingSettingsScreen.dart';
import 'screens/DownloadLocationsSettingsScreen.dart';
import 'screens/AddDownloadLocationScreen.dart';
import 'screens/AudioServiceSettingsScreen.dart';
import 'screens/TabsSettingsScreen.dart';
import 'screens/AddToPlaylistScreen.dart';
import 'screens/LayoutSettingsScreen.dart';
import 'services/AudioServiceHelper.dart';
import 'services/JellyfinApiData.dart';
import 'services/DownloadsHelper.dart';
import 'services/DownloadUpdateStream.dart';
import 'services/MusicPlayerBackgroundTask.dart';
import 'models/JellyfinModels.dart';
import 'models/FinampModels.dart';

void main() async {
  // If the app has failed, this is set to true. If true, we don't attempt to run the main app since the error app has started.
  bool hasFailed = false;
  try {
    setupLogging();
    await setupHive();
    _migrateDownloadLocations();
    _setupFinampUserHelper();
    _setupJellyfinApiData();
    await _setupDownloader();
    await _setupDownloadsHelper();
    await _setupAudioServiceHelper();
  } catch (e) {
    hasFailed = true;
    runApp(FinampErrorApp(
      error: e,
    ));
  }

  if (!hasFailed) {
    final flutterLogger = Logger("Flutter");
    runZonedGuarded(() {
      FlutterError.onError = (FlutterErrorDetails details) {
        if (!kReleaseMode) {
          FlutterError.dumpErrorToConsole(details);
        }
        flutterLogger.severe(details.exception, null, details.stack);
      };

      // On iOS, the status bar will have black icons by default on the login
      // screen as it does not have an AppBar. To fix this, we set the
      // brightness to dark manually on startup.
      SystemChrome.setSystemUIOverlayStyle(
          const SystemUiOverlayStyle(statusBarBrightness: Brightness.dark));

      runApp(const Finamp());
    }, (error, stackTrace) {
      flutterLogger.severe(error, null, stackTrace);
    });
  }
}

void _setupJellyfinApiData() {
  GetIt.instance.registerSingleton(JellyfinApiData());
}

Future<void> _setupDownloadsHelper() async {
  GetIt.instance.registerSingleton(DownloadsHelper());
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

// TODO: move this function somewhere else since it's also run in MusicPlayerBackgroundTask.dart
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
  await Future.wait([
    Hive.openBox<DownloadedParent>("DownloadedParents"),
    Hive.openBox<DownloadedSong>("DownloadedItems"),
    Hive.openBox<DownloadedSong>("DownloadIds"),
    Hive.openBox<FinampUser>("FinampUsers"),
    Hive.openBox<String>("CurrentUserId"),
    Hive.openBox<FinampSettings>("FinampSettings"),
    Hive.openBox<DownloadedImage>("DownloadedImages"),
    Hive.openBox<String>("DownloadedImageIds"),
    Hive.openBox<ThemeMode>("ThemeMode")
  ]);

  // If the settings box is empty, we add an initial settings value here.
  Box<FinampSettings> finampSettingsBox = Hive.box("FinampSettings");
  if (finampSettingsBox.isEmpty)
    finampSettingsBox.put("FinampSettings", await FinampSettings.create());

  // If no ThemeMode is set, we set it to the default (system)
  Box<ThemeMode> themeModeBox = Hive.box("ThemeMode");
  if (themeModeBox.isEmpty) ThemeModeHelper.setThemeMode(ThemeMode.system);
}

Future<void> _setupAudioServiceHelper() async {
  final session = await AudioSession.instance;
  session.configure(const AudioSessionConfiguration.music());

  final _audioHandler = await AudioService.init(
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

  GetIt.instance.registerSingleton<MusicPlayerBackgroundTask>(_audioHandler);
  GetIt.instance.registerSingleton(AudioServiceHelper());
}

/// Migrates the old DownloadLocations list to a map
void _migrateDownloadLocations() {
  final finampSettings = FinampSettingsHelper.finampSettings;

  // ignore: deprecated_member_use_from_same_package
  if (finampSettings.downloadLocations.isNotEmpty) {
    final Map<String, DownloadLocation> newMap = {};

    // ignore: deprecated_member_use_from_same_package
    finampSettings.downloadLocations.forEach((element) {
      // Generate a UUID and set the ID field for the DownloadsLocation
      final id = const Uuid().v4();
      element.id = id;
      newMap[id] = element;
    });

    finampSettings.downloadLocationsMap = newMap;

    // ignore: deprecated_member_use_from_same_package
    finampSettings.downloadLocations = List.empty();

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
    const Color accentColor = Color(0xFF00A4DC);
    const Color raisedDarkColor = Color(0xFF202020);
    const Color backgroundColor = Color(0xFF101010);
    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);

        if (!currentFocus.hasPrimaryFocus &&
            currentFocus.focusedChild != null) {
          FocusManager.instance.primaryFocus?.unfocus();
        }
      },
      child: ValueListenableBuilder<Box<ThemeMode>>(
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
                DownloadsScreen.routeName: (context) => const DownloadsScreen(),
                DownloadsErrorScreen.routeName: (context) =>
                    const DownloadsErrorScreen(),
                LogsScreen.routeName: (context) => const LogsScreen(),
                SettingsScreen.routeName: (context) => const SettingsScreen(),
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
              },
              initialRoute: SplashScreen.routeName,
              theme: ThemeData(
                  colorScheme: ColorScheme.fromSwatch(
                    primarySwatch: generateMaterialColor(accentColor),
                    brightness: Brightness.light,
                    accentColor: accentColor,
                  ),
                  appBarTheme: const AppBarTheme(
                    color: Colors.white,
                    foregroundColor: Colors.black,
                    systemOverlayStyle: const SystemUiOverlayStyle(
                        statusBarBrightness: Brightness.light),
                  ),
                  tabBarTheme: const TabBarTheme(
                    labelColor: Colors.black,
                  )),
              darkTheme: ThemeData(
                brightness: Brightness.dark,
                scaffoldBackgroundColor: backgroundColor,
                appBarTheme: const AppBarTheme(
                  color: raisedDarkColor,
                  systemOverlayStyle: const SystemUiOverlayStyle(
                      statusBarBrightness: Brightness.dark),
                ),
                cardColor: raisedDarkColor,
                bottomNavigationBarTheme: const BottomNavigationBarThemeData(
                    backgroundColor: raisedDarkColor),
                canvasColor: raisedDarkColor,
                toggleableActiveColor:
                    generateMaterialColor(accentColor).shade200,
                visualDensity: VisualDensity.adaptivePlatformDensity,
                colorScheme: ColorScheme.fromSwatch(
                  primarySwatch: generateMaterialColor(accentColor),
                  brightness: Brightness.dark,
                  accentColor: accentColor,
                ),
                indicatorColor: accentColor,
              ),
              themeMode: box.get("ThemeMode"),
            );
          }),
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
      home: Scaffold(
        body: Center(
          child: Text(
              "Something went wrong during app startup! The error was: ${error.toString()}\n\nPlease create a Github issue on github.com/UnicornsOnLSD/finamp with a screenshot of this page. If this page keeps showing, clear your app data to reset the app.\n\nIf you're upgrading to 0.5.0, you will have to reset your app data. This is because of large changes made to the data stored by the app that breaks previous data."),
        ),
      ),
    );
  }
}

class _DummyCallback {
  static void callback(String id, DownloadTaskStatus status, int progress) {
    // Add the event to the DownloadUpdateStream instance.
    final SendPort? send =
        IsolateNameServer.lookupPortByName('downloader_send_port');
    send!.send([id, status, progress]);
  }
}
