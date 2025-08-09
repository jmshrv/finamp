import 'dart:core';

import 'package:audio_session/audio_session.dart';
import 'package:finamp/l10n/app_localizations.dart';
import 'package:finamp/menus/quick_connect_authorization_menu.dart';
import 'package:finamp/menus/server_sharing_menu.dart';
import 'package:finamp/screens/accessibility_settings_screen.dart';
import 'package:finamp/screens/interaction_settings_screen.dart';
import 'package:finamp/screens/network_settings_screen.dart';
import 'package:finamp/screens/search_settings_screen.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:locale_names/locale_names.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import '../components/SettingsScreen/logout_list_tile.dart';
import '../services/finamp_settings_helper.dart';
import '../services/locale_helper.dart';
import 'audio_service_settings_screen.dart';
import 'downloads_settings_screen.dart';
import 'language_selection_screen.dart';
import 'layout_settings_screen.dart';
import 'playback_reporting_settings_screen.dart';
import 'transcoding_settings_screen.dart';
import 'view_selector.dart';
import 'volume_normalization_settings_screen.dart';

class SettingsItem {
  final IconData? icon;
  final String? title;
  String? route;
  final String? subtitle;
  final bool enabled;
  Function? onTap;
  Widget? settingWidget;
  List<Widget>? searchableSettingsItems;

  SettingsItem({
    this.icon,
    this.title,
    this.route,
    this.subtitle,
    this.enabled = true,
    this.onTap,
    this.settingWidget,
    this.searchableSettingsItems,
  });

  Widget getListTileWidget(BuildContext context) {
    if (settingWidget == null) {
      return ListTile(
        leading: Icon(icon),
        title: Text(title ?? ""),
        subtitle: Text(subtitle ?? ""),
        enabled: enabled,
        onTap:
            (onTap ??
                    ((enabled && route != null)
                        ? () => Navigator.of(context).pushNamed(route!)
                        : () {}))
                as GestureTapCallback,
      );
    } else {
      return settingWidget!;
    }
  }
}

class SettingsList {
  List<SettingsItem> categoryItems;
  List<SettingsItem> settingsItems;
  SettingsList({required this.categoryItems, required this.settingsItems});
}

class SettingsScreen extends ConsumerStatefulWidget {
  SettingsScreen({super.key});
  static const routeName = "/settings";
  List<Widget> searchableSettingsChildren;
  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  static const repoLink = "https://github.com/jmshrv/finamp";
  static const releaseNotesLink = "https://github.com/jmshrv/finamp/releases";
  static const translationsLink = "https://hosted.weblate.org/projects/finamp";

  SettingsList getSettings() {
    List<SettingsItem> categoryItems = [
      SettingsItem(
        icon: Icons.compress,
        title: AppLocalizations.of(context)!.transcoding,
        route: TranscodingSettingsScreen.routeName,
      ),

      SettingsItem(
        icon: Icons.download,
        title: AppLocalizations.of(context)!.downloadSettings,
        route: DownloadsSettingsScreen.routeName,
      ),

      SettingsItem(
        icon: Icons.wifi,
        title: AppLocalizations.of(context)!.networkSettingsTitle,
        route: NetworkSettingsScreen.routeName,
      ),
      SettingsItem(
        icon: Icons.music_note,
        title: AppLocalizations.of(context)!.audioService,
        route: AudioServiceSettingsScreen.routeName,
      ),

      SettingsItem(
        icon: TablerIcons.cast,
        title: AppLocalizations.of(context)!.playbackReportingSettingsTitle,
        route: PlaybackReportingSettingsScreen.routeName,
      ),

      SettingsItem(
        icon: Icons.equalizer_rounded,
        title: AppLocalizations.of(context)!.volumeNormalizationSettingsTitle,
        route: VolumeNormalizationSettingsScreen.routeName,
      ),

      SettingsItem(
        icon: Icons.gesture,
        title: AppLocalizations.of(context)!.interactions,
        route: InteractionSettingsScreen.routeName,
      ),

      SettingsItem(
        icon: Icons.widgets,
        title: AppLocalizations.of(context)!.layoutAndTheme,
        route: LayoutSettingsScreen.routeName,
      ),

      SettingsItem(
        icon: TablerIcons.accessible,
        title: AppLocalizations.of(context)!.accessibility,
        route: AccessibilitySettingsScreen.routeName,
      ),

      SettingsItem(
        icon: Icons.library_music,
        title: AppLocalizations.of(context)!.selectMusicLibraries,
        route: ViewSelector.routeName,
        subtitle: ref.watch(finampSettingsProvider.isOffline)
            ? (AppLocalizations.of(context)!.notAvailableInOfflineMode)
            : null,
        enabled: !ref.watch(finampSettingsProvider.isOffline),
      ),

      SettingsItem(
        icon: Icons.language,
        title: AppLocalizations.of(context)!.language,
        route: LanguageSelectionScreen.routeName,
        subtitle:
            LocaleHelper.locale?.nativeDisplayLanguage ??
            AppLocalizations.of(context)!.system,
      ),
      SettingsItem(settingWidget: Divider()),

      SettingsItem(
        icon: TablerIcons.access_point,
        title: AppLocalizations.of(context)!.serverSharingMenuButtonTitle,
        onTap: () => showServerSharingPanel(context: context),
      ),

      SettingsItem(
        icon: TablerIcons.lock_bolt,
        title: AppLocalizations.of(
          context,
        )!.quickConnectAuthorizationMenuButtonTitle,
        onTap: () => showQuickConnectAuthorizationMenu(context: context),
      ),

      SettingsItem(settingWidget: LogoutListTile()),
    ];
    List<SettingsItem> searchedSettingsItems = [];
    for (SettingsItem categoryItem in categoryItems) {
      if (categoryItem.searchableSettingsItems != null) {
        for (var item in categoryItem.searchableSettingsItems!) {
          searchedSettingsItems.add(SettingsItem(settingWidget: item))
        }
      }
    }
    return SettingsList(categoryItems: categoryItems, settingsItems: []);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.settings),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              showSearch(
                context: context,
                delegate: SettingsSearchDelegate(settingsList: getSettings()),
              );
            },
          ),
          FinampSettingsHelper.makeSettingsResetButtonWithDialog(
            context,
            FinampSettingsHelper.resetAllSettings,
            isGlobal: true,
          ),
          Semantics.fromProperties(
            properties: SemanticsProperties(
              label: AppLocalizations.of(context)!.about,
              button: true,
            ),
            excludeSemantics: true,
            container: true,
            child: IconButton(
              icon: Icon(Icons.info),
              onPressed: () async {
                final localizations = AppLocalizations.of(context)!;
                final applicationLegalese = AppLocalizations.of(
                  context,
                )!.applicationLegalese(repoLink);
                PackageInfo packageInfo = await PackageInfo.fromPlatform();

                ThemeData theme = Theme.of(context);
                const linkStyle = TextStyle(
                  color: Colors.blue,
                  decoration: TextDecoration.underline,
                );

                showAboutDialog(
                  context: context,
                  applicationName: packageInfo.appName,
                  applicationVersion: packageInfo.version,
                  applicationIcon: Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: SvgPicture.asset(
                      'images/finamp_cropped.svg',
                      width: 56,
                      height: 56,
                    ),
                  ),
                  applicationLegalese: applicationLegalese,
                  children: [
                    const SizedBox(height: 20),
                    RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        style: TextStyle(
                          color: theme.textTheme.bodyMedium!.color,
                        ),
                        children: [
                          TextSpan(
                            text: localizations.finampTagline,
                            style: const TextStyle(
                              fontStyle: FontStyle.italic,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const TextSpan(text: '\n\n'),
                          TextSpan(text: localizations.aboutContributionPrompt),
                          const TextSpan(text: '\n\n'),
                          TextSpan(
                            text: '${localizations.aboutContributionLink}\n',
                          ),
                          TextSpan(
                            text: repoLink,
                            style: linkStyle,
                            recognizer: TapGestureRecognizer()
                              ..onTap = () async {
                                await launchUrl(Uri.parse(repoLink));
                              },
                          ),
                          const TextSpan(text: '\n\n'),
                          TextSpan(
                            text: '${localizations.aboutTranslations}\n',
                          ),
                          TextSpan(
                            text: translationsLink,
                            style: linkStyle,
                            recognizer: TapGestureRecognizer()
                              ..onTap = () async {
                                await launchUrl(Uri.parse(translationsLink));
                              },
                          ),
                          const TextSpan(text: '\n\n'),
                          TextSpan(
                            text: '${localizations.aboutReleaseNotes}\n',
                          ),
                          TextSpan(
                            text: releaseNotesLink,
                            style: linkStyle,
                            recognizer: TapGestureRecognizer()
                              ..onTap = () async {
                                await launchUrl(Uri.parse(releaseNotesLink));
                              },
                          ),
                          const TextSpan(text: '\n\n\n'),
                          TextSpan(
                            text: localizations.aboutThanks,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
      body: ListView(
        children: List.of(
          getSettings().categoryItems.map((e) => e.getListTileWidget(context)),
        ),
      ),
    );
  }
}
