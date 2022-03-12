import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

import '../../services/FinampSettingsHelper.dart';
import '../../models/FinampModels.dart';

class VorbisSwitch extends StatelessWidget {
  const VorbisSwitch({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Box<FinampSettings>>(
      valueListenable: FinampSettingsHelper.finampSettingsListener,
      builder: (context, box, child) {
        bool? useVorbis = box.get("FinampSettings")?.useVorbis;

        return SwitchListTile(
          title: const Text("Use Vorbis Codec"),
          subtitle: const Text(
              "If enabled, music streams will be transcoded to Vorbis and not AAC by the server."),
          value: useVorbis ?? false,
          onChanged: useVorbis == null
              ? null
              : (value) {
                  FinampSettings finampSettingsTemp =
                      box.get("FinampSettings")!;
                  finampSettingsTemp.useVorbis = value;
                  box.put("FinampSettings", finampSettingsTemp);
                },
        );
      },
    );
  }
}
