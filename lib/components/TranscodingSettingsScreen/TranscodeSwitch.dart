import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

import '../../services/FinampSettingsHelper.dart';
import '../../models/FinampModels.dart';

class TranscodeSwitch extends StatelessWidget {
  const TranscodeSwitch({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Box<FinampSettings>>(
      valueListenable: FinampSettingsHelper.finampSettingsListener,
      builder: (context, box, child) {
        return SwitchListTile(
          title: Text("Enable Transcoding"),
          subtitle: Text(
              "If enabled, music streams will be transcoded by the server."),
          value: box.get("FinampSettings").shouldTranscode,
          onChanged: (value) {
            FinampSettings finampSettingsTemp = box.get("FinampSettings");
            finampSettingsTemp.shouldTranscode = value;
            box.put("FinampSettings", finampSettingsTemp);
          },
        );
      },
    );
  }
}
