import 'package:finamp/components/Buttons/simple_button.dart';
import 'package:finamp/models/jellyfin_models.dart';
import 'package:finamp/services/jellyfin_api_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:get_it/get_it.dart';
import 'package:logging/logging.dart';

import 'login_flow.dart';

class LoginServerSelectionPage extends StatefulWidget {
  static const routeName = "login/server-selection";

  final ServerState serverState;
  final void Function(PublicSystemInfoResult server, String baseUrl)?
      onServerSelected;

  const LoginServerSelectionPage({
    super.key,
    required this.serverState,
    this.onServerSelected,
  });

  @override
  State<LoginServerSelectionPage> createState() =>
      _LoginServerSelectionPageState();
}

class _LoginServerSelectionPageState extends State<LoginServerSelectionPage> {
  static final _loginServerSelectionPageLogger =
      Logger("LoginServerSelectionPage");

  final jellyfinApiHelper = GetIt.instance<JellyfinApiHelper>();
  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();

    widget.serverState.clientDiscoveryHandler
        .discoverServers((ClientDiscoveryResponse response) async {
      _loginServerSelectionPageLogger
          .finer("Found server: ${response.name} at ${response.address}");

      final serverUrl = Uri.parse(response.address!);
      PublicSystemInfoResult? serverInfo =
          await jellyfinApiHelper.loadCustomServerPublicInfo(serverUrl);
      _loginServerSelectionPageLogger
          .finer("Server info: ${serverInfo?.toJson()}");
      if (serverInfo != null && mounted) {
        // no need to filter duplicates, we're using a map
        setState(() {
          widget.serverState.discoveredServers[serverUrl] = serverInfo;
        });
      }
    });
  }

  @override
  void deactivate() {
    widget.serverState.clientDiscoveryHandler.dispose();
    super.deactivate();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 32.0, bottom: 20.0),
                child: Hero(
                  tag: "finamp_logo",
                  child: Image.asset(
                    'images/finamp_cropped.png',
                    width: 75,
                    height: 75,
                  ),
                ),
              ),
              Text(AppLocalizations.of(context)!.loginFlowServerSelectionHeading,
                  style: Theme.of(context).textTheme.headlineMedium),
              Padding(
                padding: const EdgeInsets.only(top: 12.0, bottom: 12.0),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: SimpleButton(
                    icon: TablerIcons.chevron_left,
                    text: AppLocalizations.of(context)!.back,
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ),
              ),
              _buildServerUrlInput(context),
              Visibility(
                  visible: widget.serverState.manualServer != null,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 12.0),
                    child: JellyfinServerSelectionWidget(
                      baseUrl: widget.serverState.baseUrl,
                      serverInfo: widget.serverState.manualServer,
                      onPressed: () {
                        widget.onServerSelected?.call(
                            widget.serverState.manualServer!,
                            widget.serverState.baseUrl!);
                      },
                    ),
                  )),
              Padding(
                padding: const EdgeInsets.only(top: 40.0, bottom: 16.0),
                child: Text(
                  AppLocalizations.of(context)!.loginFlowLocalNetworkServers,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ),
              SizedBox(
                height: 180,
                child: ListView.builder(
                  shrinkWrap: true,
                  clipBehavior: Clip.antiAlias,
                  itemCount: widget.serverState.discoveredServers.length,
                  itemBuilder: (context, index) {
                    // final serverInfo = discoveredServers[index];
                    // get key and value
                    final entry = widget.serverState.discoveredServers.entries
                        .elementAt(index);
                    final serverUrl = entry.key;
                    final serverInfo = entry.value;
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: JellyfinServerSelectionWidget(
                          baseUrl: null,
                          serverInfo: serverInfo,
                          onPressed: () {
                            widget.onServerSelected
                                ?.call(serverInfo, serverUrl.toString());
                          }),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Form _buildServerUrlInput(BuildContext context) {
    // This variable is for handling shifting focus when the user presses submit.
    // https://stackoverflow.com/questions/52150677/how-to-shift-focus-to-next-textfield-in-flutter
    final node = FocusScope.of(context);

    InputDecoration inputFieldDecoration(String placeholder) {
      return InputDecoration(
        filled: true,
        fillColor: Theme.of(context).colorScheme.surfaceVariant,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
        label: Text(placeholder),
        floatingLabelBehavior: FloatingLabelBehavior.never,
        border: OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: BorderRadius.circular(16),
        ),
        suffixIcon: IconButton(
          color: Theme.of(context).iconTheme.color,
          icon: const Icon(Icons.info),
          onPressed: () => showDialog(
            context: context,
            builder: (context) => AlertDialog(
              content: Text(
                  AppLocalizations.of(context)!.internalExternalIpExplanation),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text(MaterialLocalizations.of(context).okButtonLabel),
                )
              ],
            ),
          ),
        ),
      );
    }

    return Form(
      key: formKey,
      child: AutofillGroup(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
                child: Text(
                  AppLocalizations.of(context)!.serverUrl,
                  textAlign: TextAlign.start,
                )),
            TextFormField(
              autocorrect: false,
              keyboardType: TextInputType.url,
              autofillHints: const [AutofillHints.url],
              decoration: inputFieldDecoration(AppLocalizations.of(context)!.serverUrlHint),
              textInputAction: TextInputAction.next,
              onEditingComplete: () => node.nextFocus(),
              onChanged: (value) async {
                widget.serverState.manualServer = null;
                widget.serverState.baseUrl = value;
                await testServerConnection();
              },
              validator: (value) {
                if (value?.isEmpty == true) {
                  return AppLocalizations.of(context)!.emptyServerUrl;
                }
                return null;
              },
              onSaved: (newValue) => widget.serverState.baseUrl = newValue,
            ),
          ],
        ),
      ),
    );
  }

  Future<void> testServerConnection() async {
    if (formKey.currentState?.validate() == true &&
        widget.serverState.baseUrl != null) {
      bool unspecifiedProtocol = false;
      bool unspecifiedPort = false;

      formKey.currentState!.save();
      setState(() {
        widget.serverState.isTestingServerConnection = true;
      });

      String baseUrlToTest = widget.serverState.baseUrl!;

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
        baseUrlToTest = baseUrlToTest
            .substring(0, baseUrlToTest.length - 1);
      }

      jellyfinApiHelper.baseUrlTemp = Uri.parse(baseUrlToTest);

      PublicSystemInfoResult? publicServerInfo;
      try {
        publicServerInfo = await jellyfinApiHelper.loadServerPublicInfo();
      } catch (error) {
        _loginServerSelectionPageLogger
            .severe("Error loading server info: $error");
      }

      if (publicServerInfo == null && unspecifiedProtocol) {
        // try http
        Uri url = Uri.parse(baseUrlToTest).replace(scheme: "http");
        baseUrlToTest = url.toString(); // update the local url
        jellyfinApiHelper.baseUrlTemp = url;
        try {
          publicServerInfo = await jellyfinApiHelper.loadServerPublicInfo();
        } catch (error) {
          _loginServerSelectionPageLogger
              .severe("Error loading server info: $error");
        }
      }

      if (publicServerInfo == null && unspecifiedPort) {
        // try default port 8096
        Uri url = Uri.parse(baseUrlToTest).replace(port: 8096);
        baseUrlToTest = url.toString(); // update the local url
        jellyfinApiHelper.baseUrlTemp = url;
        try {
          publicServerInfo = await jellyfinApiHelper.loadServerPublicInfo();
        } catch (error) {
          _loginServerSelectionPageLogger
              .severe("Error loading server info: $error");
        }
      }

      if (publicServerInfo != null) {
        setState(() {
          widget.serverState.isTestingServerConnection = false;
          widget.serverState.manualServer = publicServerInfo;
          widget.serverState.baseUrl = baseUrlToTest;
        });
      }
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
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            'images/jellyfin-icon-transparent.png',
            width: 36,
            height: 36,
          ),
          const SizedBox(width: 12.0),
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
                  "v${serverInfo?.version}",
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                if (baseUrl != null)
                  Text(
                    baseUrl ?? "",
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                if (serverInfo?.localAddress != baseUrl)
                  Text(
                    serverInfo?.localAddress ?? "",
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
              ],
            ),
          ),
          // connected != null
          //     ? Text(
          //         connected == true ? "Connected" : "Connecting...",
          //         style: Theme.of(context).textTheme.bodySmall,
          //       )
          //     : const SizedBox.shrink(),
        ],
      );
    }

    return onPressed != null
        ? ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.surface,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 4.0),
            ),
            onPressed: onPressed,
            child: buildContent(),
          )
        : Container(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primaryContainer,
              borderRadius: BorderRadius.circular(10),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
            child: buildContent(),
          );
  }
}
