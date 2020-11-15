import 'package:flutter/material.dart';

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
            leading: Icon(
              Icons.music_note,
            ),
            title: Text("Music"),
            onTap: () => Navigator.of(context).pushReplacementNamed("/music"),
          ),
          ListTile(
            leading: Icon(Icons.file_download),
            title: Text("Downloads"),
            onTap: () => Navigator.of(context).pushNamed("/downloads"),
          ),
          ListTile(
            leading: Icon(Icons.settings),
            title: Text("Settings"),
            onTap: () {},
          )
        ],
      ),
    );
  }
}
