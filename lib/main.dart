import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:get_it/get_it.dart';
import 'package:logging/logging.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'generateMaterialColor.dart';
import 'screens/ServerSelector.dart';
import 'screens/UserSelector.dart';
import 'screens/MusicScreen.dart';
import 'screens/ViewSelector.dart';
import 'screens/AlbumScreen.dart';
import 'screens/PlayerScreen.dart';
import 'screens/SplashScreen.dart';
import 'screens/DownloadsErrorScreen.dart';
import 'screens/DownloadsScreen.dart';
import 'screens/ArtistScreen.dart';
import 'services/AudioServiceHelper.dart';
import 'services/JellyfinApiData.dart';
import 'services/DownloadsHelper.dart';
import 'models/JellyfinModels.dart';
import 'models/FinampModels.dart';

void main() async {
  _setupLogging();
  await setupHive();
  _setupJellyfinApiData();
  await _setupDownloader();
  _setupDownloadsHelper();
  _setupAudioServiceHelper();
  runApp(Finamp());
}

void _setupLogging() {
  Logger.root.level = Level.ALL;
  Logger.root.onRecord.listen((event) =>
      print("[${event.level.name}] ${event.time}: ${event.message}"));
}

void _setupJellyfinApiData() {
  GetIt.instance.registerSingleton(JellyfinApiData());
}

void _setupDownloadsHelper() {
  GetIt.instance.registerSingleton(DownloadsHelper());
}

Future<void> _setupDownloader() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FlutterDownloader.initialize(debug: true);
}

// TODO: move this function somewhere else since it's also run in MusicPlayerBackgroundTask.dart
Future<void> setupHive() async {
  await Hive.initFlutter();
  Hive.registerAdapter(BaseItemDtoAdapter());
  Hive.registerAdapter(UserItemDataDtoAdapter());
  Hive.registerAdapter(NameIdPairAdapter());
  Hive.registerAdapter(DownloadedSongAdapter());
  Hive.registerAdapter(DownloadedAlbumAdapter());
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
  await Future.wait([
    Hive.openBox<DownloadedAlbum>("DownloadedAlbums"),
    Hive.openBox<DownloadedSong>("DownloadedItems"),
    Hive.openBox<DownloadedSong>("DownloadIds"),
    Hive.openBox<FinampUser>("FinampUsers"),
    Hive.openBox<String>("CurrentUserId"),
  ]);
}

void _setupAudioServiceHelper() {
  GetIt.instance.registerSingleton(AudioServiceHelper());
}

class Finamp extends StatelessWidget {
  const Finamp({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const Color accentColor = Color(0xFF00A4DC);
    const Color raisedDarkColor = Color(0xFF202020);
    const Color backgroundColor = Color(0xFF101010);
    return AudioServiceWidget(
      // This gesture detector is for dismissing the keyboard by tapping on the screen
      child: GestureDetector(
        onTap: () {
          FocusScopeNode currentFocus = FocusScope.of(context);

          if (!currentFocus.hasPrimaryFocus &&
              currentFocus.focusedChild != null) {
            FocusManager.instance.primaryFocus.unfocus();
          }
        },
        child: MaterialApp(
          routes: {
            "/": (context) => SplashScreen(),
            "/login/serverSelector": (context) => ServerSelector(),
            "/login/userSelector": (context) => UserSelector(),
            "/settings/views": (context) => ViewSelector(),
            "/music": (context) => MusicScreen(),
            "/music/albumscreen": (context) => AlbumScreen(),
            "/music/artistscreen": (context) => ArtistScreen(),
            "/nowplaying": (context) => PlayerScreen(),
            "/downloads": (context) => DownloadsScreen(),
            "/downloads/errors": (context) => DownloadsErrorScreen(),
          },
          initialRoute: "/",
          darkTheme: ThemeData(
              primarySwatch: generateMaterialColor(accentColor),
              brightness: Brightness.dark,
              scaffoldBackgroundColor: backgroundColor,
              appBarTheme: AppBarTheme(
                color: raisedDarkColor,
              ),
              cardColor: raisedDarkColor,
              accentColor: accentColor,
              bottomNavigationBarTheme: BottomNavigationBarThemeData(
                  backgroundColor: raisedDarkColor),
              canvasColor: raisedDarkColor,
              toggleableActiveColor:
                  generateMaterialColor(accentColor).shade200),
          themeMode: ThemeMode.dark,
        ),
      ),
    );
  }
}
