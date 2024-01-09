import 'dart:convert';
import 'dart:io';

import 'package:finamp/models/jellyfin_models.dart';
import 'package:finamp/screens/logs_screen.dart';
import 'package:finamp/services/jellyfin_api_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get_it/get_it.dart';
import 'package:logging/logging.dart';

import 'login_user_selection_page.dart';

class LoginServerSelectionPage extends StatefulWidget {

  const LoginServerSelectionPage({super.key});
  
  @override
  State<LoginServerSelectionPage> createState() =>
      _LoginServerSelectionPageState();
}

class _LoginServerSelectionPageState extends State<LoginServerSelectionPage> {

  static final _loginServerSelectionPageLogger = Logger("LoginServerSelectionPage");

  final jellyfinApiHelper = GetIt.instance<JellyfinApiHelper>();
  final jellyfinServerClientDiscovery = JellyfinServerClientDiscovery();

  bool isTestingServerConnection = false;
  String? baseUrl;
  PublicSystemInfoResult? serverInfo;
  Map<Uri, PublicSystemInfoResult> discoveredServers = {};

  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    jellyfinServerClientDiscovery.discoverServers((ClientDiscoveryResponse response) async {
      _loginServerSelectionPageLogger.info("Found server: $response");

      final serverUrl = Uri.parse(response.address!);
      PublicSystemInfoResult? serverInfo = await jellyfinApiHelper.loadCustomServerPublicInfo(serverUrl);
      if (serverInfo != null) {
        // no need to filter duplicates, we're using a map
        setState(() {
          discoveredServers[serverUrl] = serverInfo;
        });
      }
      
    });
  }

  @override
  void dispose() {
    jellyfinServerClientDiscovery.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              children: [
                Hero(
                  tag: "finamp_logo",
                  child: Image.asset(
                    'images/finamp.png',
                    width: 200,
                    height: 200,
                  ),
                ),
                Text("Connect to Jellyfin", style: Theme.of(context).textTheme.headlineMedium),
                _buildServerUrlInput(context),
                Visibility(
                  visible: serverInfo != null,
                  child: JellyfinServerSelectionWidget(
                    baseUrl: baseUrl,
                    serverInfo: serverInfo,
                    onPressed: () => Navigator.of(context).push(
                      PageRouteBuilder(
                        pageBuilder: (context, animation, secondaryAnimation) =>
                            LoginUserSelectionPage(serverInfo: serverInfo!, baseUrl: baseUrl!),
                        transitionsBuilder: (context, animation, secondaryAnimation, child) {
                          return child;
                        },
                      ),
                    ),
                  )
                ),
                const Padding(
                  padding: EdgeInsets.only(top: 40.0, bottom: 16.0),
                  child: Text("Searching for servers..."),
                ),
                ListView.builder(
                  shrinkWrap: true,
                  itemCount: discoveredServers.length,
                  itemBuilder: (context, index) {
                    // final serverInfo = discoveredServers[index];
                    // get key and value
                    final entry = discoveredServers.entries.elementAt(index);
                    final serverUrl = entry.key;
                    final serverInfo = entry.value;
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: JellyfinServerSelectionWidget(
                        baseUrl: serverInfo.serverName,
                        serverInfo: serverInfo,
                        onPressed: () => Navigator.of(context).push(
                          PageRouteBuilder(
                            pageBuilder: (context, animation, secondaryAnimation) =>
                                LoginUserSelectionPage(serverInfo: serverInfo, baseUrl: serverUrl.toString()),
                            transitionsBuilder: (context, animation, secondaryAnimation, child) {
                              return child;
                            },
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Form _buildServerUrlInput(BuildContext context) {
    // This variable is for handling shifting focus when the user presses submit.
    // https://stackoverflow.com/questions/52150677/how-to-shift-focus-to-next-textfield-in-flutter
    final node = FocusScope.of(context);

    return Form(
      key: formKey,
      child: AutofillGroup(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                keyboardType: TextInputType.url,
                autocorrect: false,
                decoration: InputDecoration(
                  labelText: AppLocalizations.of(context)!.serverUrl,
                  hintText: "http://0.0.0.0:8096",
                  border: const OutlineInputBorder(),
                  suffixIcon: IconButton(
                    color: Theme.of(context).iconTheme.color,
                    icon: const Icon(Icons.info),
                    onPressed: () => showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        content: Text(AppLocalizations.of(context)!
                            .internalExternalIpExplanation),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(),
                            child: Text(MaterialLocalizations.of(context)
                                .okButtonLabel),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                textInputAction: TextInputAction.next,
                onEditingComplete: () => node.nextFocus(),
                onChanged: (value) async {
                  serverInfo = null;
                  baseUrl = value;
                  await testServerConnection();
                },
                validator: (value) {
                  if (value?.isEmpty == true) {
                    return AppLocalizations.of(context)!.emptyServerUrl;
                  }
                  if (!value!.trim().startsWith("http://") &&
                      !value.trim().startsWith("https://")) {
                    return AppLocalizations.of(context)!.urlStartWithHttps;
                  }
                  if (value.trim().endsWith("/")) {
                    return AppLocalizations.of(context)!.urlTrailingSlash;
                  }
                  return null;
                },
                onSaved: (newValue) => baseUrl = newValue,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> testServerConnection() async {

    if (formKey.currentState?.validate() == true && baseUrl != null) {
      formKey.currentState!.save();
      setState(() {
        isTestingServerConnection = true;
      });

      // We trim the base url in case the user accidentally added some trailing whitespace
      baseUrl = baseUrl!.trim();

      jellyfinApiHelper.baseUrlTemp = Uri.parse(baseUrl!);

      final publicServerInfo = await jellyfinApiHelper.loadServerPublicInfo();
      setState(() {
        isTestingServerConnection = false;
        serverInfo = publicServerInfo;
      });
    }
  }
}

class JellyfinServerSelectionWidget extends StatelessWidget {
  final String? baseUrl;
  final PublicSystemInfoResult? serverInfo;
  final void Function()? onPressed;
  final bool? connected;

  const JellyfinServerSelectionWidget({
    Key? key,
    required this.baseUrl,
    required this.serverInfo,
    this.onPressed,
    this.connected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {

    buildContent() {
      return Row(
        children: [
          Image.asset(
            'images/jellyfin-icon-transparent.png',
            width: 50,
            height: 50,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  serverInfo?.serverName ?? "",
                  style: Theme.of(context).textTheme.titleMedium,
                  softWrap: true,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  serverInfo?.version ?? "",
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                Text(
                  baseUrl ?? "",
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                Text(
                  serverInfo?.localAddress ?? "",
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ),
          connected != null ?
            Text(
              connected == true ? "Connected" : "Not connected",
              style: Theme.of(context).textTheme.bodySmall,
            ) :
            const SizedBox.shrink(),
        ],
      );
    }
    
    return onPressed != null ?
      ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Theme.of(context).colorScheme.surface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        onPressed: onPressed,
        child: buildContent(),
      ) :
      Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(10),
        ),
        child: buildContent(),
      );
  }
}

/// Used for discovering Jellyfin servers on the local network
/// https://jellyfin.org/docs/general/networking/#port-bindings
/// For some reason it's always being referred to as "client discovery" in the Jellyfin docs, even though we're actually discovering servers
class JellyfinServerClientDiscovery {

  static final _clientDiscoveryLogger = Logger("JellyfinServerClientDiscovery");
  
  late RawDatagramSocket socket;

  void discoverServers(void Function(ClientDiscoveryResponse response) onServerFound) async {

    socket = await RawDatagramSocket.bind(InternetAddress.anyIPv4, 0);
    socket.broadcastEnabled = true; // important to allow sending to broadcast address
    socket.multicastHops = 5; // to account for weird network setups
    
    socket.listen((event) {
      if (event == RawSocketEvent.read) {
        final datagram = socket.receive();
        if (datagram != null) {
          _clientDiscoveryLogger.fine("Received datagram: ${utf8.decode(datagram.data)}");
          final response = ClientDiscoveryResponse.fromJson(jsonDecode(utf8.decode(datagram.data)));
          onServerFound(response);
        }
      }
    });

    const message = "who is JellyfinServer?"; // doesn't seem to be case sensitive, but the Kotlin SDK uses this capitalization
    final broadcastAddress = InternetAddress("255.255.255.255"); // UDP broadcast address
    const destinationPort = 7359; // Jellyfin client discovery port

    // Send discovery message repeatedly to scan for local servers (because UDP is unreliable)

    _clientDiscoveryLogger.info("Sending discovery messages");

    socket.send(message.codeUnits, broadcastAddress, destinationPort);

    while (true) {
      await Future.delayed(const Duration(milliseconds: 500));
      socket.send(message.codeUnits, broadcastAddress, destinationPort);
    }
    
  }

  void dispose() {
    socket.close();
  }
  
}
