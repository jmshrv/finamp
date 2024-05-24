import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../services/finamp_settings_helper.dart';

class PlayerScreenMinimumCoverPaddingEditor extends StatefulWidget {
  const PlayerScreenMinimumCoverPaddingEditor({Key? key}) : super(key: key);

  @override
  State<PlayerScreenMinimumCoverPaddingEditor> createState() =>
      _PlayerScreenMinimumCoverPaddingEditorState();
}

class _PlayerScreenMinimumCoverPaddingEditorState
    extends State<PlayerScreenMinimumCoverPaddingEditor> {
  final _controller = TextEditingController(
      text: FinampSettingsHelper.finampSettings.playerScreenCoverMinimumPadding
          .toString());

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(AppLocalizations.of(context)!
          .playerScreenMinimumCoverPaddingEditorTitle),
      subtitle: Text(AppLocalizations.of(context)!
          .playerScreenMinimumCoverPaddingEditorSubtitle),
      trailing: SizedBox(
        width: 50 * MediaQuery.of(context).textScaleFactor,
        child: TextField(
          controller: _controller,
          textAlign: TextAlign.center,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          onChanged: (value) {
            final valueDouble = double.tryParse(value);

            if (valueDouble != null) {
              FinampSettingsHelper.setPlayerScreenCoverMinimumPadding(
                  valueDouble);
            }
          },
        ),
      ),
    );
  }
}
