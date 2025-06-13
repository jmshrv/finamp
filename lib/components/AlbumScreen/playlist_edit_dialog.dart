import 'package:finamp/models/finamp_models.dart';
import 'package:finamp/services/finamp_user_helper.dart';
import 'package:flutter/material.dart';
import 'package:finamp/l10n/app_localizations.dart';
import 'package:get_it/get_it.dart';

import '../../models/jellyfin_models.dart';
import '../../services/jellyfin_api_helper.dart';
import '../global_snackbar.dart';

class PlaylistEditDialog extends StatefulWidget {
  const PlaylistEditDialog({
    super.key,
    required this.playlist,
  });

  final BaseItemDto playlist;

  @override
  State<PlaylistEditDialog> createState() => _PlaylistEditDialogState();
}

class _PlaylistEditDialogState extends State<PlaylistEditDialog> {
  String? _name;
  BaseItemId? _id;
  bool? _publicVisibility;
  bool _isUpdating = false;

  final _jellyfinApiHelper = GetIt.instance<JellyfinApiHelper>();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _name = widget.playlist.name;
    _id = widget.playlist.id;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(AppLocalizations.of(context)!
          .editItemTitle(BaseItemDtoType.fromItem(widget.playlist).name)),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        spacing: 8,
        children: [
          Form(
            key: _formKey,
            child: TextFormField(
              initialValue: _name,
              decoration: InputDecoration(
                  labelText: AppLocalizations.of(context)!.name),
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
          FormField<bool>(builder: (state) {
            _fetchPublicVisibility();
            return CheckboxListTile(
                value: _publicVisibility ?? false,
                title: Text(
                  AppLocalizations.of(context)!.publiclyVisiblePlaylist,
                  textAlign: TextAlign.left,
                ),
                contentPadding: EdgeInsets.zero,
                onChanged: (value) {
                  state.didChange(value);
                  setState(() {
                    _publicVisibility = value!;
                  });
                });
          }),
        ],
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

  Future<void> _fetchPublicVisibility() async {
    if (_publicVisibility != null) return;
    final resultPlaylist =
        await _jellyfinApiHelper.getPlaylist(widget.playlist.id!);
    setState(() {
      _publicVisibility = resultPlaylist['OpenAccess'] as bool;
    });
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
        await _jellyfinApiHelper.updatePlaylist(
            newPlaylist: NewPlaylist(
                isPublic: _publicVisibility,
                userId: GetIt.instance<FinampUserHelper>().currentUserId,
                ids: null,
                name: _name),
            itemId: widget.playlist.id);

        if (!mounted) return;

        GlobalSnackbar.message(
          (context) => AppLocalizations.of(context)!.playlistUpdated,
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
