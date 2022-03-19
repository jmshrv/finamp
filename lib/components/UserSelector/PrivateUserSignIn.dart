import 'package:flutter/material.dart';

import 'loginHelper.dart';

class PrivateUserSignIn extends StatefulWidget {
  const PrivateUserSignIn({Key? key}) : super(key: key);

  @override
  _PrivateUserSignInState createState() => _PrivateUserSignInState();
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
                    onPressed: () => Navigator.of(context).pushNamed("/logs"),
                    child: const Text("LOGS"),
                  ),
                  ElevatedButton(
                    child: const Text("NEXT"),
                    onPressed:
                        isAuthenticating ? null : () async => await sendForm(),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
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
