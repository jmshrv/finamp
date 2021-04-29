import 'package:flutter/material.dart';

import 'OfflineModeSwitchListTile.dart';

class MusicScreenDrawer extends StatelessWidget {
  const MusicScreenDrawer({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Scrollbar(
        child: CustomScrollView(
          slivers: [
            SliverList(
              delegate: SliverChildListDelegate.fixed(
                [
                  DrawerHeader(
                    child: Align(
                      alignment: Alignment.bottomLeft,
                      child: Text(
                        "Menu",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 64),
                      ),
                    ),
                  ),
                  ListTile(
                    leading: Icon(Icons.file_download),
                    title: Text("Downloads"),
                    onTap: () => Navigator.of(context).pushNamed("/downloads"),
                  ),
                  OfflineModeSwitchListTile(),
                ],
              ),
            ),
            SliverFillRemaining(
              hasScrollBody: false,
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ListTile(
                      leading: Icon(Icons.warning),
                      title: Text("Logs"),
                      onTap: () => Navigator.of(context).pushNamed("/logs"),
                    ),
                    ListTile(
                      leading: Icon(Icons.settings),
                      title: Text("Settings"),
                      onTap: () => Navigator.of(context).pushNamed("/settings"),
                    ),
                  ],
                ),
              ),
            )
          ],
          // Expanded(
          //     child: Align(
          //       alignment: Alignment.bottomCenter,
          //       child: Column(
          //         mainAxisSize: MainAxisSize.min,
          //         children: [
          //           ListTile(
          //             leading: Icon(Icons.warning),
          //             title: Text("Logs"),
          //             onTap: () => Navigator.of(context).pushNamed("/logs"),
          //           ),
          //           ListTile(
          //             leading: Icon(Icons.settings),
          //             title: Text("Settings"),
          //             onTap: () => Navigator.of(context).pushNamed("/settings"),
          //           ),
          //         ],
          //       ),
          //     ),
          //   ),
        ),
      ),
    );
  }
}
