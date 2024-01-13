import 'dart:convert';
import 'dart:io';

import 'package:finamp/models/jellyfin_models.dart';
import 'package:finamp/screens/logs_screen.dart';
import 'package:finamp/services/jellyfin_api_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get_it/get_it.dart';
import 'package:logging/logging.dart';

import 'login_flow.dart';
import 'login_user_selection_page.dart';

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
              Hero(
                tag: "finamp_logo",
                child: Image.asset(
                  'images/finamp.png',
                  width: 150,
                  height: 150,
                ),
              ),
              Text("Connect to Jellyfin",
                  style: Theme.of(context).textTheme.headlineMedium),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 0.0, vertical: 32.0),
                child: _buildServerUrlInput(context),
              ),
              Visibility(
                  visible: widget.serverState.manualServer != null,
                  child: Hero(
                    tag: widget.serverState.manualServer?.id ?? "manual-server",
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
              const Padding(
                padding: EdgeInsets.only(top: 40.0, bottom: 16.0),
                child: Text("Searching for servers..."),
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
                    print("key: ${serverInfo.id}");
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: Hero(
                        tag: serverInfo.id ?? "discovered-server-$index",
                        child: JellyfinServerSelectionWidget(
                            baseUrl: null,
                            serverInfo: serverInfo,
                            onPressed: () {
                              widget.onServerSelected
                                  ?.call(serverInfo, serverUrl.toString());
                            }),
                      ),
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
              decoration: inputFieldDecoration("e.g. demo.jellyfin.org"),
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
                // if (!value!.trim().startsWith("http://") &&
                //     !value.trim().startsWith("https://")) {
                //   return AppLocalizations.of(context)!.urlStartWithHttps;
                // }
                // if (value.trim().endsWith("/")) {
                //   return AppLocalizations.of(context)!.urlTrailingSlash;
                // }
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

      // We trim the base url in case the user accidentally added some trailing whitespace
      widget.serverState.baseUrl = widget.serverState.baseUrl!.trim();

      if (!(widget.serverState.baseUrl!.startsWith("http://") ||
          widget.serverState.baseUrl!.startsWith("https://"))) {
        // use https by default
        widget.serverState.baseUrl = "https://${widget.serverState.baseUrl}";
        unspecifiedProtocol = true;
      }

      // use regex to check if a port is specified
      final portRegex = RegExp(r"[^\/]:\d+");
      if (!portRegex.hasMatch(widget.serverState.baseUrl!)) {
        unspecifiedPort = true;
      }

      if (widget.serverState.baseUrl!.endsWith("/")) {
        widget.serverState.baseUrl = widget.serverState.baseUrl!
            .substring(0, widget.serverState.baseUrl!.length - 1);
      }

      jellyfinApiHelper.baseUrlTemp = Uri.parse(widget.serverState.baseUrl!);

      PublicSystemInfoResult? publicServerInfo;
      try {
        publicServerInfo = await jellyfinApiHelper.loadServerPublicInfo();
      } catch (error) {
        _loginServerSelectionPageLogger
            .severe("Error loading server info: $error");
      }

      if (publicServerInfo == null && unspecifiedProtocol) {
        // try http
        widget.serverState.baseUrl =
            widget.serverState.baseUrl!.replaceFirst("https://", "http://");
        jellyfinApiHelper.baseUrlTemp = Uri.parse(widget.serverState.baseUrl!);
        try {
          publicServerInfo = await jellyfinApiHelper.loadServerPublicInfo();
        } catch (error) {
          _loginServerSelectionPageLogger
              .severe("Error loading server info: $error");
        }
      }

      if (publicServerInfo == null && unspecifiedPort) {
        // try default port 8096
        widget.serverState.baseUrl = "${widget.serverState.baseUrl}:8096";
        jellyfinApiHelper.baseUrlTemp = Uri.parse(widget.serverState.baseUrl!);
        try {
          publicServerInfo = await jellyfinApiHelper.loadServerPublicInfo();
        } catch (error) {
          _loginServerSelectionPageLogger
              .severe("Error loading server info: $error");
        }
      }

      setState(() {
        widget.serverState.isTestingServerConnection = false;
        widget.serverState.manualServer = publicServerInfo;
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
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 0.0, vertical: 8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'images/jellyfin-icon-transparent.png',
              width: 48,
              height: 48,
            ),
            const SizedBox(width: 20.0),
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
            //         connected == true ? "Connected" : "Not connected",
            //         style: Theme.of(context).textTheme.bodySmall,
            //       )
            //     : const SizedBox.shrink(),
          ],
        ),
      );
    }

    return onPressed != null
        ? ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.surface,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
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
