import 'package:flutter/material.dart';

import '../components/UserSelector/PublicUserBoxes.dart';
import '../components/UserSelector/PrivateUserSignIn.dart';

class UserSelector extends StatelessWidget {
  const UserSelector({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Select User"),
      ),
      body: ListView(
        children: [
          Container(
            alignment: Alignment.centerLeft,
            padding: EdgeInsets.all(8),
            child: Text(
              "Public Users",
              style: Theme.of(context).textTheme.headline6,
            ),
          ),
          PublicUserBoxes(),
          Divider(
            indent: 8,
            endIndent: 8,
          ),
          Container(
            alignment: Alignment.centerLeft,
            // There's already some padding from the divider so we don't need top padding.
            padding: EdgeInsets.only(bottom: 8, left: 8),
            child: Text(
              "Sign In",
              style: Theme.of(context).textTheme.headline6,
            ),
          ),
          PrivateUserSignIn(),
        ],
      ),
    );
  }
}
