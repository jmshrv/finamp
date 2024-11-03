import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:finamp/components/LoginScreen/login_server_selection_page.dart';
import 'package:finamp/models/jellyfin_models.dart';
import 'package:finamp/screens/view_selector.dart';
import 'package:finamp/services/jellyfin_api_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get_it/get_it.dart';
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

                  final curveOffsetTween =
                      offsetTween.chain(CurveTween(curve: Curves.ease));

                  late final Animation<Offset> slidingAnimation =
                      pushingOrPoppingNext
                          ? curveOffsetTween.animate(secondaryAnimation)
                          : curveOffsetTween.animate(animation);
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
                onAuthenticated: () {
                  Navigator.of(context).popAndPushNamed(ViewSelector.routeName);
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
  final jellyfinApiHelper = GetIt.instance<JellyfinApiHelper>();
  static final serverStateLogger = Logger("LoginServerState");

  PublicSystemInfoResult? manualServer;
  Map<Uri, PublicSystemInfoResult> discoveredServers;
  PublicSystemInfoResult? selectedServer;
  String? baseUrl;
  Timer? connectionTestDebounceTimer;
  String? baseUrlToTest;
  JellyfinServerClientDiscovery clientDiscoveryHandler;
  VoidCallback? updateCallback;

  ServerState({
    required this.discoveredServers,
    this.updateCallback,
    this.manualServer,
    this.selectedServer,
    this.baseUrl,
  }) : clientDiscoveryHandler = JellyfinServerClientDiscovery();

  onBaseUrlChanged(String baseUrl) {
    if (connectionTestDebounceTimer?.isActive ?? false)
      connectionTestDebounceTimer?.cancel();
    connectionTestDebounceTimer =
        Timer(const Duration(milliseconds: 500), () async {
      updateCallback?.call();
      try {
        baseUrlToTest = baseUrl;
        updateCallback?.call();
        await testServerConnection(baseUrl);
        baseUrlToTest = null;
        updateCallback?.call();
      } catch (err) {
        // nop, make sure *not* to reset the baseUrlToTest
      }
    });
  }

  Future<void> testServerConnection(String baseUrl) async {
    if (baseUrl.isNotEmpty) {
      bool unspecifiedProtocol = false;
      bool unspecifiedPort = false;

      String baseUrlToTest = baseUrl!;

      // We trim the base url in case the user accidentally added some trailing whitespace
      baseUrlToTest = baseUrlToTest.trim();

      if (!(baseUrlToTest.startsWith("http://") ||
          baseUrlToTest.startsWith("https://"))) {
        // use https by default
        baseUrlToTest = "https://$baseUrlToTest";
        unspecifiedProtocol = true;
      }

      // use regex to check if a port is specified
      final portRegex = RegExp(r"[^\/]:\d+");
      if (!portRegex.hasMatch(baseUrlToTest)) {
        unspecifiedPort = true;
      }

      if (baseUrlToTest.endsWith("/")) {
        baseUrlToTest = baseUrlToTest.substring(0, baseUrlToTest.length - 1);
      }

      jellyfinApiHelper.baseUrlTemp = Uri.parse(baseUrlToTest);

      PublicSystemInfoResult? publicServerInfo;
      try {
        publicServerInfo = await jellyfinApiHelper.loadServerPublicInfo();
      } catch (error) {
        serverStateLogger.severe("Error loading server info: $error");
      }
      if (this.baseUrlToTest != baseUrl) {
        throw Exception("Server URL changed while testing");
      }

      if (publicServerInfo == null && unspecifiedProtocol) {
        // try http
        Uri url = Uri.parse(baseUrlToTest).replace(scheme: "http");
        baseUrlToTest = url.toString(); // update the local url
        jellyfinApiHelper.baseUrlTemp = url;
        try {
          publicServerInfo = await jellyfinApiHelper.loadServerPublicInfo();
        } catch (error) {
          serverStateLogger.severe("Error loading server info: $error");
        }
      }
      if (this.baseUrlToTest != baseUrl) {
        throw Exception("Server URL changed while testing");
      }

      if (publicServerInfo == null && unspecifiedPort) {
        // try default port 8096
        Uri url = Uri.parse(baseUrlToTest).replace(port: 8096);
        baseUrlToTest = url.toString(); // update the local url
        jellyfinApiHelper.baseUrlTemp = url;
        try {
          publicServerInfo = await jellyfinApiHelper.loadServerPublicInfo();
        } catch (error) {
          serverStateLogger.severe("Error loading server info: $error");
        }
      }
      if (this.baseUrlToTest != baseUrl) {
        throw Exception("Server URL changed while testing");
      }

      if (publicServerInfo != null) {
        manualServer = publicServerInfo;
        this.baseUrl = baseUrlToTest;
      }
    }
  }
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

  RawDatagramSocket? _socket;
  bool _isDisposed = false;

  void discoverServers(
      void Function(ClientDiscoveryResponse response) onServerFound) async {
    _isDisposed = false;

    _socket = await RawDatagramSocket.bind(InternetAddress.anyIPv4, 0);

    // We have to use ? throughout since _socket isn't final, although at this
    // point in the code it should never be null

    _socket?.broadcastEnabled =
        true; // important to allow sending to broadcast address
    _socket?.multicastHops = 5; // to account for weird network setups

    _socket?.listen((event) {
      if (event == RawSocketEvent.read) {
        final datagram = _socket?.receive();
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

    _socket?.send(message.codeUnits, broadcastAddress, destinationPort);

    while (!_isDisposed) {
      await Future.delayed(const Duration(milliseconds: 1500));
      _socket?.send(message.codeUnits, broadcastAddress, destinationPort);
    }
  }

  void dispose() {
    _isDisposed = true;
    _socket?.close();
  }
}
