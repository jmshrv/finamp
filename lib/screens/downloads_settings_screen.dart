import 'dart:io';

import 'package:finamp/components/AlbumScreen/download_button.dart';
import 'package:finamp/services/finamp_user_helper.dart';
import 'package:flutter/material.dart';
import 'package:finamp/l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
import 'package:hive_ce/hive.dart';

import '../components/global_snackbar.dart';
import '../models/finamp_models.dart';
import '../services/downloads_service.dart';
import '../services/finamp_settings_helper.dart';
import 'downloads_location_screen.dart';

class DownloadsSettingsScreen extends StatefulWidget {
  const DownloadsSettingsScreen({super.key});
  static const routeName = "/settings/downloads";
  @override
  State<DownloadsSettingsScreen> createState() =>
      _DownloadsSettingsScreenState();
}

class _DownloadsSettingsScreenState extends State<DownloadsSettingsScreen> {
  @override
  Widget build(BuildContext context) {
    var userHelper = GetIt.instance<FinampUserHelper>();
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.downloadSettings),
        actions: [
          FinampSettingsHelper.makeSettingsResetButtonWithDialog(
              context, FinampSettingsHelper.resetDownloadSettings)
        ],
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
          const SyncFavoritesSwitch(),
          ListTile(
            // TODO real UI for this
            title: Text(AppLocalizations.of(context)!.allPlaylistsInfoSetting),
            subtitle: Text(
                AppLocalizations.of(context)!.allPlaylistsInfoSettingSubtitle),
            trailing: DownloadButton(
                item: DownloadStub.fromFinampCollection(FinampCollection(
                    type: FinampCollectionType.allPlaylistsMetadata))),
          ),
          ListTile(
            // TODO real UI for this
            title:
                Text(AppLocalizations.of(context)!.cacheLibraryImagesSettings),
            subtitle: Text(AppLocalizations.of(context)!
                .cacheLibraryImagesSettingsSubtitle),
            trailing: DownloadButton(
                item: DownloadStub.fromFinampCollection(FinampCollection(
                    type: FinampCollectionType.libraryImages,
                    library: userHelper.currentUser!.currentView!))),
          ),
          ListTile(
            // TODO real UI for this
            title: Text(AppLocalizations.of(context)!.downloadFavoritesSetting),
            trailing: DownloadButton(
                item: DownloadStub.fromFinampCollection(
                    FinampCollection(type: FinampCollectionType.favorites))),
          ),
          ListTile(
            // TODO real UI for this
            title:
                Text(AppLocalizations.of(context)!.downloadAllPlaylistsSetting),
            trailing: DownloadButton(
                item: DownloadStub.fromFinampCollection(
                    FinampCollection(type: FinampCollectionType.allPlaylists))),
          ),
          ListTile(
            // TODO real UI for this
            title: Text(AppLocalizations.of(context)!.fiveLatestAlbumsSetting),
            subtitle: Text(
                AppLocalizations.of(context)!.fiveLatestAlbumsSettingSubtitle),
            trailing: DownloadButton(
                item: DownloadStub.fromFinampCollection(FinampCollection(
                    type: FinampCollectionType.latest5Albums))),
          ),
          const SyncOnStartupSwitch(),
          const PreferQuickSyncsSwitch(),
          const RedownloadTranscodesSwitch(),
          const ShowPlaylistTracksSwitch(),
          const DownloadWorkersSelector(),
          // Do not limit enqueued downloads on IOS, it throttles them like crazy on its own.
          if (!Platform.isIOS) const ConcurentDownloadsSelector(),
          const DownloadSizeWarningCutoffTile(),
        ],
      ),
    );
  }
}

class RequireWifiSwitch extends ConsumerWidget {
  const RequireWifiSwitch({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SwitchListTile.adaptive(
      title: Text(AppLocalizations.of(context)!.requireWifiForDownloads),
      value: ref.watch(finampSettingsProvider.requireWifiForDownloads),
      onChanged: FinampSetters.setRequireWifiForDownloads,
    );
  }
}

class SyncFavoritesSwitch extends ConsumerWidget {
  const SyncFavoritesSwitch({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SwitchListTile.adaptive(
      title: Text(AppLocalizations.of(context)!.trackOfflineFavorites),
      subtitle:
          Text(AppLocalizations.of(context)!.trackOfflineFavoritesSubtitle),
      value: ref.watch(finampSettingsProvider.trackOfflineFavorites),
      onChanged: (value) {
        FinampSetters.setTrackOfflineFavorites(value);
        if (value) {
          final isarDownloader = GetIt.instance<DownloadsService>();
          isarDownloader.resyncAll();
        }
      },
    );
  }
}

class ShowPlaylistTracksSwitch extends ConsumerWidget {
  const ShowPlaylistTracksSwitch({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SwitchListTile.adaptive(
      title: Text(AppLocalizations.of(context)!.showNullLibraryItemsTitle),
      subtitle:
          Text(AppLocalizations.of(context)!.showNullLibraryItemsSubtitle),
      value: ref.watch(finampSettingsProvider.showDownloadsWithUnknownLibrary),
      onChanged: FinampSetters.setShowDownloadsWithUnknownLibrary,
    );
  }
}

class SyncOnStartupSwitch extends ConsumerWidget {
  const SyncOnStartupSwitch({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SwitchListTile.adaptive(
      title: Text(AppLocalizations.of(context)!.syncOnStartupSwitch),
      value: ref.watch(finampSettingsProvider.resyncOnStartup),
      onChanged: FinampSetters.setResyncOnStartup,
    );
  }
}

class PreferQuickSyncsSwitch extends ConsumerWidget {
  const PreferQuickSyncsSwitch({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SwitchListTile.adaptive(
        title: Text(AppLocalizations.of(context)!.preferQuickSyncSwitch),
        subtitle:
            Text(AppLocalizations.of(context)!.preferQuickSyncSwitchSubtitle),
        value: ref.watch(finampSettingsProvider.preferQuickSyncs),
        onChanged: FinampSetters.setPreferQuickSyncs);
  }
}

class ConcurentDownloadsSelector extends ConsumerWidget {
  const ConcurentDownloadsSelector({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      children: [
        ListTile(
          title: Text(AppLocalizations.of(context)!.maxConcurrentDownloads),
          subtitle: Text(
              AppLocalizations.of(context)!.maxConcurrentDownloadsSubtitle),
        ),
        Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Slider(
              min: 1,
              max: 100,
              value: ref
                  .watch(finampSettingsProvider.maxConcurrentDownloads)
                  .clamp(1, 100)
                  .toDouble(),
              label: AppLocalizations.of(context)!.maxConcurrentDownloadsLabel(
                  ref
                      .watch(finampSettingsProvider.maxConcurrentDownloads)
                      .toString()),
              onChanged: (value) =>
                  FinampSetters.setMaxConcurrentDownloads(value.toInt()),
            ),
            Text(
              AppLocalizations.of(context)!.maxConcurrentDownloadsLabel(ref
                  .watch(finampSettingsProvider.maxConcurrentDownloads)
                  .toString()),
              style: Theme.of(context).textTheme.titleLarge,
            )
          ],
        )
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
                  value: finampSettings.downloadWorkers.clamp(1, 10).toDouble(),
                  label: AppLocalizations.of(context)!
                      .downloadsWorkersSettingLabel(
                          finampSettings.downloadWorkers.toString()),
                  onChanged: (value) =>
                      FinampSetters.setDownloadWorkers(value.toInt()),
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
    return SwitchListTile.adaptive(
      title: Text(AppLocalizations.of(context)!.redownloadTitle),
      subtitle: Text(AppLocalizations.of(context)!.redownloadSubtitle),
      value: ref.watch(finampSettingsProvider.shouldRedownloadTranscodes),
      onChanged: (value) async {
        FinampSetters.setShouldRedownloadTranscodes(value);
        if (value) {
          final isarDownloader = GetIt.instance<DownloadsService>();
          isarDownloader.markOutdatedTranscodes();
          await isarDownloader.resyncAll();
          GlobalSnackbar.message(
              (scaffold) => AppLocalizations.of(scaffold)!.redownloadcomplete);
        }
      },
    );
  }
}

class DownloadSizeWarningCutoffTile extends StatefulWidget {
  const DownloadSizeWarningCutoffTile({super.key});

  @override
  State<DownloadSizeWarningCutoffTile> createState() =>
      _BufferSizeListTileState();
}

class _BufferSizeListTileState extends State<DownloadSizeWarningCutoffTile> {
  final _controller = TextEditingController(
      text: FinampSettingsHelper.finampSettings.downloadSizeWarningCutoff
          .toString());

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(AppLocalizations.of(context)!.downloadSizeWarningCutoff),
      subtitle:
          Text(AppLocalizations.of(context)!.downloadSizeWarningCutoffSubtitle),
      trailing: SizedBox(
        width: 50 * MediaQuery.of(context).textScaleFactor,
        child: TextField(
          controller: _controller,
          textAlign: TextAlign.center,
          keyboardType: TextInputType.number,
          onChanged: (value) {
            var valueInt = int.tryParse(value);

            if (valueInt != null && !valueInt.isNegative) {
              FinampSetters.setDownloadSizeWarningCutoff(valueInt);
            }
          },
        ),
      ),
    );
  }
}
