import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

import '../../services/FinampSettingsHelper.dart';
import '../../models/FinampModels.dart';

class TranscodeSwitch extends StatelessWidget {
  const TranscodeSwitch({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Box<FinampSettings>>(
      valueListenable: FinampSettingsHelper.finampSettingsListener,
      builder: (context, box, child) {
        bool? shouldTranscode = box.get("FinampSettings")?.shouldTranscode;

        return SwitchListTile(
          title: const Text("Enable Transcoding"),
          subtitle: const Text(
              "If enabled, music streams will be transcoded by the server."),
          value: shouldTranscode ?? false,
          onChanged: shouldTranscode == null
              ? null
              : (value) {
                  FinampSettings finampSettingsTemp =
                      box.get("FinampSettings")!;
                  finampSettingsTemp.shouldTranscode = value;
                  box.put("FinampSettings", finampSettingsTemp);
                },
        );
      },
    );
  }
}
