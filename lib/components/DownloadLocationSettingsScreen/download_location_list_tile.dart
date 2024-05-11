import 'package:finamp/services/finamp_settings_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';

import '../../models/finamp_models.dart';
import 'download_location_delete_dialog.dart';

class DownloadLocationListTile extends ConsumerWidget {
  const DownloadLocationListTile({
    Key? key,
    required this.downloadLocation,
  }) : super(key: key);

  final DownloadLocation downloadLocation;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    bool isDefault = ref.watch(finampSettingsProvider.select((value) =>
        value.value?.defaultDownloadLocation == downloadLocation.id));

    return ListTile(
      title: Text(downloadLocation.name),
      subtitle: Text(
        downloadLocation.currentPath,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: Icon(isDefault ? Icons.star : Icons.star_outline),
            onPressed: () {
              FinampSettings finampSettingsTemp =
                  FinampSettingsHelper.finampSettings;
              finampSettingsTemp.defaultDownloadLocation =
                  isDefault ? null : downloadLocation.id;
              Hive.box<FinampSettings>("FinampSettings")
                  .put("FinampSettings", finampSettingsTemp);
            },
            tooltip:
                AppLocalizations.of(context)!.defaultDownloadLocationButton,
          ),
          if (downloadLocation.baseDirectory.needsPath)
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () => showDialog(
                context: context,
                builder: (context) => DownloadLocationDeleteDialog(
                  id: downloadLocation.id,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
