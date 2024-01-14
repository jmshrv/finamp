import 'package:finamp/components/Buttons/cta_large.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';

import 'login_flow.dart';
import 'login_server_selection_page.dart';

class LoginSplashPage extends StatelessWidget {
  static const routeName = "login/splash";

  final VoidCallback onGetStartedPressed;

  const LoginSplashPage({
    super.key,
    required this.onGetStartedPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 80.0, bottom: 40.0),
                child: Hero(
                  tag: "finamp_logo",
                  child: Image.asset(
                    'images/finamp_cropped.png',
                    width: 150,
                    height: 150,
                  ),
                ),
              ),
              RichText(
                text: TextSpan(
                  text: "Welcome to ",
                  style: Theme.of(context).textTheme.headlineMedium,
                  children: [
                    TextSpan(
                      text: "Finamp",
                      style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                            // color: Theme.of(context).colorScheme.secondary,
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 60,
              ),
              Text("Your music, the way you want it.",
                  style: Theme.of(context).textTheme.bodyLarge),
              const SizedBox(
                height: 80,
              ),
              CTALarge(
                text: "Get Started!",
                icon: TablerIcons.music,
                onPressed: onGetStartedPressed,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
