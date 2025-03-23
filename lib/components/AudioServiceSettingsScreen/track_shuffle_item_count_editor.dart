import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../services/finamp_settings_helper.dart';

class TrackShuffleItemCountEditor extends StatefulWidget {
  const TrackShuffleItemCountEditor({super.key});

  @override
  State<TrackShuffleItemCountEditor> createState() =>
      _TrackShuffleItemCountEditorState();
}

class _TrackShuffleItemCountEditorState
    extends State<TrackShuffleItemCountEditor> {
  final _controller = TextEditingController(
      text:
          FinampSettingsHelper.finampSettings.trackShuffleItemCount.toString());

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(AppLocalizations.of(context)!.shuffleAllTrackCount),
      subtitle:
          Text(AppLocalizations.of(context)!.shuffleAllTrackCountSubtitle),
      trailing: SizedBox(
        width: 50 * MediaQuery.of(context).textScaleFactor,
        child: TextField(
          controller: _controller,
          textAlign: TextAlign.center,
          keyboardType: TextInputType.number,
          onChanged: (value) {
            final valueInt = int.tryParse(value);

            if (valueInt != null) {
              FinampSetters.setTrackShuffleItemCount(valueInt);
            }
          },
        ),
      ),
    );
  }
}
