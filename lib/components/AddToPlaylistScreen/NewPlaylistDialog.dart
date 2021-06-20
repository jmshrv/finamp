import 'package:finamp/models/JellyfinModels.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../../services/JellyfinApiData.dart';
import '../../services/FinampSettingsHelper.dart';
import '../errorSnackbar.dart';

class NewPlaylistDialog extends StatefulWidget {
  const NewPlaylistDialog({
    Key? key,
    required this.itemToAdd,
  }) : super(key: key);

  final String itemToAdd;

  @override
  _NewPlaylistDialogState createState() => _NewPlaylistDialogState();
}

class _NewPlaylistDialogState extends State<NewPlaylistDialog> {
  final formKey = GlobalKey<FormState>();
  final jellyfinApiData = GetIt.instance<JellyfinApiData>();

  bool isSubmitting = false;

  String? name;
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("New Playlist"),
      content: Form(
        key: formKey,
        child: TextFormField(
          decoration: InputDecoration(labelText: "Name"),
          textInputAction: TextInputAction.done,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return "Required";
            }
          },
          onFieldSubmitted: (_) async => await submit(),
          onSaved: (newValue) => name = newValue,
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: Text("CANCEL"),
        ),
        TextButton(
          onPressed: isSubmitting ? null : () async => await submit(),
          child: Text("CREATE"),
        ),
      ],
    );
  }

  Future<void> submit() async {
    if (formKey.currentState != null && formKey.currentState!.validate()) {
      setState(() {
        isSubmitting = true;
      });

      formKey.currentState!.save();

      try {
        await jellyfinApiData.createNewPlaylist(NewPlaylist(
          name: name,
          ids: [widget.itemToAdd],
          userId: jellyfinApiData.currentUser!.userDetails.user!.id,
        ));
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("Playlist created.")));
        Navigator.of(context).pop<bool>(true);
      } catch (e) {
        errorSnackbar(e, context);
        setState(() {
          isSubmitting = false;
        });
        return;
      }
    }
  }
}
