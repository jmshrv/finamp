import 'dart:convert';
import 'dart:io';

import 'package:finamp/components/LoginScreen/login_server_selection_page.dart';
import 'package:finamp/models/jellyfin_models.dart';
import 'package:finamp/screens/view_selector.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:logging/logging.dart';

import 'login_authentication_page.dart';
import 'login_splash_page.dart';
import 'login_user_selection_page.dart';

class LoginFlow extends StatefulWidget {
  const LoginFlow({super.key});

  @override
  State<LoginFlow> createState() => _LoginFlowState();
}

final loginNavigatorKey = GlobalKey<NavigatorState>();

class _LoginFlowState extends State<LoginFlow> {
  ServerState serverState = ServerState(
    discoveredServers: {},
  );
  ConnectionState connectionState = ConnectionState();

  @override
  Widget build(BuildContext context) {
    // SignUpPage builds its own Navigator which ends up being a nested
    // Navigator in our app.
    return PopScope(
      // handle going back inside the nested Navigator while not on the first page
      canPop: false,
      onPopInvoked: (didPop) async {
        if (didPop) return;

        if (context.mounted) {
          if (!loginNavigatorKey.currentState!.canPop()) {
            Navigator.of(context).pop();
          } else {
            loginNavigatorKey.currentState!.pop();
          }
        }
      },
      child: Navigator(
        key: loginNavigatorKey,
        initialRoute: LoginSplashPage.routeName,
        onGenerateRoute: (RouteSettings settings) {
          Route route;

          Route createRoute(Widget page) => PageRouteBuilder(
                pageBuilder: (context, animation, secondaryAnimation) => page,
                transitionsBuilder:
                    (context, animation, secondaryAnimation, child) {

                  final pushingNext =
                      secondaryAnimation.status == AnimationStatus.forward;
                  final poppingNext =
                      secondaryAnimation.status == AnimationStatus.reverse;
                  final pushingOrPoppingNext = pushingNext || poppingNext;
                  late final Tween<Offset> offsetTween = pushingOrPoppingNext
                      ? Tween<Offset>(
                          begin: const Offset(0.0, 0.0),
                          end: const Offset(-1.0, 0.0))
                      : Tween<Offset>(
                          begin: const Offset(1.0, 0.0),
                          end: const Offset(0.0, 0.0));
                  late final Animation<Offset> slidingAnimation =
                      pushingOrPoppingNext
                          ? offsetTween.animate(secondaryAnimation)
                          : offsetTween.animate(animation);
                  return SlideTransition(
                      position: slidingAnimation, child: child);

                },
              );

          switch (settings.name) {
            case LoginSplashPage.routeName:
              route = createRoute(LoginSplashPage(
                onGetStartedPressed: () => loginNavigatorKey.currentState!
                    .pushNamed(LoginServerSelectionPage.routeName),
              ));
              break;
            case LoginServerSelectionPage.routeName:
              route = createRoute(LoginServerSelectionPage(
                serverState: serverState,
                onServerSelected:
                    (PublicSystemInfoResult server, String baseUrl) {
                  serverState.selectedServer = server;
                  serverState.baseUrl = baseUrl;
                  serverState.clientDiscoveryHandler.dispose();
                  loginNavigatorKey.currentState!
                      .pushNamed(LoginUserSelectionPage.routeName);
                },
              ));
              break;
            case LoginUserSelectionPage.routeName:
              route = createRoute(LoginUserSelectionPage(
                serverState: serverState,
                connectionState: connectionState,
                onUserSelected: (UserDto? user) {
                  connectionState.selectedUser = user;
                  loginNavigatorKey.currentState!
                      .pushNamed(LoginAuthenticationPage.routeName);
                },
              ));
              break;
            case LoginAuthenticationPage.routeName:
              route = createRoute(LoginAuthenticationPage(
                connectionState: connectionState,
                onAuthenticated: () {
                  Navigator.of(context).popAndPushNamed(ViewSelector.routeName);
                },
              ));
              break;
            default:
              throw Exception('Invalid route: ${settings.name}');
          }
          // return MaterialPageRoute<void>(builder: builder, settings: settings);
          return route;
        },
      ),
    );
  }
}

class ServerState {
  PublicSystemInfoResult? manualServer;
  Map<Uri, PublicSystemInfoResult> discoveredServers;
  PublicSystemInfoResult? selectedServer;
  String? baseUrl;
  bool isTestingServerConnection;
  JellyfinServerClientDiscovery clientDiscoveryHandler;

  ServerState({
    required this.discoveredServers,
    this.isTestingServerConnection = false,
    this.manualServer,
    this.selectedServer,
    this.baseUrl,
  }) : clientDiscoveryHandler = JellyfinServerClientDiscovery();
}

class ConnectionState {
  bool isConnected;
  bool isAuthenticating;
  QuickConnectState? quickConnectState;
  UserDto? selectedUser;

  ConnectionState({
    this.isConnected = false,
    this.isAuthenticating = false,
    this.quickConnectState,
    this.selectedUser,
  });
}

/// Used for discovering Jellyfin servers on the local network
/// https://jellyfin.org/docs/general/networking/#port-bindings
/// For some reason it's always being referred to as "client discovery" in the Jellyfin docs, even though we're actually discovering servers
class JellyfinServerClientDiscovery {
  static final _clientDiscoveryLogger = Logger("JellyfinServerClientDiscovery");

  late RawDatagramSocket socket;
  bool isDisposed = false;

  void discoverServers(
      void Function(ClientDiscoveryResponse response) onServerFound) async {
    isDisposed = false;

    socket = await RawDatagramSocket.bind(InternetAddress.anyIPv4, 0);
    socket.broadcastEnabled =
        true; // important to allow sending to broadcast address
    socket.multicastHops = 5; // to account for weird network setups

    socket.listen((event) {
      if (event == RawSocketEvent.read) {
        final datagram = socket.receive();
        if (datagram != null) {
          _clientDiscoveryLogger
              .finest("Received datagram: ${utf8.decode(datagram.data)}");
          final response = ClientDiscoveryResponse.fromJson(
              jsonDecode(utf8.decode(datagram.data)));
          onServerFound(response);
        }
      }
    });

    const message =
        "who is JellyfinServer?"; // doesn't seem to be case sensitive, but the Kotlin SDK uses this capitalization
    final broadcastAddress =
        InternetAddress("255.255.255.255"); // UDP broadcast address
    const destinationPort = 7359; // Jellyfin client discovery port

    // Send discovery message repeatedly to scan for local servers (because UDP is unreliable)

    _clientDiscoveryLogger.fine("Sending discovery messages");

    socket.send(message.codeUnits, broadcastAddress, destinationPort);

    while (!isDisposed) {
      await Future.delayed(const Duration(milliseconds: 1500));
      socket.send(message.codeUnits, broadcastAddress, destinationPort);
    }
  }

  void dispose() {
    isDisposed = true;
    socket.close();
  }
}
