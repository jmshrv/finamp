import 'package:flutter/material.dart';

import '../components/UserSelector/private_user_sign_in.dart';
import 'language_selection_screen.dart';

class UserSelector extends StatelessWidget {
  const UserSelector({Key? key}) : super(key: key);

  static const routeName = "/login/userSelector";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () => Navigator.of(context)
                .pushNamed(LanguageSelectionScreen.routeName),
            icon: const Icon(Icons.language),
          )
        ],
      ),
      body: const Center(child: PrivateUserSignIn()),
    );
  }
}
