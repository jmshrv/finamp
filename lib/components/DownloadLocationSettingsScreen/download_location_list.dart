import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

import '../../models/finamp_models.dart';
import '../../services/finamp_settings_helper.dart';
import 'download_location_list_tile.dart';

class DownloadLocationList extends StatefulWidget {
  const DownloadLocationList({Key? key}) : super(key: key);

  @override
  State<DownloadLocationList> createState() => _DownloadLocationListState();
}

class _DownloadLocationListState extends State<DownloadLocationList> {
  late Iterable<DownloadLocation> downloadLocationsIterable;

  @override
  void initState() {
    super.initState();
    downloadLocationsIterable =
        FinampSettingsHelper.finampSettings.downloadLocationsMap.values;
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Box<FinampSettings>>(
      valueListenable: FinampSettingsHelper.finampSettingsListener,
      builder: (context, box, child) {
        return ListView.builder(
          itemCount: downloadLocationsIterable.length,
          itemBuilder: (context, index) {
            return DownloadLocationListTile(
              downloadLocation: downloadLocationsIterable.elementAt(index),
            );
          },
        );
      },
    );
  }
}
