import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../../services/JellyfinApiData.dart';
import '../../services/MusicPlayerBackgroundTask.dart';
import '../errorSnackbar.dart';

class LogoutListTile extends StatelessWidget {
  const LogoutListTile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const Icon(
        Icons.logout,
        color: Colors.red,
      ),
      title: const Text(
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
            title: const Text("Are you sure?"),
            actions: [
              TextButton(
                child: const Text("CANCEL"),
                onPressed: () => Navigator.of(context).pop(),
              ),
              TextButton(
                child: const Text("OK"),
                onPressed: () async {
                  try {
                    final _audioHandler =
                        GetIt.instance<MusicPlayerBackgroundTask>();

                    // We don't want audio to be playing after we log out.
                    // We check if the audio service is running on iOS because
                    // stop() never completes if the service is not running.
                    if (_audioHandler.playbackState.valueOrNull?.playing ==
                        true) {
                      await _audioHandler.stop();
                    }

                    final jellyfinApiData = GetIt.instance<JellyfinApiData>();

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
