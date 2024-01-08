

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'login_splash_page.dart';

class LoginFlow extends StatefulWidget {
  const LoginFlow({Key? key}) : super(key: key);

  @override
  LoginFlowState createState() => LoginFlowState();
}

// a PageRouteTransition that has multiple pages and contains various Hero widgets
class LoginFlowState extends State<LoginFlow> {

  @override
  Widget build(BuildContext context) {
    return const LoginSplashPage();
  }
}

Route createLoginFlowRouter(BuildContext context) {
  return PageRouteBuilder(
    // settings: settings,
    pageBuilder: (context, animation, secondaryAnimation) => const LoginFlow(),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      return child;
    },
  );
}
