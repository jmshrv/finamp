import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get_it/get_it.dart';

import '../../models/jellyfin_models.dart';
import '../../services/jellyfin_api_helper.dart';
import '../global_snackbar.dart';

class PlaylistNameEditDialog extends StatefulWidget {
  const PlaylistNameEditDialog({
    super.key,
    required this.playlist,
  });

  final BaseItemDto playlist;

  @override
  State<PlaylistNameEditDialog> createState() => _PlaylistNameEditDialogState();
}

class _PlaylistNameEditDialogState extends State<PlaylistNameEditDialog> {
  String? _name;
  bool _isUpdating = false;

  final _jellyfinApiHelper = GetIt.instance<JellyfinApiHelper>();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _name = widget.playlist.name;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(AppLocalizations.of(context)!.editPlaylistNameTitle),
      content: Form(
        key: _formKey,
        child: TextFormField(
          initialValue: _name,
          decoration:
              InputDecoration(labelText: AppLocalizations.of(context)!.name),
          textInputAction: TextInputAction.done,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return AppLocalizations.of(context)!.required;
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
          child: Text(MaterialLocalizations.of(context).cancelButtonLabel),
        ),
        TextButton(
          onPressed: _isUpdating ? null : () async => await _submit(),
          child: Text(AppLocalizations.of(context)!.updateButtonLabel),
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
        await _jellyfinApiHelper.updateItem(
          itemId: widget.playlist.id,
          newItem: playlistTemp,
        );

        if (!mounted) return;

        GlobalSnackbar.message(
          (context) => AppLocalizations.of(context)!.playlistNameUpdated,
          isConfirmation: true,
        );
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
