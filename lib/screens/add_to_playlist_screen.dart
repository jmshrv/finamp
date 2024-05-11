import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../components/AddToPlaylistScreen/add_to_playlist_list.dart';
import '../components/AddToPlaylistScreen/new_playlist_dialog.dart';

class AddToPlaylistScreen extends StatefulWidget {
  const AddToPlaylistScreen({Key? key}) : super(key: key);

  static const routeName = "/music/addtoplaylist";

  @override
  State<AddToPlaylistScreen> createState() => _AddToPlaylistScreenState();
}

class _AddToPlaylistScreenState extends State<AddToPlaylistScreen> {
  @override
  Widget build(BuildContext context) {
    final itemId = ModalRoute.of(context)!.settings.arguments as String;

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.addToPlaylistTitle),
      ),
      body: CustomScrollView(
        slivers: [
          AddToPlaylistList(
            itemToAddId: itemId,
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () async {
          // The dialog returns true if a playlist is created. If this is the
          // case, we also pop this page. It will return false if the user
          // cancels the dialog.
          final result = await showDialog<bool>(
            context: context,
            builder: (context) => NewPlaylistDialog(itemToAdd: itemId),
          );

          if (!mounted) return;

          if (result == true) {
            Navigator.of(context).pop();
          }
        },
      ),
    );
  }
}
