import 'package:finamp/components/Buttons/simple_button.dart';
import 'package:finamp/components/LoginScreen/login_server_selection_page.dart';
import 'package:finamp/models/jellyfin_models.dart';
import 'package:finamp/services/jellyfin_api_helper.dart';
import 'package:flutter/material.dart' hide ConnectionState;
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:get_it/get_it.dart';
import 'package:logging/logging.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'login_flow.dart';

final _quickConnectLogger = Logger("QuickConnect");

class LoginUserSelectionPage extends StatefulWidget {
  static const routeName = "login/user-selection";
  static final _loginUserSelectionPageLogger = Logger("LoginUserSelectionPage");

  final ServerState serverState;
  final ConnectionState connectionState;
  final void Function(UserDto?) onUserSelected;
  final void Function()? onAuthenticated;

  LoginUserSelectionPage({
    super.key,
    required this.serverState,
    required this.connectionState,
    required this.onUserSelected,
    required this.onAuthenticated,
  });

  @override
  State<LoginUserSelectionPage> createState() => _LoginUserSelectionPageState();
}

class _LoginUserSelectionPageState extends State<LoginUserSelectionPage> {
  final jellyfinApiHelper = GetIt.instance<JellyfinApiHelper>();

  void waitForQuickConnect() async {
    await Future.doWhile(() async {
      await Future.delayed(const Duration(seconds: 1));
      final quickConnectState = await jellyfinApiHelper
          .updateQuickConnect(widget.connectionState!.quickConnectState!);
      widget.connectionState!.quickConnectState = quickConnectState;
      _quickConnectLogger
          .fine("Quick connect state: ${quickConnectState.toString()}");
      return !(quickConnectState?.authenticated ?? false) && mounted;
    });
    await jellyfinApiHelper.authenticateWithQuickConnect(
        widget.connectionState!.quickConnectState!);

    if (!mounted) return;
    widget.onAuthenticated?.call();
  }

  @override
  Widget build(BuildContext context) {
    jellyfinApiHelper.baseUrlTemp = Uri.parse(widget.serverState.baseUrl!);

    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 32.0, bottom: 20.0),
                child: Image.asset(
                  'images/finamp_cropped.png',
                  width: 75,
                  height: 75,
                ),
              ),
              Text(AppLocalizations.of(context)!.loginFlowAccountSelectionHeading,
                  style: Theme.of(context).textTheme.headlineMedium,
                  textAlign: TextAlign.center),
              Padding(
                padding: const EdgeInsets.only(top: 12.0, bottom: 12.0),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: SimpleButton(
                    icon: TablerIcons.chevron_left,
                    text: AppLocalizations.of(context)!.backToServerSelection,
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ),
              ),
              FutureBuilder<bool>(
                future: jellyfinApiHelper.checkQuickConnect(),
                builder: (context, snapshot) {
                  final quickConnectAvailable = snapshot.data ?? false;
                  if (snapshot.hasData && quickConnectAvailable) {
                    _quickConnectLogger
                        .info("Quick connect available, initiating...");
                    widget.connectionState.quickConnectState = null;
                    return FutureBuilder<QuickConnectState>(
                      future: jellyfinApiHelper.initiateQuickConnect(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          widget.connectionState.quickConnectState = snapshot.data;
                          widget.connectionState.isConnected = true;
                          _quickConnectLogger.info(
                              "Quick connect state: ${widget.connectionState.quickConnectState.toString()}");
                          waitForQuickConnect();
                          _quickConnectLogger.info("Waiting for quick connect...");
                          return QuickConnectSection(
                            connectionState: widget.connectionState,
                            onAuthenticated: widget.onAuthenticated,
                          );
                        } else {
                          widget.connectionState.isConnected = false;
                          return QuickConnectSection(connectionState: widget.connectionState, onAuthenticated: widget.onAuthenticated);
                        }
                      },
                    );
                  } else {
                    _quickConnectLogger
                        .severe("Quick connect not available!");
                    widget.connectionState.quickConnectState = null;
                    widget.connectionState.isConnected = true;
                    return Padding(
                      padding: const EdgeInsets.only(top: 16.0, bottom: 12.0),
                      child: Text(
                        AppLocalizations.of(context)!.loginFlowQuickConnectDisabled,
                        textAlign: TextAlign.center,
                      ),
                    );
                  }
                },
              ),
              Padding(
                padding: const EdgeInsets.only(left: 8.0, right: 8.0, top: 0, bottom: 8.0),
                child: Text(
                  AppLocalizations.of(context)!.loginFlowSelectAUser,
                  textAlign: TextAlign.center,
                ),
              ),
              FutureBuilder(
                future: jellyfinApiHelper.loadPublicUsers(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    final users = snapshot.data!.users;
        
                    return Wrap(
                      alignment: WrapAlignment.center,
                      crossAxisAlignment: WrapCrossAlignment.start,
                      direction: Axis.horizontal,
                      spacing: 10.0,
                      runSpacing: 12.0,
                      children: [
                        for (var user in users)
                          JellyfinUserWidget(
                            user: user,
                            onPressed: () {
                              widget.onUserSelected(user);
                            },
                          ),
                        JellyfinUserWidget(
                          onPressed: () {
                            widget.onUserSelected(null);
                          },
                        ),
                      ],
                    );
                  } else {
                    return JellyfinUserWidget(
                      onPressed: () {
                        widget.onUserSelected(null);
                      },
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  JellyfinServerSelectionWidget _buildJellyfinServerConnectionWidget() {
    return JellyfinServerSelectionWidget(
      baseUrl: jellyfinApiHelper.baseUrlTemp.toString(),
      serverInfo: widget.serverState.selectedServer,
      connected: widget.connectionState.isConnected,
    );
  }
}

class QuickConnectSection extends StatelessWidget {
  const QuickConnectSection({
    super.key,
    required this.connectionState,
    required this.onAuthenticated,
  });

  final ConnectionState connectionState;
  final void Function()? onAuthenticated;

  @override
  Widget build(BuildContext context) {
    return connectionState!.quickConnectState != null ?
      Column(
        children: [
          Text(
            AppLocalizations.of(context)!.loginFlowQuickConnectPrompt,
            textAlign: TextAlign.center,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 4.0),
            child: Text(
              connectionState!.quickConnectState?.code ?? "",
              style: Theme.of(context).textTheme.displaySmall!.copyWith(
                    fontFamily: "monospace",
                    letterSpacing: 5.0,
                  ),
              semanticsLabel: connectionState!.quickConnectState?.code?.split("").join(" "),
              textAlign: TextAlign.center,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Text(
              AppLocalizations.of(context)!
                  .loginFlowQuickConnectInstructions,
              style: Theme.of(context).textTheme.bodySmall!.copyWith(
                fontWeight: FontWeight.w300,
                color: Theme.of(context).textTheme.bodySmall!.color!.withOpacity(0.9),
              ),
              textAlign: TextAlign.center,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
            child: Text(
              "- ${AppLocalizations.of(context)!.orDivider} -",
              style: Theme.of(context).textTheme.bodyLarge,
              textAlign: TextAlign.center,
            ),
          )
        ],
      ) :
      Padding(
        padding: const EdgeInsets.only(top: 16.0, bottom: 12.0),
        child: Text(
          AppLocalizations.of(context)!.loginFlowQuickConnectDisabled,
          textAlign: TextAlign.center,
        ),
      );
  }
}

class JellyfinUserWidget extends StatelessWidget {
  final jellyfinApiHelper = GetIt.instance<JellyfinApiHelper>();
  final UserDto? user;
  final VoidCallback? onPressed;

  JellyfinUserWidget({
    Key? key,
    this.user,
    this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final avatarUrl = user != null
        ? JellyfinApiHelper()
            .getUserImageUrl(
                baseUrl: jellyfinApiHelper.baseUrlTemp!, user: user!)
            ?.toString()
        : null;

    const double avatarSize = 72.0;

    getUserImage() {
      if (user != null) {
        if (avatarUrl != null) {
          return Image.network(
            avatarUrl,
            width: avatarSize,
            height: avatarSize,
          );
        } else {
          return Container(
            decoration: BoxDecoration(
              color: Theme.of(context).brightness == Brightness.dark
                  ? Colors.white
                  : Colors.black,
            ),
            child: Image.asset(
              'images/finamp.png',
              width: avatarSize,
              height: avatarSize,
            ),
          );
        }
      } else {
        return Container(
          width: avatarSize,
          height: avatarSize,
          decoration: BoxDecoration(
            border: Border.all(
                color: Theme.of(context).textTheme.bodyMedium!.color!,
                width: Theme.of(context).brightness == Brightness.dark ? 1 : 2),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Icon(
            TablerIcons.plus,
            size: 50,
            color: Theme.of(context).textTheme.bodyMedium!.color!,
          ),
        );
      }
    }

    getUserNameText() {
      if (user != null) {
        return user!.name != null && user!.name!.isNotEmpty
            ? user!.name!
            : AppLocalizations.of(context)!.loginFlowNamelessUser;
      } else {
        return AppLocalizations.of(context)!.loginFlowCustomUser;
      }
    }

    buildContent() {
      return SizedBox(
        width: 96,
        child: Column(
          children: [
            Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                ),
                clipBehavior: Clip.antiAlias,
                child: getUserImage()),
            const SizedBox(height: 4),
            Text(
              getUserNameText(),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            )
          ],
        ),
      );
    }

    return onPressed != null
        ? ElevatedButton(
            style: ElevatedButton.styleFrom(
              foregroundColor: Theme.of(context).textTheme.bodyMedium!.color,
              surfaceTintColor: Colors.transparent,
              backgroundColor: Colors.transparent,
              shadowColor: Colors.transparent,
              padding: const EdgeInsets.all(0),
            ),
            onPressed: onPressed,
            child: buildContent(),
          )
        : Container(
            child: buildContent(),
          );
  }
}
