import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../../services/MusicPlayerBackgroundTask.dart';

import '../../services/FinampSettingsHelper.dart';

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
      title: const Text("Set Sleep Timer"),
      content: Form(
        key: _formKey,
        child: TextFormField(
          controller: _textController,
          keyboardType: TextInputType.number,
          textAlign: TextAlign.center,
          decoration: const InputDecoration(labelText: "Minutes"),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return "Required";
            }

            if (int.tryParse(value) == null) {
              return "Invalid Number";
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
          child: const Text("CANCEL"),
          onPressed: () => Navigator.of(context).pop(),
        ),
        TextButton(
          child: const Text("OK"),
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
