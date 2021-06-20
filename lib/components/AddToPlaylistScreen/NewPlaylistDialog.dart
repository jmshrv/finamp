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
  final _formKey = GlobalKey<FormState>();
  final _jellyfinApiData = GetIt.instance<JellyfinApiData>();

  bool _isSubmitting = false;

  String? _name;
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("New Playlist"),
      content: Form(
        key: _formKey,
        child: TextFormField(
          decoration: InputDecoration(labelText: "Name"),
          textInputAction: TextInputAction.done,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return "Required";
            }
          },
          onFieldSubmitted: (_) async => await _submit(),
          onSaved: (newValue) => _name = newValue,
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop<bool>(false),
          child: Text("CANCEL"),
        ),
        TextButton(
          onPressed: _isSubmitting ? null : () async => await _submit(),
          child: Text("CREATE"),
        ),
      ],
    );
  }

  Future<void> _submit() async {
    if (_formKey.currentState != null && _formKey.currentState!.validate()) {
      setState(() {
        _isSubmitting = true;
      });

      _formKey.currentState!.save();

      try {
        await _jellyfinApiData.createNewPlaylist(NewPlaylist(
          name: _name,
          ids: [widget.itemToAdd],
          userId: _jellyfinApiData.currentUser!.userDetails.user!.id,
        ));
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("Playlist created.")));
        Navigator.of(context).pop<bool>(true);
      } catch (e) {
        errorSnackbar(e, context);
        setState(() {
          _isSubmitting = false;
        });
        return;
      }
    }
  }
}
