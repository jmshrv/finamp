import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../services/finamp_settings_helper.dart';

class BufferDurationListTile extends StatefulWidget {
  const BufferDurationListTile({super.key});

  @override
  State<BufferDurationListTile> createState() => _BufferDurationListTileState();
}

class _BufferDurationListTileState extends State<BufferDurationListTile> {
  final _controller = TextEditingController(
      text:
          FinampSettingsHelper.finampSettings.bufferDurationSeconds.toString());

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(AppLocalizations.of(context)!.bufferDuration),
      subtitle: Text(AppLocalizations.of(context)!.bufferDurationSubtitle),
      trailing: SizedBox(
        width: 50 * MediaQuery.of(context).textScaleFactor,
        child: TextField(
          controller: _controller,
          textAlign: TextAlign.center,
          keyboardType: TextInputType.number,
          onChanged: (value) {
            final valueInt = int.tryParse(value);

            if (valueInt != null && !valueInt.isNegative) {
              FinampSettingsHelper.setBufferDuration(
                  Duration(seconds: valueInt));
            }
          },
        ),
      ),
    );
  }
}
