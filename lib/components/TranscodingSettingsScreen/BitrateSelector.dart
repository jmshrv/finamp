import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

import '../../services/FinampSettingsHelper.dart';
import '../../models/FinampModels.dart';

class BitrateSelector extends StatelessWidget {
  const BitrateSelector({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          title: Text("Bitrate"),
          subtitle: Text(
            "A higher bitrate gives higher quality audio at the cost of higher bandwidth.",
          ),
        ),
        ValueListenableBuilder<Box<FinampSettings>>(
          valueListenable: FinampSettingsHelper.finampSettingsListener,
          builder: (context, box, child) {
            FinampSettings finampSettings = box.get("FinampSettings");
            // We do all of this division/multiplication because Jellyfin wants us to specify bitrates in bits, not kilobits.
            return Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Slider(
                  min: 64,
                  max: 320,
                  value: finampSettings.transcodeBitrate / 1000,
                  divisions: 8,
                  label: "${finampSettings.transcodeBitrate ~/ 1000}kbps",
                  onChanged: (value) {
                    FinampSettings finampSettingsTemp =
                        box.get("FinampSettings");
                    finampSettingsTemp.transcodeBitrate =
                        (value * 1000).toInt();
                    box.put("FinampSettings", finampSettingsTemp);
                  },
                ),
                Text(
                  "${finampSettings.transcodeBitrate ~/ 1000}kbps",
                  style: Theme.of(context).textTheme.headline6,
                )
              ],
            );
          },
        ),
      ],
    );
  }
}
