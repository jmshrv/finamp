import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../services/finamp_settings_helper.dart';

class PeriodicPlaybackSessionUpdateFrequencyEditor extends StatefulWidget {
  const PeriodicPlaybackSessionUpdateFrequencyEditor({Key? key})
      : super(key: key);

  @override
  State<PeriodicPlaybackSessionUpdateFrequencyEditor> createState() =>
      _PeriodicPlaybackSessionUpdateFrequencyEditorState();
}

class _PeriodicPlaybackSessionUpdateFrequencyEditorState
    extends State<PeriodicPlaybackSessionUpdateFrequencyEditor> {
  final _controller = TextEditingController(
      text: FinampSettingsHelper
          .finampSettings.periodicPlaybackSessionUpdateFrequencySeconds
          .toString());

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
          AppLocalizations.of(context)!.periodicPlaybackSessionUpdateFrequency),
      subtitle: RichText(
        text: TextSpan(
          children: [
            TextSpan(
              text: AppLocalizations.of(context)!
                  .periodicPlaybackSessionUpdateFrequencySubtitle,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const TextSpan(text: "\n"),
            // tappable "more info" text
            TextSpan(
              text: AppLocalizations.of(context)!.moreInfo,
              style: TextStyle(
                color: Theme.of(context).colorScheme.secondary,
                fontWeight: FontWeight.w500,
              ),
              recognizer: TapGestureRecognizer()
                ..onTap = () {
                  showGeneralDialog(
                      context: context,
                      pageBuilder: (context, anim1, anim2) {
                        return AlertDialog(
                          title: Text(AppLocalizations.of(context)!
                              .periodicPlaybackSessionUpdateFrequency),
                          content: Text(AppLocalizations.of(context)!
                              .periodicPlaybackSessionUpdateFrequencyDetails),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: Text(AppLocalizations.of(context)!.close),
                            ),
                          ],
                        );
                      });
                },
            ),
          ],
        ),
      ),
      trailing: SizedBox(
        width: 50 * MediaQuery.of(context).textScaleFactor,
        child: TextField(
          controller: _controller,
          textAlign: TextAlign.center,
          keyboardType: TextInputType.number,
          onChanged: (value) {
            final valueInt = int.tryParse(value);

            if (valueInt != null) {
              FinampSettingsHelper
                  .setPeriodicPlaybackSessionUpdateFrequencySeconds(valueInt);
            }
          },
        ),
      ),
    );
  }
}
