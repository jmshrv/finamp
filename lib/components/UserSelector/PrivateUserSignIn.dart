import 'package:flutter/material.dart';

import 'loginHelper.dart';

class PrivateUserSignIn extends StatefulWidget {
  const PrivateUserSignIn({Key key}) : super(key: key);

  @override
  _PrivateUserSignInState createState() => _PrivateUserSignInState();
}

class _PrivateUserSignInState extends State<PrivateUserSignIn> {
  bool isAuthenticating = false;

  String _username;
  String _password;

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    // This variable is for handling shifting focus when the user presses submit.
    // https://stackoverflow.com/questions/52150677/how-to-shift-focus-to-next-textfield-in-flutter
    final node = FocusScope.of(context);

    return Form(
      key: _formKey,
      child: AutofillGroup(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Column(
              children: [
                FractionallySizedBox(
                  widthFactor: 0.9,
                  child: TextFormField(
                    decoration: InputDecoration(
                      labelText: "Username",
                      border: OutlineInputBorder(),
                    ),
                    autocorrect: false,
                    autofillHints: [AutofillHints.username],
                    textInputAction: TextInputAction.next,
                    onEditingComplete: () => node.nextFocus(),
                    validator: (value) {
                      if (value.isEmpty) {
                        return "Required";
                      }
                      return null;
                    },
                    onSaved: (newValue) => _username = newValue,
                  ),
                ),
                Padding(padding: EdgeInsets.symmetric(vertical: 8)),
                FractionallySizedBox(
                  widthFactor: 0.9,
                  child: TextFormField(
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: "Password",
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.visiblePassword,
                    autocorrect: false,
                    autofillHints: [AutofillHints.password],
                    textInputAction: TextInputAction.done,
                    onFieldSubmitted: (_) async => await sendForm(),
                    validator: (value) {
                      if (value.isEmpty) {
                        return "Required";
                      }
                      return null;
                    },
                    onSaved: (newValue) => _password = newValue,
                  ),
                ),
              ],
            ),
            FractionallySizedBox(
              widthFactor: 0.9,
              child: ElevatedButton(
                onPressed:
                    isAuthenticating ? null : () async => await sendForm(),
                child:
                    isAuthenticating ? Text("SIGNING IN...") : Text("SIGN IN"),
              ),
            )
          ],
        ),
      ),
    );
  }

  Future<void> sendForm() async {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      setState(() {
        isAuthenticating = true;
      });
      await loginHelper(
          username: _username, password: _password, context: context);
      setState(() {
        isAuthenticating = false;
      });
    }
  }
}
