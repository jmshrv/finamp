import 'package:flutter/material.dart';

import '../components/UserSelector/PrivateUserSignIn.dart';

class UserSelector extends StatelessWidget {
  const UserSelector({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Sign In"),
      ),
      body: Center(child: PrivateUserSignIn()),
    );
  }
}
