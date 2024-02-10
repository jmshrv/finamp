import 'dart:io';

import 'package:finamp/components/global_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get_it/get_it.dart';
import 'package:hive/hive.dart';

import '../components/TranscodingSettingsScreen/bitrate_selector.dart';
import '../components/TranscodingSettingsScreen/transcode_switch.dart';
import '../models/finamp_models.dart';
import '../services/finamp_settings_helper.dart';
import '../services/isar_downloads.dart';

class TranscodingSettingsScreen extends StatelessWidget {
  const TranscodingSettingsScreen({super.key});

  static const routeName = "/settings/transcoding";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.transcoding),
      ),
      body: Scrollbar(
        child: ListView(
          children: [
            const TranscodeSwitch(),
            const BitrateSelector(),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                AppLocalizations.of(context)!.jellyfinUsesAACForTranscoding,
                style: Theme.of(context).textTheme.bodySmall,
                textAlign: TextAlign.center,
              ),
            ),
            const DownloadTranscodeEnableDropdownListTile(),
            const DownloadTranscodeCodecDropdownListTile(),
            const DownloadBitrateSelector(),
            ListTile(
              title: Text(AppLocalizations.of(context)!.redownloadTitle),
              subtitle: Text(AppLocalizations.of(context)!.redownloadSubtitle),
              trailing: IconButton(
                onPressed: () async {
                  final isarDownloader = GetIt.instance<IsarDownloads>();
                  await isarDownloader
                      .deleteSongsWithOutdatedDownloadSettings();
                  await isarDownloader.resyncAll();
                  GlobalSnackbar.message((scaffold) =>
                      AppLocalizations.of(scaffold)!.redownloadcomplete);
                },
                icon: const Icon(Icons.downloading),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class DownloadBitrateSelector extends StatelessWidget {
  const DownloadBitrateSelector({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          title: Text(AppLocalizations.of(context)!.downloadBitrate),
          subtitle: Text(AppLocalizations.of(context)!.downloadBitrateSubtitle),
        ),
        ValueListenableBuilder<Box<FinampSettings>>(
          valueListenable: FinampSettingsHelper.finampSettingsListener,
          builder: (context, box, child) {
            final finampSettings = box.get("FinampSettings")!;

            // We do all of this division/multiplication because Jellyfin wants us to specify bitrates in bits, not kilobits.
            return Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Slider(
                  min: 64,
                  max: 320,
                  value:
                      finampSettings.downloadTranscodingProfile.stereoBitrate /
                          1000,
                  divisions: 8,
                  label: finampSettings.downloadTranscodingProfile.bitrateKbps,
                  onChanged: (value) {
                    FinampSettings finampSettingsTemp = finampSettings;
                    finampSettingsTemp.downloadTranscodeBitrate =
                        (value * 1000).toInt();
                    Hive.box<FinampSettings>("FinampSettings")
                        .put("FinampSettings", finampSettingsTemp);
                  },
                ),
                Text(
                  finampSettings.downloadTranscodingProfile.bitrateKbps,
                  style: Theme.of(context).textTheme.titleLarge,
                )
              ],
            );
          },
        ),
      ],
    );
  }
}

class DownloadTranscodeEnableDropdownListTile extends StatelessWidget {
  const DownloadTranscodeEnableDropdownListTile({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Box<FinampSettings>>(
      valueListenable: FinampSettingsHelper.finampSettingsListener,
      builder: (_, box, __) {
        final finampSettings = box.get("FinampSettings")!;

        return ListTile(
          title:
              Text(AppLocalizations.of(context)!.downloadTranscodeEnableTitle),
          trailing: DropdownButton<TranscodeDownloadsSetting>(
            value: finampSettings.shouldTranscodeDownloads,
            items: TranscodeDownloadsSetting.values
                .map((e) => DropdownMenuItem<TranscodeDownloadsSetting>(
                      value: e,
                      child: Text(AppLocalizations.of(context)!
                          .downloadTranscodeEnableOption(e.name)),
                    ))
                .toList(),
            onChanged: (value) {
              if (value != null) {
                FinampSettings finampSettingsTemp = finampSettings;
                finampSettingsTemp.shouldTranscodeDownloads = value;
                Hive.box<FinampSettings>("FinampSettings")
                    .put("FinampSettings", finampSettingsTemp);
              }
            },
          ),
        );
      },
    );
  }
}

class DownloadTranscodeCodecDropdownListTile extends StatelessWidget {
  const DownloadTranscodeCodecDropdownListTile({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Box<FinampSettings>>(
      valueListenable: FinampSettingsHelper.finampSettingsListener,
      builder: (_, box, __) {
        final finampSettings = box.get("FinampSettings")!;

        return ListTile(
          title:
              Text(AppLocalizations.of(context)!.downloadTranscodeCodecTitle),
          subtitle: Text("AAC does not work until jellyfin 10.9"),
          trailing: DropdownButton<FinampTranscodingCodec>(
            value: finampSettings.downloadTranscodingProfile.codec,
            items: FinampTranscodingCodec.values
                .where((element) => !Platform.isIOS || element.iosCompatible)
                .map((e) => DropdownMenuItem<FinampTranscodingCodec>(
                      value: e,
                      child: Text(e.name.toUpperCase()),
                    ))
                .toList(),
            onChanged: (value) {
              if (value != null) {
                FinampSettings finampSettingsTemp = finampSettings;
                finampSettingsTemp.downloadTranscodingCodec = value;
                Hive.box<FinampSettings>("FinampSettings")
                    .put("FinampSettings", finampSettingsTemp);
              }
            },
          ),
        );
      },
    );
  }
}
