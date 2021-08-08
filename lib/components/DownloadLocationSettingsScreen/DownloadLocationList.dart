import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

import '../../models/FinampModels.dart';
import '../../services/FinampSettingsHelper.dart';
import 'DownloadLocationListTile.dart';

class DownloadLocationList extends StatelessWidget {
  const DownloadLocationList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Box<FinampSettings>>(
      valueListenable: FinampSettingsHelper.finampSettingsListener,
      builder: (context, box, child) {
        final List<DownloadLocation>? downloadLocations =
            box.get("FinampSettings")?.downloadLocations;

        if (downloadLocations == null) {
          return const Text("No download locations");
        } else {
          return ListView.builder(
            itemCount: downloadLocations.length,
            itemBuilder: (context, index) {
              return DownloadLocationListTile(
                downloadLocation: downloadLocations[index],
                index: index,
              );
            },
          );
        }
      },
    );
  }
}
