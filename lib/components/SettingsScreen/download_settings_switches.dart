import 'package:flutter/material.dart';

class DownloadSettingsSwitches extends StatefulWidget {
  const DownloadSettingsSwitches({Key? key}) : super(key: key);

  @override
  State<DownloadSettingsSwitches> createState() =>
      _DownloadSettingsSwitchesState();
}

class _DownloadSettingsSwitchesState extends State<DownloadSettingsSwitches> {
  bool onlyDownloadWithWifi = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SwitchListTile(
            value: onlyDownloadWithWifi,
            onChanged: (bool value) {
              setState((){
                onlyDownloadWithWifi = value;
              });
              // TODO: Save in Database
            })
      ],
    );
  }
}
