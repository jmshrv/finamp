import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

import '../../models/FinampModels.dart';
import '../../services/FinampSettingsHelper.dart';

class ContentViewTypeDropdownListTile extends StatelessWidget {
  const ContentViewTypeDropdownListTile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Box<FinampSettings>>(
      valueListenable: FinampSettingsHelper.finampSettingsListener,
      builder: (_, box, __) {
        return ListTile(
          title: const Text("View Type"),
          subtitle: const Text("View type for the music screen."),
          trailing: DropdownButton<ContentViewType>(
            value: box.get("FinampSettings")?.contentViewType,
            items: ContentViewType.values
                .map((e) => DropdownMenuItem<ContentViewType>(
                      child: Text(e.humanReadableName),
                      value: e,
                    ))
                .toList(),
            onChanged: (value) {
              if (value != null) {
                FinampSettingsHelper.setContentViewType(value);
              }
            },
          ),
        );
      },
    );
  }
}
