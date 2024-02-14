import 'package:finamp/components/Buttons/simple_button.dart';
import 'package:finamp/components/LoginScreen/login_flow.dart';
import 'package:finamp/screens/language_selection_screen.dart';
import 'package:finamp/screens/logs_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  static const routeName = "/login";

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        bottomSheetTheme: const BottomSheetThemeData(
          backgroundColor: Colors.transparent,
          surfaceTintColor: Colors.transparent
        ),
      ),
      child: const Scaffold(
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 32.0),
            child: LoginFlow(),
          ),
        ),
        bottomNavigationBar: _LoginAuxillaryOptions(),
      ),
    );
  }
}

class _LoginAuxillaryOptions extends StatelessWidget {
  const _LoginAuxillaryOptions({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20.0, right: 20.0, bottom: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SimpleButton(
            text: AppLocalizations.of(context)!.viewLogs,
            icon: TablerIcons.file_text,
            onPressed: () => Navigator.of(context).pushNamed(LogsScreen.routeName),
          ),
          SimpleButton(
            text: AppLocalizations.of(context)!.changeLanguage,
            icon: TablerIcons.language,
            onPressed: () => Navigator.of(context).pushNamed(LanguageSelectionScreen.routeName),
          ),
        ],
      ),
    );
  }
}
