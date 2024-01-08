import 'package:finamp/models/jellyfin_models.dart';
import 'package:finamp/screens/logs_screen.dart';
import 'package:finamp/services/jellyfin_api_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get_it/get_it.dart';

import 'login_user_selection_page.dart';

class LoginServerSelectionPage extends StatefulWidget {

  const LoginServerSelectionPage({super.key});
  
  @override
  State<LoginServerSelectionPage> createState() =>
      _LoginServerSelectionPageState();
}

class _LoginServerSelectionPageState extends State<LoginServerSelectionPage> {
  bool isTestingServerConnection = false;

  String? baseUrl;
  PublicSystemInfoResult? serverInfo;

  final formKey = GlobalKey<FormState>();

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
                            LoginUserSelectionPage(serverInfo: serverInfo!),
                        transitionsBuilder: (context, animation, secondaryAnimation, child) {
                          return child;
                        },
                      ),
                    ),
                  )
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        TextButton(
                          onPressed: () => Navigator.of(context)
                              .pushNamed(LogsScreen.routeName),
                          child: Text(
                              AppLocalizations.of(context)!.logs.toUpperCase()),
                        ),
                      ],
                    ),
                  ),
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
    JellyfinApiHelper jellyfinApiHelper = GetIt.instance<JellyfinApiHelper>();

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
          Column(
            children: [
              Text(
                serverInfo?.serverName ?? "",
                style: Theme.of(context).textTheme.headlineSmall,
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
