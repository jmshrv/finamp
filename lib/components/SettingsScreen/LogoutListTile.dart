import 'package:flutter/material.dart';
import 'package:audio_service/audio_service.dart';
import 'package:get_it/get_it.dart';

import '../../services/JellyfinApiData.dart';
import '../errorSnackbar.dart';

class LogoutListTile extends StatelessWidget {
  const LogoutListTile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final jellyfinApiData = GetIt.instance<JellyfinApiData>();

    return ListTile(
      leading: Icon(
        Icons.logout,
        color: Colors.red,
      ),
      title: Text(
        "Log out",
        style: TextStyle(
          color: Colors.red,
        ),
      ),
      subtitle: Text("Downloaded songs will not be deleted",
          style:
              Theme.of(context).textTheme.caption?.copyWith(color: Colors.red)),
      onTap: () {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text("Are you sure?"),
            actions: [
              TextButton(
                child: Text("CANCEL"),
                onPressed: () => Navigator.of(context).pop(),
              ),
              TextButton(
                child: Text("OK"),
                onPressed: () async {
                  try {
                    // We don't want audio to be playing after we log out
                    await AudioService.stop();

                    await jellyfinApiData.logoutCurrentUser();
                    Navigator.of(context)
                        .pushNamedAndRemoveUntil("/", (route) => false);
                  } catch (e) {
                    errorSnackbar(e, context);
                    return;
                  }
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
