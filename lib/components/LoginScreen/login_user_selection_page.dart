import 'package:finamp/components/LoginScreen/login_server_selection_page.dart';
import 'package:finamp/models/jellyfin_models.dart';
import 'package:finamp/services/jellyfin_api_helper.dart';
import 'package:flutter/material.dart' hide ConnectionState;
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:get_it/get_it.dart';
import 'package:logging/logging.dart';

import 'login_flow.dart';

class LoginUserSelectionPage extends StatelessWidget {
  static const routeName = "login/user-selection";
  static final _loginUserSelectionPageLogger = Logger("LoginUserSelectionPage");

  final jellyfinApiHelper = GetIt.instance<JellyfinApiHelper>();

  final ServerState serverState;
  final ConnectionState connectionState;
  final void Function(UserDto?) onUserSelected;

  LoginUserSelectionPage({
    super.key,
    required this.serverState,
    required this.connectionState,
    required this.onUserSelected,
  });

  @override
  Widget build(BuildContext context) {
    jellyfinApiHelper.baseUrlTemp = Uri.parse(serverState.baseUrl!);

    print("key: ${serverState.selectedServer!.id!}");

    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Image.asset(
                'images/finamp.png',
                width: 150,
                height: 150,
              ),
              Text("Select your account",
                  style: Theme.of(context).textTheme.headlineMedium,
                  textAlign: TextAlign.center),
              const SizedBox(
                height: 20,
              ),
              FutureBuilder<bool>(
                future: jellyfinApiHelper.checkQuickConnect(),
                builder: (context, snapshot) {
                  final quickConnectAvailable = snapshot.data ?? false;
                  if (snapshot.hasData && quickConnectAvailable) {
                    _loginUserSelectionPageLogger
                        .info("Quick connect available, initiating...");
                    return FutureBuilder<QuickConnectState>(
                      future: jellyfinApiHelper.initiateQuickConnect(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          connectionState.quickConnectState = snapshot.data;
                          connectionState.isConnected = true;
                          _loginUserSelectionPageLogger.info(
                              "Quick connect state: ${connectionState.quickConnectState.toString()}");
                          return _buildJellyfinServerConnectionWidget();
                        } else {
                          connectionState.isConnected = false;
                          return _buildJellyfinServerConnectionWidget();
                        }
                      },
                    );
                  } else {
                    _loginUserSelectionPageLogger
                        .severe("Quick connect not available!");
                    connectionState.isConnected = true;
                    return _buildJellyfinServerConnectionWidget();
                  }
                },
              ),
              const SizedBox(
                height: 20,
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
                              onUserSelected(user);
                            },
                          ),
                        JellyfinUserWidget(
                          onPressed: () {
                            onUserSelected(null);
                          },
                        ),
                      ],
                    );
                  } else {
                    return JellyfinUserWidget(
                      onPressed: () {
                        onUserSelected(null);
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
      serverInfo: serverState.selectedServer,
      connected: connectionState.isConnected,
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

    const double avatarSize = 80.0;

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
            : "Unnamed user";
      } else {
        return "Custom User";
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
