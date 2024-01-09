import 'package:finamp/components/LoginScreen/login_server_selection_page.dart';
import 'package:finamp/models/jellyfin_models.dart';
import 'package:finamp/services/jellyfin_api_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:get_it/get_it.dart';
import 'package:logging/logging.dart';

import 'login_authentication_page.dart';

class LoginUserSelectionPage extends StatelessWidget {

  static final _loginUserSelectionPageLogger = Logger("LoginUserSelectionPage");
  
  final jellyfinApiHelper = GetIt.instance<JellyfinApiHelper>();

  final PublicSystemInfoResult serverInfo;
  final String baseUrl;
  QuickConnectState? quickConnectState;

  LoginUserSelectionPage({
    super.key,
    required this.serverInfo,
    required this.baseUrl,
  });

  @override
  Widget build(BuildContext context) {

    jellyfinApiHelper.baseUrlTemp = Uri.parse(baseUrl);
    
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Image.asset(
                  'images/finamp.png',
                  width: 200,
                  height: 200,
                ),
                Text("Select your account", style: Theme.of(context).textTheme.headlineMedium, textAlign: TextAlign.center),
                const SizedBox(height: 40,),
                FutureBuilder<bool>(
                  future: jellyfinApiHelper.checkQuickConnect(),
                  builder: (context, snapshot) {
                    final quickConnectAvailable = snapshot.data ?? false;
                    if (snapshot.hasData && quickConnectAvailable) {
                      _loginUserSelectionPageLogger.info("Quick connect available, initiating...");
                      return FutureBuilder<QuickConnectState>(
                        future: jellyfinApiHelper.initiateQuickConnect(),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            quickConnectState = snapshot.data;
                            _loginUserSelectionPageLogger.info("Quick connect state: $quickConnectState");
                            return _buildJellyfinServerConnectionWidget(true);
                          } else {
                            return _buildJellyfinServerConnectionWidget(false);
                          }
                        },
                      );
                    } else {
                      _loginUserSelectionPageLogger.severe("Quick connect not available!");
                      return _buildJellyfinServerConnectionWidget(false);
                    }
                  },
                ),
                FutureBuilder(
                  future: jellyfinApiHelper.loadPublicUsers(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      final users = snapshot.data!.users;
                    
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 40.0),
                        child: Wrap(
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
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => LoginAuthenticationPage(
                                        user: user,
                                        quickConnectState: quickConnectState,
                                      ),
                                    ),
                                  );
                                },
                              ),
                            JellyfinUserWidget(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => LoginAuthenticationPage(
                                      user: null,
                                      quickConnectState: quickConnectState,
                                    ),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      );
                    } else {
                      return const CircularProgressIndicator();
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  JellyfinServerSelectionWidget _buildJellyfinServerConnectionWidget(bool connected) {
    return JellyfinServerSelectionWidget(
        baseUrl: jellyfinApiHelper.baseUrlTemp.toString(),
        serverInfo: serverInfo,
        connected: connected,
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
    final avatarUrl = user != null ? JellyfinApiHelper().getUserImageUrl(baseUrl: jellyfinApiHelper.baseUrlTemp!, user: user!)?.toString() : null;

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
              color: Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black,
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
            border: Border.all(color: Colors.white),
            borderRadius: BorderRadius.circular(16),
          ),
          child: const Icon(
            TablerIcons.plus,
            size: 50,
            color: Colors.white,
          ),
        );
      }
    }

    getUserNameText() {
      if (user != null) {
        return user!.name != null && user!.name!.isNotEmpty ? user!.name! : "Unnamed user";
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
              child: getUserImage()
            ),
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

    return onPressed != null ?
     ElevatedButton(
      style: ElevatedButton.styleFrom(
        foregroundColor: Theme.of(context).textTheme.bodyMedium!.color,
        surfaceTintColor: Colors.transparent,
        backgroundColor: Colors.transparent,
        shadowColor: Colors.transparent,
        padding: const EdgeInsets.all(0),
      ),
      onPressed: onPressed,
      child: buildContent(),
    ) :
    Container(
      child: buildContent(),
    );
  }
}
