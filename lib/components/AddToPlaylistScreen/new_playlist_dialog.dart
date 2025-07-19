import 'dart:async';

import 'package:finamp/models/finamp_models.dart';
import 'package:finamp/models/jellyfin_models.dart';
import 'package:finamp/services/downloads_service.dart';
import 'package:flutter/material.dart';
import 'package:finamp/l10n/app_localizations.dart';
import 'package:get_it/get_it.dart';

import '../../services/finamp_user_helper.dart';
import '../../services/jellyfin_api_helper.dart';
import '../global_snackbar.dart';

class NewPlaylistDialog extends StatefulWidget {
  const NewPlaylistDialog({super.key, required this.itemsToAdd, this.initialName});

  final List<BaseItemId> itemsToAdd;
  final String? initialName;

  @override
  State<NewPlaylistDialog> createState() => _NewPlaylistDialogState();
}

class _NewPlaylistDialogState extends State<NewPlaylistDialog> {
  final _formKey = GlobalKey<FormState>();
  final _jellyfinApiHelper = GetIt.instance<JellyfinApiHelper>();
  final _finampUserHelper = GetIt.instance<FinampUserHelper>();

  bool _isSubmitting = false;

  String? _name;
  bool? _public;
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(AppLocalizations.of(context)!.newPlaylist),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              decoration: InputDecoration(labelText: AppLocalizations.of(context)!.name),
              textInputAction: TextInputAction.done,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return AppLocalizations.of(context)!.required;
                }
                return null;
              },
              initialValue: widget.initialName,
              onFieldSubmitted: (_) async => await _submit(),
              onSaved: (newValue) => _name = newValue,
            ),
            FormField<bool>(
              builder: (state) {
                return CheckboxListTile(
                  value: state.value,
                  title: Text(AppLocalizations.of(context)!.publiclyVisiblePlaylist, textAlign: TextAlign.end),
                  onChanged: state.didChange,
                  contentPadding: EdgeInsets.zero,
                );
              },
              initialValue: true,
              onSaved: (newValue) => _public = newValue,
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop<(Future<BaseItemId>, String?)?>(null),
          child: Text(MaterialLocalizations.of(context).cancelButtonLabel),
        ),
        TextButton(
          onPressed: () async => await _submit(),
          child: Text(AppLocalizations.of(context)!.createButtonLabel),
        ),
      ],
    );
  }

  Future<void> _submit() async {
    if (_isSubmitting) return;
    if (_formKey.currentState != null && _formKey.currentState!.validate()) {
      _isSubmitting = true;
      _formKey.currentState!.save();

      Navigator.of(context).pop<(Future<BaseItemId>, String?)?>((
        Future.sync(() async {
          var newId = await _jellyfinApiHelper.createNewPlaylist(
            NewPlaylist(
              name: _name,
              ids: widget.itemsToAdd,
              userId: _finampUserHelper.currentUser!.id,
              isPublic: _public,
            ),
          );

          GlobalSnackbar.message((scaffold) => AppLocalizations.of(scaffold)!.playlistCreated, isConfirmation: true);

          // resync all playlists, so the new playlist automatically gets downloaded if all playlists should be downloaded

          final downloadsService = GetIt.instance<DownloadsService>();
          unawaited(
            downloadsService.resync(
              DownloadStub.fromFinampCollection(FinampCollection(type: FinampCollectionType.allPlaylists)),
              null,
              keepSlow: true,
            ),
          );
          return newId.id!;
        }),
        _name,
      ));
    }
  }
}
