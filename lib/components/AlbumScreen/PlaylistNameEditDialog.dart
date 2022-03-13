import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../../models/JellyfinModels.dart';
import '../../services/JellyfinApiData.dart';
import '../errorSnackbar.dart';

class PlaylistNameEditDialog extends StatefulWidget {
  const PlaylistNameEditDialog({
    Key? key,
    required this.playlist,
  }) : super(key: key);

  final BaseItemDto playlist;

  @override
  _PlaylistNameEditDialogState createState() => _PlaylistNameEditDialogState();
}

class _PlaylistNameEditDialogState extends State<PlaylistNameEditDialog> {
  String? _name;
  bool _isUpdating = false;

  final _jellyfinApiData = GetIt.instance<JellyfinApiData>();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _name = widget.playlist.name;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Edit Playlist Name"),
      content: Form(
        key: _formKey,
        child: TextFormField(
          initialValue: _name,
          decoration: const InputDecoration(labelText: "Name"),
          textInputAction: TextInputAction.done,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return "Required";
            }
            return null;
          },
          onFieldSubmitted: (_) async => await _submit(),
          onSaved: (newValue) => _name = newValue,
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text("CANCEL"),
        ),
        TextButton(
          onPressed: _isUpdating ? null : () async => await _submit(),
          child: const Text("UPDATE"),
        ),
      ],
    );
  }

  Future<void> _submit() async {
    if (_formKey.currentState != null && _formKey.currentState!.validate()) {
      setState(() {
        _isUpdating = true;
      });

      _formKey.currentState!.save();

      try {
        BaseItemDto playlistTemp = widget.playlist;
        playlistTemp.name = _name;
        await _jellyfinApiData.updateItem(
          itemId: widget.playlist.id,
          newItem: playlistTemp,
        );

        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Playlist name updated.")));
        Navigator.of(context).pop();
      } catch (e) {
        errorSnackbar(e, context);
        setState(() {
          _isUpdating = false;
        });
        return;
      }
    }
  }
}
