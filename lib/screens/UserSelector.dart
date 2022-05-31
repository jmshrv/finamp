import 'package:flutter/material.dart';

import '../components/UserSelector/PrivateUserSignIn.dart';

class UserSelector extends StatelessWidget {
  const UserSelector({Key? key}) : super(key: key);

  static const routeName = "/login/userSelector";

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: PrivateUserSignIn()),
    );
  }
}
