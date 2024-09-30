import 'package:finamp/components/Buttons/cta_large.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
        padding: const EdgeInsets.symmetric(horizontal: 32.0),
        child: Center(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 80.0, bottom: 40.0),
                child: Hero(
                  tag: "finamp_logo",
                  child: SvgPicture.asset(
                    'images/finamp_cropped.svg',
                    width: 150,
                    height: 150,
                  ),
                ),
              ),
              RichText(
                text: TextSpan(
                  text:
                      "${AppLocalizations.of(context)!.loginFlowWelcomeHeading} ",
                  style: Theme.of(context).textTheme.headlineMedium,
                  children: [
                    TextSpan(
                      text: AppLocalizations.of(context)!.finamp,
                      style:
                          Theme.of(context).textTheme.headlineMedium!.copyWith(
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
              Text(AppLocalizations.of(context)!.loginFlowSlogan,
                  style: Theme.of(context).textTheme.bodyLarge),
              const SizedBox(
                height: 80,
              ),
              CTALarge(
                text: AppLocalizations.of(context)!.loginFlowGetStarted,
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
