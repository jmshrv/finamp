import 'package:finamp/components/Buttons/cta_medium.dart';
import 'package:finamp/components/LoginScreen/login_user_selection_page.dart';
import 'package:finamp/components/error_snackbar.dart';
import 'package:finamp/models/jellyfin_models.dart';
import 'package:finamp/screens/music_screen.dart';
import 'package:finamp/screens/view_selector.dart';
import 'package:finamp/services/jellyfin_api_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:get_it/get_it.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class LoginAuthenticationPage extends StatefulWidget {
  final UserDto? user;
  QuickConnectState? quickConnectState;

  LoginAuthenticationPage({
    super.key,
    required this.user,
    this.quickConnectState,
  });

  @override
  State<LoginAuthenticationPage> createState() =>
      _LoginAuthenticationPageState();
}

class _LoginAuthenticationPageState extends State<LoginAuthenticationPage> {
  final jellyfinApiHelper = GetIt.instance<JellyfinApiHelper>();

  bool isAuthenticating = false;

  String? username;
  String? password;
  String? authToken;
  PublicSystemInfoResult? serverInfo;

  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    if (widget.user != null) {
      username = widget.user?.name;
      print(username);
    }

    if (widget.quickConnectState != null) {
      waitForQuickConnect();
    }
  }

  void waitForQuickConnect() async {
    await Future.doWhile(() async {
      await Future.delayed(const Duration(seconds: 1));
      final quickConnectState = await jellyfinApiHelper.updateQuickConnect(widget.quickConnectState!);
      widget.quickConnectState = quickConnectState;
      print("quick connect: ${quickConnectState?.authenticated ?? false}");
      return !(quickConnectState?.authenticated ?? false);
    });
    await jellyfinApiHelper.authenticateWithQuickConnect(widget.quickConnectState!);

    if (!mounted) return;
      Navigator.of(context).pushNamed(ViewSelector.routeName);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              children: [
                Image.asset(
                  'images/finamp.png',
                  width: 200,
                  height: 200,
                ),
                Text("Log in to your account",
                    style: Theme.of(context).textTheme.headlineMedium,
                    textAlign: TextAlign.center),
                const SizedBox(
                  height: 40,
                ),
                JellyfinUserWidget(
                  user: widget.user,
                ),
                Column(
                  children: [
                    Text("Use Quick Connect Code"),
                    Text(
                      widget.quickConnectState?.code ?? "",
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
                  child: _buildLoginForm(context),
                ),
                CTAMedium(
                  text: "Log in",
                  icon: TablerIcons.login_2,
                  onPressed: () async => await sendForm(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Form _buildLoginForm(BuildContext context) {
    // This variable is for handling shifting focus when the user presses submit.
    // https://stackoverflow.com/questions/52150677/how-to-shift-focus-to-next-textfield-in-flutter
    final node = FocusScope.of(context);

    InputDecoration inputFieldDecoration(String placeholder) {
      return InputDecoration(
        filled: true,
        fillColor: Theme.of(context).colorScheme.surfaceVariant,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
        label: Text(placeholder),
        floatingLabelBehavior: FloatingLabelBehavior.never,
        border: OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: BorderRadius.circular(16),
        ),
      );
    }

    return Form(
      key: formKey,
      child: AutofillGroup(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
              child: Text(AppLocalizations.of(context)!.username, textAlign: TextAlign.start,)
            ),
            TextFormField(
              autocorrect: false,
              keyboardType: TextInputType.visiblePassword,
              autofillHints: const [AutofillHints.username],
              decoration: inputFieldDecoration("Enter your username"),
              textInputAction: TextInputAction.next,
              onEditingComplete: () => node.nextFocus(),
              initialValue: username,
              onSaved: (newValue) => username = newValue,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
              child: Text(AppLocalizations.of(context)!.password, textAlign: TextAlign.start,)
            ),
            TextFormField(
              autocorrect: false,
              obscureText: true,
              keyboardType: TextInputType.visiblePassword,
              autofillHints: const [AutofillHints.password],
              decoration: inputFieldDecoration("Enter your password"),
              textInputAction: TextInputAction.done,
              onFieldSubmitted: (_) async => await sendForm(),
              onSaved: (newValue) => password = newValue,
            ),
          ],
        ),
      ),
    );
  }

  /// Function to handle logging in for Widgets, including a snackbar for errors.
  Future<void> loginHelper(
      {required String username,
      String? password,
      required BuildContext context}) async {
    JellyfinApiHelper jellyfinApiHelper = GetIt.instance<JellyfinApiHelper>();

    try {
      if (password == null) {
        await jellyfinApiHelper.authenticateViaName(username: username);
      } else {
        await jellyfinApiHelper.authenticateViaName(
          username: username,
          password: password,
        );
      }

      if (!mounted) return;

      Navigator.of(context).pushNamed(ViewSelector.routeName);
    } catch (e) {
      errorSnackbar(e, context);

      // We return here to stop the function from continuing.
      return;
    }
  }

  Future<void> sendForm() async {
    if (formKey.currentState?.validate() == true) {
      formKey.currentState!.save();
      setState(() {
        isAuthenticating = true;
      });
      await loginHelper(
        username: username!,
        password: password,
        context: context,
      );
      setState(() {
        isAuthenticating = false;
      });
    }
  }
}
