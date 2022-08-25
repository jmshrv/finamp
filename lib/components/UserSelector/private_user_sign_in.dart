import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get_it/get_it.dart';

import '../../screens/logs_screen.dart';
import '../../screens/view_selector.dart';
import '../../services/jellyfin_api_helper.dart';
import '../error_snackbar.dart';

class PrivateUserSignIn extends StatefulWidget {
  const PrivateUserSignIn({Key? key}) : super(key: key);

  @override
  State<PrivateUserSignIn> createState() => _PrivateUserSignInState();
}

class _PrivateUserSignInState extends State<PrivateUserSignIn> {
  bool isAuthenticating = false;

  String? baseUrl;
  String? username;
  String? password;

  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    // This variable is for handling shifting focus when the user presses submit.
    // https://stackoverflow.com/questions/52150677/how-to-shift-focus-to-next-textfield-in-flutter
    final node = FocusScope.of(context);

    return SafeArea(
      child: Stack(
        children: [
          Form(
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
                      validator: (value) {
                        if (value?.isEmpty == true) {
                          return AppLocalizations.of(context)!.emptyServerUrl;
                        }
                        if (!value!.startsWith("http://") &&
                            !value.startsWith("https://")) {
                          return AppLocalizations.of(context)!
                              .urlStartWithHttps;
                        }
                        if (value.endsWith("/")) {
                          return AppLocalizations.of(context)!.urlTrailingSlash;
                        }
                        return null;
                      },
                      onSaved: (newValue) => baseUrl = newValue,
                    ),
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextFormField(
                            autocorrect: false,
                            keyboardType: TextInputType.visiblePassword,
                            autofillHints: const [AutofillHints.username],
                            decoration: InputDecoration(
                              border: const OutlineInputBorder(),
                              labelText: AppLocalizations.of(context)!.username,
                            ),
                            textInputAction: TextInputAction.next,
                            onEditingComplete: () => node.nextFocus(),
                            onSaved: (newValue) => username = newValue,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextFormField(
                            autocorrect: false,
                            obscureText: true,
                            keyboardType: TextInputType.visiblePassword,
                            autofillHints: const [AutofillHints.password],
                            decoration: InputDecoration(
                              border: const OutlineInputBorder(),
                              labelText: AppLocalizations.of(context)!.password,
                            ),
                            textInputAction: TextInputAction.done,
                            onFieldSubmitted: (_) async => await sendForm(),
                            onSaved: (newValue) => password = newValue,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  TextButton(
                    onPressed: () =>
                        Navigator.of(context).pushNamed(LogsScreen.routeName),
                    child:
                        Text(AppLocalizations.of(context)!.logs.toUpperCase()),
                  ),
                  ElevatedButton(
                    onPressed:
                        isAuthenticating ? null : () async => await sendForm(),
                    child:
                        Text(AppLocalizations.of(context)!.next.toUpperCase()),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  /// Function to handle logging in for Widgets, including a snackbar for errors.
  Future<void> loginHelper(
      {required String username,
      String? password,
      required String baseUrl,
      required BuildContext context}) async {
    JellyfinApiHelper jellyfinApiHelper = GetIt.instance<JellyfinApiHelper>();

    // We trim the base url in case the user accidentally added some trailing whitespce
    baseUrl = baseUrl.trim();

    jellyfinApiHelper.baseUrlTemp = baseUrl;

    try {
      if (password == null) {
        await jellyfinApiHelper.authenticateViaName(username: username);
      } else {
        await jellyfinApiHelper.authenticateViaName(
          username: username,
          password: password,
        );
      }

      if (!mounted) return;

      Navigator.of(context).pushNamed(ViewSelector.routeName);
    } catch (e) {
      errorSnackbar(e, context);

      // We return here to stop the function from continuing.
      return;
    }
  }

  Future<void> sendForm() async {
    if (formKey.currentState?.validate() == true) {
      formKey.currentState!.save();
      setState(() {
        isAuthenticating = true;
      });
      await loginHelper(
        username: username!,
        password: password,
        baseUrl: baseUrl!,
        context: context,
      );
      setState(() {
        isAuthenticating = false;
      });
    }
  }
}
