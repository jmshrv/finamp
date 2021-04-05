import 'package:flutter/material.dart';

import 'loginHelper.dart';

class PrivateUserSignIn extends StatefulWidget {
  const PrivateUserSignIn({Key key}) : super(key: key);

  @override
  _PrivateUserSignInState createState() => _PrivateUserSignInState();
}

class _PrivateUserSignInState extends State<PrivateUserSignIn> {
  bool isAuthenticating = false;

  String baseUrl;
  String username;
  String password;

  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    // This variable is for handling shifting focus when the user presses submit.
    // https://stackoverflow.com/questions/52150677/how-to-shift-focus-to-next-textfield-in-flutter
    final node = FocusScope.of(context);

    return Stack(
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
                    decoration: InputDecoration(
                      labelText: "Base URL",
                      border: OutlineInputBorder(),
                    ),
                    textInputAction: TextInputAction.next,
                    onEditingComplete: () => node.nextFocus(),
                    validator: (value) {
                      if (value.isEmpty) {
                        return "Base URL cannot be empty";
                      }
                      if (!value.startsWith("http://") &&
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
                          autofillHints: [AutofillHints.username],
                          decoration: InputDecoration(
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
                          autofillHints: [AutofillHints.password],
                          decoration: InputDecoration(
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
          alignment: Alignment.bottomRight,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
            child: ElevatedButton(
              child: Text("NEXT"),
              onPressed: isAuthenticating ? null : () async => await sendForm(),
            ),
          ),
        )
      ],
    );
  }

  Future<void> sendForm() async {
    if (formKey.currentState.validate()) {
      formKey.currentState.save();
      setState(() {
        isAuthenticating = true;
      });
      await loginHelper(
        username: username,
        password: password,
        baseUrl: baseUrl,
        context: context,
      );
      setState(() {
        isAuthenticating = false;
      });
    }
  }
}
