import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../../services/JellyfinApiData.dart';
import 'OfflineModeSwitchListTile.dart';
import 'ViewListTile.dart';

class MusicScreenDrawer extends StatelessWidget {
  const MusicScreenDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final jellyfinApiData = GetIt.instance<JellyfinApiData>();
    return Drawer(
      child: Scrollbar(
        child: CustomScrollView(
          slivers: [
            SliverList(
              delegate: SliverChildListDelegate.fixed(
                [
                  DrawerHeader(
                      child: Stack(
                    children: [
                      Align(
                        alignment: Alignment.topCenter,
                        child: CircleAvatar(
                          backgroundColor: Colors.transparent,
                          backgroundImage: AssetImage(
                            'images/finamp.png',
                          ),
                          radius: 50.0,
                        ),
                      ),
                      Align(
                          alignment: Alignment.bottomCenter - Alignment(0, 0.2),
                          child: Text(
                            'Finamp',
                            style: TextStyle(fontSize: 20),
                          )),
                    ],
                  )),
                  ListTile(
                    leading: Icon(Icons.file_download),
                    title: Text("Downloads"),
                    onTap: () => Navigator.of(context).pushNamed("/downloads"),
                  ),
                  OfflineModeSwitchListTile(),
                  Divider(),
                ],
              ),
            ),
            SliverList(
              delegate: SliverChildBuilderDelegate((context, index) {
                return ViewListTile(
                    view: jellyfinApiData.currentUser!.views.values
                        .elementAt(index));
              }, childCount: jellyfinApiData.currentUser!.views.length),
            ),
            SliverFillRemaining(
              hasScrollBody: false,
              child: SafeArea(
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Divider(),
                      ListTile(
                        leading: Icon(Icons.warning),
                        title: Text("Logs"),
                        onTap: () => Navigator.of(context).pushNamed("/logs"),
                      ),
                      ListTile(
                        leading: Icon(Icons.settings),
                        title: Text("Settings"),
                        onTap: () =>
                            Navigator.of(context).pushNamed("/settings"),
                      ),
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
