import 'package:finamp/models/finamp_models.dart';
import 'package:finamp/services/queue_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get_it/get_it.dart';

import '../../services/finamp_settings_helper.dart';

const _radius = Radius.circular(99);
const _borderRadius = BorderRadius.all(_radius);
const _height = 24.0; // I'm sure this magic number will work on all devices
final _defaultBackgroundColour = Colors.white.withOpacity(0.1);

class FeatureState {
  const FeatureState({
    required this.context,
    required this.currentTrack,
    required this.settings,
  });

  final BuildContext context;
  final FinampQueueItem? currentTrack;
  final FinampSettings settings;

  get features {
    final features = [];

    if (currentTrack?.item.extras?["downloadedSongPath"] != null) {
      features.add(
        FeatureProperties(
          text: AppLocalizations.of(context)!.playbackModeLocal,
        ),
      );
    } else {
      if (currentTrack?.item.extras?["shouldTranscode"]) {
        features.add(
          FeatureProperties(
            text:
                "${AppLocalizations.of(context)!.playbackModeTranscoding} @ ${AppLocalizations.of(context)!.kiloBitsPerSecondLabel(settings.transcodeBitrate ~/ 1000)}",
          ),
        );
      } else {
        features.add(
          //TODO differentiate between direct streaming and direct playing
          // const FeatureProperties(
          //   text: "Direct Streaming",
          // ),
          FeatureProperties(
            text: AppLocalizations.of(context)!.playbackModeDirectPlaying,
          ),
        );
      }
    }

    // TODO this will likely be extremely outdated if offline, hide?
    if (currentTrack?.baseItem?.userData?.playCount != null) {
      features.add(
        FeatureProperties(
          text: AppLocalizations.of(context)!
              .playCountValue(currentTrack!.baseItem!.userData?.playCount ?? 0),
        ),
      );
    }

    if (currentTrack?.baseItem?.people?.isNotEmpty == true) {
      currentTrack?.baseItem?.people?.forEach((person) {
        features.add(
          FeatureProperties(
            text: "${person.role}: ${person.name}",
          ),
        );
      });
    }

    //TODO get codec information (from just_audio or Jellyfin)

    return features;
  }
}

class FeatureProperties {
  const FeatureProperties({
    required this.text,
  });

  final String text;
}

class FeatureChips extends StatelessWidget {
  const FeatureChips({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final queueService = GetIt.instance<QueueService>();

    return ValueListenableBuilder(
        valueListenable: FinampSettingsHelper.finampSettingsListener,
        builder: (context, value, child) {
          final settings = FinampSettingsHelper.finampSettings;
          return StreamBuilder<FinampQueueItem?>(
              stream: queueService.getCurrentTrackStream(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const SizedBox.shrink();
                }
                final featureState = FeatureState(
                  context: context,
                  currentTrack: snapshot.data,
                  settings: settings,
                );

                return SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Features(
                    backgroundColor:
                        IconTheme.of(context).color?.withOpacity(0.1) ??
                            _defaultBackgroundColour,
                    features: featureState,
                  ),
                );
              });
        });
  }
}

class Features extends StatelessWidget {
  const Features({
    Key? key,
    required this.features,
    this.backgroundColor,
    this.color,
  }) : super(key: key);

  final FeatureState features;
  final Color? backgroundColor;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 4.0,
      runSpacing: 4.0,
      children: List.generate(features.features.length ?? 0, (index) {
        final feature = features.features![index];

        return _FeatureContent(
          backgroundColor: IconTheme.of(context).color?.withOpacity(0.1) ??
              _defaultBackgroundColour,
          feature: feature,
          color: color,
        );
      }),
    );
  }
}

class _FeatureContent extends StatelessWidget {
  const _FeatureContent({
    Key? key,
    required this.feature,
    required this.backgroundColor,
    this.color,
  }) : super(key: key);

  final FeatureProperties feature;
  final Color? backgroundColor;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: backgroundColor ?? _defaultBackgroundColour,
        borderRadius: _borderRadius,
      ),
      constraints: const BoxConstraints(maxWidth: 220),
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 2.0),
      child: Text(
        feature.text,
        style: Theme.of(context).textTheme.bodySmall!.copyWith(
            fontWeight: FontWeight.w300,
            overflow: TextOverflow.ellipsis),
        softWrap: false,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}
