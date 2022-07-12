import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

import '../../services/finamp_settings_helper.dart';
import '../../models/finamp_models.dart';

class BitrateSelector extends StatelessWidget {
  const BitrateSelector({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const ListTile(
          title: Text("Bitrate"),
          subtitle: Text(
            "A higher bitrate gives higher quality audio at the cost of higher bandwidth.",
          ),
        ),
        ValueListenableBuilder<Box<FinampSettings>>(
          valueListenable: FinampSettingsHelper.finampSettingsListener,
          builder: (context, box, child) {
            FinampSettings? finampSettings = box.get("FinampSettings");
            // We do all of this division/multiplication because Jellyfin wants us to specify bitrates in bits, not kilobits.
            if (finampSettings == null) {
              return const Text(
                  "Failed to get Finamp settings. Try restarting the app. If that doesn't work, wipe your app data. This really shouldn't happen.");
            }
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
                    FinampSettingsHelper.setTranscodeBitrate(
                        (value * 1000).toInt());
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
