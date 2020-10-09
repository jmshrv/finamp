import 'package:flutter/material.dart';

import '../printDuration.dart';

class ProgressSlider extends StatelessWidget {
  const ProgressSlider(
      {Key key, @required this.songProgress, @required this.songLength})
      : super(key: key);

  final int songProgress;
  final int songLength;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(printDuration(
          Duration(microseconds: (songProgress ~/ 10)),
        )),
        Expanded(
          child: Slider(
            value: songProgress.toDouble(),
            onChanged: (value) {},
            max: songLength.toDouble(),
          ),
        ),
        Text(printDuration(
          Duration(microseconds: (songLength ~/ 10)),
        )),
      ],
    );
  }
}
