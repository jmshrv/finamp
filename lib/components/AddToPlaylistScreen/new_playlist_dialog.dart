import 'dart:async';

import 'package:finamp/models/finamp_models.dart';
import 'package:finamp/models/jellyfin_models.dart';
import 'package:finamp/services/downloads_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get_it/get_it.dart';

import '../../services/finamp_user_helper.dart';
import '../../services/jellyfin_api_helper.dart';
import '../global_snackbar.dart';

class NewPlaylistDialog extends StatefulWidget {
  const NewPlaylistDialog({
    super.key,
    required this.itemToAdd,
  });

  final String itemToAdd;

  @override
  State<NewPlaylistDialog> createState() => _NewPlaylistDialogState();
}

class _NewPlaylistDialogState extends State<NewPlaylistDialog> {
  final _formKey = GlobalKey<FormState>();
  final _jellyfinApiHelper = GetIt.instance<JellyfinApiHelper>();
  final _finampUserHelper = GetIt.instance<FinampUserHelper>();

  bool _isSubmitting = false;

  String? _name;
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(AppLocalizations.of(context)!.newPlaylist),
      content: Form(
        key: _formKey,
        child: TextFormField(
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
          onPressed: () =>
              Navigator.of(context).pop<(Future<String>, String?)?>(null),
          child: Text(MaterialLocalizations.of(context).cancelButtonLabel),
        ),
        TextButton(
          onPressed: _isSubmitting ? null : () async => await _submit(),
          child: Text(AppLocalizations.of(context)!.createButtonLabel),
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

      Navigator.of(context).pop<(Future<String>, String?)?>((
        Future.sync(() async {
          var newId = await _jellyfinApiHelper.createNewPlaylist(NewPlaylist(
            name: _name,
            ids: [widget.itemToAdd],
            userId: _finampUserHelper.currentUser!.id,
          ));

          GlobalSnackbar.message(
            (scaffold) => AppLocalizations.of(scaffold)!.playlistCreated,
            isConfirmation: true,
          );

          // resync all playlists, so the new playlist automatically gets downloaded if all playlists should be downloaded

          final downloadsService = GetIt.instance<DownloadsService>();
          unawaited(downloadsService.resync(
              DownloadStub.fromFinampCollection(
                  FinampCollection(type: FinampCollectionType.allPlaylists)),
              null,
              keepSlow: true));
          return newId.id!;
        }),
        _name
      ));
    }
  }
}
