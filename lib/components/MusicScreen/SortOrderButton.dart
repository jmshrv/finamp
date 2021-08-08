import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

import '../../models/JellyfinModels.dart';
import '../../models/FinampModels.dart';
import '../../services/FinampSettingsHelper.dart';

class SortOrderButton extends StatelessWidget {
  const SortOrderButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Box<FinampSettings>>(
      valueListenable: FinampSettingsHelper.finampSettingsListener,
      builder: (context, box, _) {
        final finampSettings = box.get("FinampSettings");

        return IconButton(
          tooltip: "Sort order",
          icon: finampSettings!.sortOrder == SortOrder.ascending
              ? const Icon(Icons.arrow_downward)
              : const Icon(Icons.arrow_upward),
          onPressed: () {
            if (finampSettings.sortOrder == SortOrder.ascending) {
              FinampSettingsHelper.setSortOrder(SortOrder.descending);
            } else {
              FinampSettingsHelper.setSortOrder(SortOrder.ascending);
            }
          },
        );
      },
    );
  }
}
