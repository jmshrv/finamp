import 'package:finamp/components/Buttons/cta_large.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';

import 'login_server_selection_page.dart';

class LoginSplashPage extends StatelessWidget {

  const LoginSplashPage({super.key});
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              children: [
                Hero(
                  tag: "finamp_logo",
                  child: Image.asset(
                    'images/finamp.png',
                    width: 300,
                    height: 300,
                  ),
                ),
                Text("Welcome to Finamp", style: Theme.of(context).textTheme.headlineMedium),
                const SizedBox(height: 40,),
                const Text("Your music, the way you want it."),
                const SizedBox(height: 40,),
                CTALarge(
                  text: "Get Started!",
                  icon: TablerIcons.music,
                  onPressed: () => Navigator.of(context).push(
                    PageRouteBuilder(
                      pageBuilder: (context, animation, secondaryAnimation) => const LoginServerSelectionPage(),
                      transitionsBuilder: (context, animation, secondaryAnimation, child) {
                        return child;
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
