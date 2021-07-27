import 'package:flutter/material.dart';

import '../../services/FinampSettingsHelper.dart';

class SongShuffleItemCountEditor extends StatefulWidget {
  const SongShuffleItemCountEditor({Key? key}) : super(key: key);

  @override
  _SongShuffleItemCountEditorState createState() =>
      _SongShuffleItemCountEditorState();
}

class _SongShuffleItemCountEditorState
    extends State<SongShuffleItemCountEditor> {
  final _controller = TextEditingController(
      text:
          FinampSettingsHelper.finampSettings.songShuffleItemCount.toString());

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text("Shuffle All Song Count"),
      subtitle: Text(
          "Amount of songs to load when using the shuffle all songs button."),
      trailing: SizedBox(
        width: 50 * MediaQuery.of(context).textScaleFactor,
        child: TextField(
          controller: _controller,
          textAlign: TextAlign.center,
          keyboardType: TextInputType.number,
          onChanged: (value) {
            final valueInt = int.tryParse(value);

            if (valueInt != null) {
              FinampSettingsHelper.setSongShuffleItemCount(valueInt);
            }
          },
        ),
      ),
    );
  }
}
