import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../services/finamp_settings_helper.dart';
import 'download_location_list_tile.dart';

class DownloadLocationList extends ConsumerWidget {
  const DownloadLocationList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // TODO make this not rebuild on every settings change
    var locations = ref.watch(finampSettingsProvider
        .select((x) => x.requireValue.downloadLocationsMap.values));
    return ListView.builder(
      itemCount: locations.length,
      itemBuilder: (context, index) {
        return DownloadLocationListTile(
          downloadLocation: locations.elementAt(index),
        );
      },
    );
  }
}
