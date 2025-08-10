import 'package:finamp/builders/annotations.dart';
import 'package:finamp/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../services/finamp_settings_helper.dart';

part "track_shuffle_item_count_editor.g.dart";

@Searchable()
class TrackShuffleItemCountEditor extends ConsumerStatefulWidget {
  const TrackShuffleItemCountEditor({super.key});

  @override
  ConsumerState<TrackShuffleItemCountEditor> createState() => _TrackShuffleItemCountEditorState();
}

class _TrackShuffleItemCountEditorState extends ConsumerState<TrackShuffleItemCountEditor> {
  final _controller = TextEditingController();

  @override
  void initState() {
    ref.listenManual(finampSettingsProvider.trackShuffleItemCount, (_, value) {
      var newText = value.toString();
      if (_controller.text != newText) _controller.text = newText;
    }, fireImmediately: true);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(AppLocalizations.of(context)!.shuffleAllTrackCount),
      subtitle: Text(AppLocalizations.of(context)!.shuffleAllTrackCountSubtitle),
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
