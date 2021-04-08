import 'package:flutter/material.dart';
import 'package:package_info/package_info.dart';

import 'OfflineModeSwitchListTile.dart';

class MusicScreenDrawer extends StatelessWidget {
  const MusicScreenDrawer({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          DrawerHeader(
            child: Align(
              alignment: Alignment.bottomLeft,
              child: Text(
                "Menu",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 64),
              ),
            ),
          ),
          ListTile(
            leading: Icon(Icons.file_download),
            title: Text("Downloads"),
            onTap: () => Navigator.of(context).pushNamed("/downloads"),
          ),
          ListTile(
            leading: Icon(Icons.error),
            title: Text("Logs"),
            onTap: () => Navigator.of(context).pushNamed("/logs"),
          ),
          OfflineModeSwitchListTile(),
          Expanded(
            child: Align(
              alignment: Alignment.bottomCenter,
              child: ListTile(
                leading: Icon(Icons.info),
                title: Text("About"),
                onTap: () async {
                  PackageInfo packageInfo = await PackageInfo.fromPlatform();

                  showAboutDialog(
                    context: context,
                    applicationName: packageInfo.appName,
                    applicationVersion: packageInfo.version,
                    applicationLegalese:
                        "Licensed with the Mozilla Public License 2.0. Source code available at:\n\ngithub.com/UnicornsOnLSD/finamp",
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
