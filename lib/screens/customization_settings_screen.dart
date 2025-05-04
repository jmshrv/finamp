import 'dart:io';

import 'package:finamp/components/LayoutSettingsScreen/CustomizationSettingsScreen/playback_speed_control_visibility_dropdown_list_tile.dart';
import 'package:finamp/models/finamp_models.dart';
import 'package:finamp/services/finamp_settings_helper.dart';
import 'package:finamp/services/music_player_background_task.dart';
import 'package:flutter/material.dart';
import 'package:finamp/l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';

class CustomizationSettingsScreen extends StatefulWidget {
  const CustomizationSettingsScreen({super.key});

  static const routeName = "/settings/customization";

  @override
  State<CustomizationSettingsScreen> createState() =>
      _CustomizationSettingsScreenState();
}

class _CustomizationSettingsScreenState
    extends State<CustomizationSettingsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.customizationSettingsTitle),
        actions: [
          FinampSettingsHelper.makeSettingsResetButtonWithDialog(
              context, FinampSettingsHelper.resetCustomizationSettings)
        ],
      ),
      body: ListView(
        children: [
          const PlaybackSpeedControlVisibilityDropdownListTile(),
          if (!Platform.isIOS) const ShowStopButtonOnMediaNotificationToggle(),
          if (!Platform.isIOS)
            const ShowShuffleButtonOnMediaNotificationToggle(),
          if (!Platform.isIOS)
            const ShowFavoriteButtonOnMediaNotificationToggle(),
          const ShowSeekControlsOnMediaNotificationToggle(),
          const OneLineMarqueeTextSwitch(),
          const ReleaseDateFormatDropdownListTile(),
          const ShowAlbumReleaseDateOnPlayerScreenToggle(),
        ],
      ),
    );
  }
}

class OneLineMarqueeTextSwitch extends ConsumerWidget {
  const OneLineMarqueeTextSwitch({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SwitchListTile.adaptive(
      title: Text(AppLocalizations.of(context)!.oneLineMarqueeTextButton),
      subtitle:
          Text(AppLocalizations.of(context)!.oneLineMarqueeTextButtonSubtitle),
      value: ref.watch(finampSettingsProvider.oneLineMarqueeTextButton),
      onChanged: FinampSetters.setOneLineMarqueeTextButton,
    );
  }
}

class ShowStopButtonOnMediaNotificationToggle extends ConsumerWidget {
  const ShowStopButtonOnMediaNotificationToggle({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SwitchListTile.adaptive(
      title: Text(
          AppLocalizations.of(context)!.showStopButtonOnMediaNotificationTitle),
      subtitle: Text(AppLocalizations.of(context)!
          .showStopButtonOnMediaNotificationSubtitle),
      value:
          ref.watch(finampSettingsProvider.showStopButtonOnMediaNotification),
      onChanged: (value) {
        FinampSetters.setShowStopButtonOnMediaNotification(value);
        GetIt.instance<MusicPlayerBackgroundTask>()
            .refreshPlaybackStateAndMediaNotification();
      },
    );
  }
}

class ShowShuffleButtonOnMediaNotificationToggle extends ConsumerWidget {
  const ShowShuffleButtonOnMediaNotificationToggle({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SwitchListTile.adaptive(
      title: Text(AppLocalizations.of(context)!
          .showShuffleButtonOnMediaNotificationTitle),
      subtitle: Text(AppLocalizations.of(context)!
          .showShuffleButtonOnMediaNotificationSubtitle),
      value: ref
          .watch(finampSettingsProvider.showShuffleButtonOnMediaNotification),
      onChanged: (value) {
        FinampSetters.setShowShuffleButtonOnMediaNotification(value);
        GetIt.instance<MusicPlayerBackgroundTask>()
            .refreshPlaybackStateAndMediaNotification();
      },
    );
  }
}

class ShowFavoriteButtonOnMediaNotificationToggle extends ConsumerWidget {
  const ShowFavoriteButtonOnMediaNotificationToggle({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SwitchListTile.adaptive(
      title: Text(AppLocalizations.of(context)!
          .showFavoriteButtonOnMediaNotificationTitle),
      subtitle: Text(AppLocalizations.of(context)!
          .showFavoriteButtonOnMediaNotificationSubtitle),
      value: ref
          .watch(finampSettingsProvider.showFavoriteButtonOnMediaNotification),
      onChanged: (value) {
        FinampSetters.setShowFavoriteButtonOnMediaNotification(value);
        GetIt.instance<MusicPlayerBackgroundTask>()
            .refreshPlaybackStateAndMediaNotification();
      },
    );
  }
}

class ShowSeekControlsOnMediaNotificationToggle extends ConsumerWidget {
  const ShowSeekControlsOnMediaNotificationToggle({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SwitchListTile.adaptive(
      title: Text(AppLocalizations.of(context)!
          .showSeekControlsOnMediaNotificationTitle),
      subtitle: Text(AppLocalizations.of(context)!
          .showSeekControlsOnMediaNotificationSubtitle),
      value:
          ref.watch(finampSettingsProvider.showSeekControlsOnMediaNotification),
      onChanged: (value) {
        FinampSetters.setShowSeekControlsOnMediaNotification(value);
        GetIt.instance<MusicPlayerBackgroundTask>()
            .refreshPlaybackStateAndMediaNotification();
      },
    );
  }
}

class ShowAlbumReleaseDateOnPlayerScreenToggle extends ConsumerWidget {
  const ShowAlbumReleaseDateOnPlayerScreenToggle({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SwitchListTile.adaptive(
      title: Text(AppLocalizations.of(context)!
          .showAlbumReleaseDateOnPlayerScreenTitle),
      subtitle: Text(AppLocalizations.of(context)!
          .showAlbumReleaseDateOnPlayerScreenSubtitle),
      value:
          ref.watch(finampSettingsProvider.showAlbumReleaseDateOnPlayerScreen),
      onChanged: FinampSetters.setShowAlbumReleaseDateOnPlayerScreen,
    );
  }
}

class ReleaseDateFormatDropdownListTile extends ConsumerWidget {
  const ReleaseDateFormatDropdownListTile({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListTile(
      title: Text(AppLocalizations.of(context)!.releaseDateFormatTitle),
      subtitle: Text(AppLocalizations.of(context)!.releaseDateFormatSubtitle),
      trailing: DropdownButton<ReleaseDateFormat>(
        value: ref.watch(finampSettingsProvider.releaseDateFormat),
        items: ReleaseDateFormat.values
            .map((e) => DropdownMenuItem<ReleaseDateFormat>(
                  value: e,
                  child: Text(e.toLocalisedString(context)),
                ))
            .toList(),
        onChanged: FinampSetters.setReleaseDateFormat.ifNonNull,
      ),
    );
  }
}
