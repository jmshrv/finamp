import 'package:flutter/material.dart';

import 'OfflineModeSwitchListTile.dart';

class MusicScreenDrawer extends StatelessWidget {
  const MusicScreenDrawer({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
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
          OfflineModeSwitchListTile()
        ],
      ),
    );
  }
}
