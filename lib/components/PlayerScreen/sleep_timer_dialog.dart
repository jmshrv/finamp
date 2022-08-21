import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get_it/get_it.dart';

import '../../services/music_player_background_task.dart';

import '../../services/finamp_settings_helper.dart';

class SleepTimerDialog extends StatefulWidget {
  const SleepTimerDialog({Key? key}) : super(key: key);

  @override
  State<SleepTimerDialog> createState() => _SleepTimerDialogState();
}

class _SleepTimerDialogState extends State<SleepTimerDialog> {
  final _audioHandler = GetIt.instance<MusicPlayerBackgroundTask>();

  final _textController = TextEditingController(
      text: (FinampSettingsHelper.finampSettings.sleepTimerSeconds ~/ 60)
          .toString());

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(AppLocalizations.of(context)!.setSleepTimer),
      content: Form(
        key: _formKey,
        child: TextFormField(
          controller: _textController,
          keyboardType: TextInputType.number,
          textAlign: TextAlign.center,
          decoration: InputDecoration(
              labelText: AppLocalizations.of(context)!.setSleepTimer),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return AppLocalizations.of(context)!.required;
            }

            if (int.tryParse(value) == null) {
              return AppLocalizations.of(context)!.invalidNumber;
            }
            return null;
          },
          onSaved: (value) {
            final valueInt = int.parse(value!);

            _audioHandler.setSleepTimer(Duration(minutes: valueInt));
            FinampSettingsHelper.setSleepTimerSeconds(valueInt * 60);
          },
        ),
      ),
      actions: [
        TextButton(
          child: Text(MaterialLocalizations.of(context).cancelButtonLabel),
          onPressed: () => Navigator.of(context).pop(),
        ),
        TextButton(
          child: Text(MaterialLocalizations.of(context).okButtonLabel),
          onPressed: () {
            if (_formKey.currentState?.validate() == true) {
              _formKey.currentState!.save();
              Navigator.of(context).pop();
            }
          },
        )
      ],
    );
  }
}
