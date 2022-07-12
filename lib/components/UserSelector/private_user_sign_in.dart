import 'package:flutter/material.dart';
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
                        labelText: "Server URL",
                        hintText: "http://0.0.0.0:8096",
                        border: const OutlineInputBorder(),
                        suffixIcon: IconButton(
                          color: Theme.of(context).iconTheme.color,
                          icon: const Icon(Icons.info),
                          onPressed: () => showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              content: const Text(
                                  "If you want to be able to access your Jellyfin server remotely, you need to use your external IP.\n\nIf your server is on a HTTP port (80/443), you don't have to specify a port. This will likely be the case if your server is behind a reverse proxy."),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.of(context).pop(),
                                  child: const Text("OK"),
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
                          return "Server URL cannot be empty";
                        }
                        if (!value!.startsWith("http://") &&
                            !value.startsWith("https://")) {
                          return "URL must start with http:// or https://";
                        }
                        if (value.endsWith("/")) {
                          return "URL must not include a trailing slash";
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
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: "Username",
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
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: "Password",
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
                    child: const Text("LOGS"),
                  ),
                  ElevatedButton(
                    onPressed:
                        isAuthenticating ? null : () async => await sendForm(),
                    child: const Text("NEXT"),
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
