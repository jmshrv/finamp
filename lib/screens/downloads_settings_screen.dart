import 'dart:io';
import 'dart:math';

import 'package:finamp/components/AlbumScreen/download_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
import 'package:hive/hive.dart';

import '../components/global_snackbar.dart';
import '../models/finamp_models.dart';
import '../services/downloads_service.dart';
import '../services/finamp_settings_helper.dart';
import 'downloads_location_screen.dart';

class DownloadsSettingsScreen extends StatelessWidget {
  const DownloadsSettingsScreen({super.key});

  static const routeName = "/settings/downloads";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.downloadSettings),
      ),
      body: ListView(
        children: [
          ListTile(
            leading: const Icon(Icons.folder),
            title: Text(AppLocalizations.of(context)!.downloadLocations),
            onTap: () => Navigator.of(context)
                .pushNamed(DownloadsLocationScreen.routeName),
          ),
          if (Platform.isIOS || Platform.isAndroid) const RequireWifiSwitch(),
          const ShowPlaylistSongsSwitch(),
          // Do not limit enqueued downloads on IOS, it throttles them like crazy on its own.
          if (!Platform.isIOS) const ConcurentDownloadsSelector(),
          ListTile(
            // TODO real UI for this
            title: const Text("Download all favorites"),
            trailing: DownloadButton(
                item: DownloadStub.fromId(
                    id: "Favorites",
                    type: DownloadItemType.finampCollection,
                    name: AppLocalizations.of(context)!
                        .finampCollectionNames("favorites"))),
          ),
          ListTile(
            // TODO real UI for this
            title: const Text("Download all playlists"),
            trailing: DownloadButton(
                item: DownloadStub.fromId(
                    id: "All Playlists",
                    type: DownloadItemType.finampCollection,
                    name: AppLocalizations.of(context)!
                        .finampCollectionNames("allPlaylists"))),
          ),
          ListTile(
            // TODO real UI for this
            title: const Text("Download 5 latest albums"),
            subtitle: const Text(
                "Downloads will be removed as they age out.  Lock the download to prevent an album from being removed."),
            trailing: DownloadButton(
                item: DownloadStub.fromId(
                    id: "5 Latest Albums",
                    type: DownloadItemType.finampCollection,
                    name: AppLocalizations.of(context)!
                        .finampCollectionNames("fiveLatestAlbums"))),
          ),
          const SyncOnStartupSwitch(),
          const PreferQuickSyncsSwitch(),
          const DownloadWorkersSelector(),
          const RedownloadTranscodesSwitch(),
        ],
      ),
    );
  }
}

class RequireWifiSwitch extends StatelessWidget {
  const RequireWifiSwitch({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Box<FinampSettings>>(
      valueListenable: FinampSettingsHelper.finampSettingsListener,
      builder: (context, box, child) {
        bool? requireWifi = box.get("FinampSettings")?.requireWifiForDownloads;

        return SwitchListTile.adaptive(
          title: Text(AppLocalizations.of(context)!.requireWifiForDownloads),
          value: requireWifi ?? false,
          onChanged: requireWifi == null
              ? null
              : (value) {
                  FinampSettings finampSettingsTemp =
                      box.get("FinampSettings")!;
                  finampSettingsTemp.requireWifiForDownloads = value;
                  box.put("FinampSettings", finampSettingsTemp);
                },
        );
      },
    );
  }
}

class ShowPlaylistSongsSwitch extends StatelessWidget {
  const ShowPlaylistSongsSwitch({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Box<FinampSettings>>(
      valueListenable: FinampSettingsHelper.finampSettingsListener,
      builder: (context, box, child) {
        bool? showUnknownItems =
            box.get("FinampSettings")?.showDownloadsWithUnknownLibrary;

        return SwitchListTile.adaptive(
          title: Text(AppLocalizations.of(context)!.showPlaylistSongs),
          subtitle:
              Text(AppLocalizations.of(context)!.showPlaylistSongsSubtitle),
          value: showUnknownItems ?? true,
          onChanged: showUnknownItems == null
              ? null
              : (value) {
                  FinampSettings finampSettingsTemp =
                      box.get("FinampSettings")!;
                  finampSettingsTemp.showDownloadsWithUnknownLibrary = value;
                  box.put("FinampSettings", finampSettingsTemp);
                },
        );
      },
    );
  }
}

class SyncOnStartupSwitch extends StatelessWidget {
  const SyncOnStartupSwitch({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Box<FinampSettings>>(
      valueListenable: FinampSettingsHelper.finampSettingsListener,
      builder: (context, box, child) {
        bool? syncOnStartup = box.get("FinampSettings")?.resyncOnStartup;

        return SwitchListTile.adaptive(
          title: Text(AppLocalizations.of(context)!.syncOnStartupSwitch),
          value: syncOnStartup ?? true,
          onChanged: syncOnStartup == null
              ? null
              : (value) {
                  FinampSettings finampSettingsTemp =
                      box.get("FinampSettings")!;
                  finampSettingsTemp.resyncOnStartup = value;
                  box.put("FinampSettings", finampSettingsTemp);
                },
        );
      },
    );
  }
}

class PreferQuickSyncsSwitch extends StatelessWidget {
  const PreferQuickSyncsSwitch({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Box<FinampSettings>>(
      valueListenable: FinampSettingsHelper.finampSettingsListener,
      builder: (context, box, child) {
        bool? preferQuicksyncs = box.get("FinampSettings")?.preferQuickSyncs;

        return SwitchListTile.adaptive(
          title: Text(AppLocalizations.of(context)!.preferQuickSyncSwitch),
          subtitle:
              Text(AppLocalizations.of(context)!.preferQuickSyncSwitchSubtitle),
          value: preferQuicksyncs ?? true,
          onChanged: preferQuicksyncs == null
              ? null
              : (value) {
                  FinampSettings finampSettingsTemp =
                      box.get("FinampSettings")!;
                  finampSettingsTemp.preferQuickSyncs = value;
                  box.put("FinampSettings", finampSettingsTemp);
                },
        );
      },
    );
  }
}

class ConcurentDownloadsSelector extends StatelessWidget {
  const ConcurentDownloadsSelector({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          title: Text(AppLocalizations.of(context)!.maxConcurrentDownloads),
          subtitle: Text(
              AppLocalizations.of(context)!.maxConcurrentDownloadsSubtitle),
        ),
        ValueListenableBuilder<Box<FinampSettings>>(
          valueListenable: FinampSettingsHelper.finampSettingsListener,
          builder: (context, box, child) {
            final finampSettings = box.get("FinampSettings")!;

            return Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Slider(
                  min: 1,
                  max: 100,
                  value: finampSettings.maxConcurrentDownloads.toDouble(),
                  label: AppLocalizations.of(context)!
                      .maxConcurrentDownloadsLabel(
                          finampSettings.maxConcurrentDownloads.toString()),
                  onChanged: (value) {
                    FinampSettings finampSettingsTemp =
                        box.get("FinampSettings")!;
                    finampSettingsTemp.maxConcurrentDownloads = value.toInt();
                    box.put("FinampSettings", finampSettingsTemp);
                  },
                ),
                Text(
                  AppLocalizations.of(context)!.maxConcurrentDownloadsLabel(
                      finampSettings.maxConcurrentDownloads.toString()),
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

class DownloadWorkersSelector extends StatelessWidget {
  const DownloadWorkersSelector({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          title: Text(AppLocalizations.of(context)!.downloadsWorkersSetting),
          subtitle: Text(
              AppLocalizations.of(context)!.downloadsWorkersSettingSubtitle),
        ),
        ValueListenableBuilder<Box<FinampSettings>>(
          valueListenable: FinampSettingsHelper.finampSettingsListener,
          builder: (context, box, child) {
            final finampSettings = box.get("FinampSettings")!;

            return Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Slider(
                  min: 1,
                  max: 10,
                  value: min(finampSettings.downloadWorkers.toDouble(), 10),
                  label: AppLocalizations.of(context)!
                      .downloadsWorkersSettingLabel(
                          finampSettings.downloadWorkers.toString()),
                  onChanged: (value) {
                    FinampSettings finampSettingsTemp =
                        box.get("FinampSettings")!;
                    finampSettingsTemp.downloadWorkers = value.toInt();
                    box.put("FinampSettings", finampSettingsTemp);
                  },
                ),
                Text(
                  AppLocalizations.of(context)!.downloadsWorkersSettingLabel(
                      finampSettings.downloadWorkers.toString()),
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

class RedownloadTranscodesSwitch extends ConsumerWidget {
  const RedownloadTranscodesSwitch({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    bool? redownloadTranscodes = ref.watch(FinampSettingsHelper
        .finampSettingsProvider
        .select((value) => value.valueOrNull?.shouldRedownloadTranscodes));

    return SwitchListTile.adaptive(
      title: Text(AppLocalizations.of(context)!.redownloadTitle),
      subtitle: Text(AppLocalizations.of(context)!.redownloadSubtitle),
      value: redownloadTranscodes ?? true,
      onChanged: redownloadTranscodes == null
          ? null
          : (value) async {
              FinampSettings finampSettingsTemp =
                  FinampSettingsHelper.finampSettings;
              finampSettingsTemp.shouldRedownloadTranscodes = value;
              await Hive.box<FinampSettings>("FinampSettings")
                  .put("FinampSettings", finampSettingsTemp);

              if (value) {
                final isarDownloader = GetIt.instance<DownloadsService>();
                isarDownloader.markOutdatedTranscodes();
                await isarDownloader.resyncAll();
                GlobalSnackbar.message((scaffold) =>
                    AppLocalizations.of(scaffold)!.redownloadcomplete);
              }
            },
    );
  }
}
