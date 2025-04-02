import 'dart:io';

import 'package:flutter/material.dart';
import 'package:finamp/l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../components/TranscodingSettingsScreen/bitrate_selector.dart';
import '../components/TranscodingSettingsScreen/transcode_switch.dart';
import '../models/finamp_models.dart';
import '../services/finamp_settings_helper.dart';

class TranscodingSettingsScreen extends StatefulWidget {
  const TranscodingSettingsScreen({super.key});
  static const routeName = "/settings/transcoding";
  @override
  State<TranscodingSettingsScreen> createState() =>
      _TranscodingSettingsScreenState();
}

class _TranscodingSettingsScreenState extends State<TranscodingSettingsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.transcoding),
        actions: [
          FinampSettingsHelper.makeSettingsResetButtonWithDialog(
              context, FinampSettingsHelper.resetTranscodingSettings)
        ],
      ),
      body: ListView(
        children: [
          const TranscodeSwitch(),
          const BitrateSelector(),
          const StreamingTranscodeSegmentContainerDropdownListTile(),
          Padding(padding: const EdgeInsets.all(8.0)),
          const DownloadTranscodeEnableDropdownListTile(),
          const DownloadTranscodeCodecDropdownListTile(),
          const DownloadBitrateSelector(),
        ],
      ),
    );
  }
}

class DownloadBitrateSelector extends ConsumerWidget {
  const DownloadBitrateSelector({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final transcodeProfile =
        ref.watch(finampSettingsProvider.downloadTranscodingProfile);
    return Column(
      children: [
        ListTile(
          title: Text(AppLocalizations.of(context)!.downloadBitrate),
          subtitle: Text(AppLocalizations.of(context)!.downloadBitrateSubtitle),
        ),
        // We do all of this division/multiplication because Jellyfin wants us to specify bitrates in bits, not kilobits.
        Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Slider(
              min: 64,
              max: 320,
              value: (transcodeProfile.stereoBitrate / 1000).clamp(64, 320),
              divisions: 8,
              label: transcodeProfile.bitrateKbps,
              onChanged: (value) => FinampSetters.setDownloadTranscodeBitrate(
                  (value * 1000).toInt()),
            ),
            Text(
              transcodeProfile.bitrateKbps,
              style: Theme.of(context).textTheme.titleLarge,
            )
          ],
        )
      ],
    );
  }
}

class DownloadTranscodeEnableDropdownListTile extends ConsumerWidget {
  const DownloadTranscodeEnableDropdownListTile({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListTile(
      title: Text(AppLocalizations.of(context)!.downloadTranscodeEnableTitle),
      trailing: DropdownButton<TranscodeDownloadsSetting>(
        value: ref.watch(finampSettingsProvider.shouldTranscodeDownloads),
        items: TranscodeDownloadsSetting.values
            .map((e) => DropdownMenuItem<TranscodeDownloadsSetting>(
                  value: e,
                  child: Text(AppLocalizations.of(context)!
                      .downloadTranscodeEnableOption(e.name)),
                ))
            .toList(),
        onChanged: FinampSetters.setShouldTranscodeDownloads.ifNonNull,
      ),
    );
  }
}

class DownloadTranscodeCodecDropdownListTile extends ConsumerWidget {
  const DownloadTranscodeCodecDropdownListTile({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListTile(
      title: Text(AppLocalizations.of(context)!.downloadTranscodeCodecTitle),
      trailing: DropdownButton<FinampTranscodingCodec>(
        value:
            ref.watch(finampSettingsProvider.downloadTranscodingProfile).codec,
        items: FinampTranscodingCodec.values
            .where((element) => !Platform.isIOS || element.iosCompatible)
            .where((element) => element != FinampTranscodingCodec.original)
            .map((e) => DropdownMenuItem<FinampTranscodingCodec>(
                  value: e,
                  child: Text(e.name.toUpperCase()),
                ))
            .toList(),
        onChanged: FinampSetters.setDownloadTranscodingCodec,
      ),
    );
  }
}

class StreamingTranscodeSegmentContainerDropdownListTile
    extends ConsumerWidget {
  const StreamingTranscodeSegmentContainerDropdownListTile({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListTile(
      title: Text(
          AppLocalizations.of(context)!.transcodingStreamingContainerTitle),
      subtitle: Text(
          AppLocalizations.of(context)!.transcodingStreamingContainerSubtitle),
      trailing: DropdownButton<FinampSegmentContainer>(
        value: ref.watch(finampSettingsProvider.transcodingSegmentContainer),
        items: FinampSegmentContainer.values
            .map((e) => DropdownMenuItem<FinampSegmentContainer>(
                  value: e,
                  child: Text(e.container.toUpperCase()),
                ))
            .toList(),
        onChanged: FinampSetters.setTranscodingSegmentContainer.ifNonNull,
      ),
    );
  }
}
