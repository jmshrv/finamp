import 'package:finamp/screens/interaction_settings_screen.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_svg/flutter_svg.dart';
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
import 'transcoding_settings_screen.dart';
import 'view_selector.dart';
import 'volume_normalization_settings_screen.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});
  static const routeName = "/settings";
  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  static const repoLink = "https://github.com/jmshrv/finamp";
  static const releaseNotesLink = "https://github.com/jmshrv/finamp/releases";
  static const translationsLink = "https://hosted.weblate.org/projects/finamp";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.settings),
        actions: [
          FinampSettingsHelper.makeSettingsResetButtonWithDialog(
              context, FinampSettingsHelper.resetAllSettings,
              isGlobal: true),
          Semantics.fromProperties(
            properties: SemanticsProperties(
              label: AppLocalizations.of(context)!.about,
              button: true,
            ),
            excludeSemantics: true,
            container: true,
            child: IconButton(
              icon: const Icon(Icons.info),
              onPressed: () async {
                final localizations = AppLocalizations.of(context)!;
                final applicationLegalese =
                    AppLocalizations.of(context)!.applicationLegalese(repoLink);
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
                              color: theme.textTheme.bodyMedium!.color),
                          children: [
                            TextSpan(
                              text: localizations.finampTagline,
                              style: const TextStyle(
                                  fontStyle: FontStyle.italic,
                                  fontWeight: FontWeight.w500),
                            ),
                            const TextSpan(
                              text: '\n\n',
                            ),
                            TextSpan(
                              text: localizations.aboutContributionPrompt,
                            ),
                            const TextSpan(
                              text: '\n\n',
                            ),
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
                            const TextSpan(
                              text: '\n\n',
                            ),
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
                            const TextSpan(
                              text: '\n\n',
                            ),
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
                            const TextSpan(
                              text: '\n\n\n',
                            ),
                            TextSpan(
                              text: localizations.aboutThanks,
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    ]);
              },
            ),
          )
        ],
      ),
      body: ListView(
        children: [
          ListTile(
            leading: const Icon(Icons.compress),
            title: Text(AppLocalizations.of(context)!.transcoding),
            onTap: () => Navigator.of(context)
                .pushNamed(TranscodingSettingsScreen.routeName),
          ),
          ListTile(
            leading: const Icon(Icons.download),
            title: Text(AppLocalizations.of(context)!.downloadSettings),
            onTap: () => Navigator.of(context)
                .pushNamed(DownloadsSettingsScreen.routeName),
          ),
          ListTile(
            leading: const Icon(Icons.music_note),
            title: Text(AppLocalizations.of(context)!.audioService),
            onTap: () => Navigator.of(context)
                .pushNamed(AudioServiceSettingsScreen.routeName),
          ),
          ListTile(
            leading: const Icon(Icons.equalizer_rounded),
            title: Text(
                AppLocalizations.of(context)!.volumeNormalizationSettingsTitle),
            onTap: () => Navigator.of(context)
                .pushNamed(VolumeNormalizationSettingsScreen.routeName),
          ),
          ListTile(
            leading: const Icon(Icons.gesture),
            title: Text(AppLocalizations.of(context)!.interactions),
            onTap: () => Navigator.of(context)
                .pushNamed(InteractionSettingsScreen.routeName),
          ),
          ListTile(
            leading: const Icon(Icons.widgets),
            title: Text(AppLocalizations.of(context)!.layoutAndTheme),
            onTap: () =>
                Navigator.of(context).pushNamed(LayoutSettingsScreen.routeName),
          ),
          ListTile(
            leading: const Icon(Icons.library_music),
            title: Text(AppLocalizations.of(context)!.selectMusicLibraries),
            subtitle: FinampSettingsHelper.finampSettings.isOffline
                ? Text(AppLocalizations.of(context)!.notAvailableInOfflineMode)
                : null,
            enabled: !FinampSettingsHelper.finampSettings.isOffline,
            onTap: () =>
                Navigator.of(context).pushNamed(ViewSelector.routeName),
          ),
          ListTile(
            leading: const Icon(Icons.language),
            title: Text(AppLocalizations.of(context)!.language),
            subtitle: Text(LocaleHelper.locale?.nativeDisplayLanguage ??
                AppLocalizations.of(context)!.system),
            onTap: () => Navigator.of(context)
                .pushNamed(LanguageSelectionScreen.routeName),
          ),
          const LogoutListTile(),
        ],
      ),
    );
  }
}
