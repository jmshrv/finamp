import 'dart:ui';

import 'package:collection/collection.dart';
import 'package:file_sizes/file_sizes.dart';
import 'package:finamp/l10n/app_localizations.dart';
import 'package:finamp/models/finamp_models.dart';
import 'package:finamp/models/jellyfin_models.dart';
import 'package:finamp/services/current_track_metadata_provider.dart';
import 'package:finamp/services/metadata_provider.dart';
import 'package:finamp/services/music_player_background_task.dart';
import 'package:finamp/services/queue_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
import 'package:logging/logging.dart';

import '../../services/finamp_settings_helper.dart';

final _defaultBackgroundColour = Colors.white.withOpacity(0.1);
final featureLogger = Logger("Features");

class FeatureState {
  const FeatureState({
    required this.context,
    required this.currentTrack,
    required this.settings,
    required this.metadata,
  });

  final BuildContext context;
  final FinampQueueItem? currentTrack;
  final FinampSettings settings;
  final MetadataProvider? metadata;

  String get properties =>
      "currentTrack: '${currentTrack?.item.title}', "
      "isDownloaded: $isDownloaded, "
      "isTranscoding: $isTranscoding, "
      "container: $container, "
      "size: $size, "
      "audioStream: ${audioStream?.toJson().toString()}, "
      "bitrate: $bitrate, "
      "sampleRate: $sampleRate, "
      "bitDepth: $bitDepth";

  FinampFeatureChipsConfiguration get configuration => settings.featureChipsConfiguration;

  bool get isDownloaded => metadata?.isDownloaded ?? false;
  bool get isTranscoding => !isDownloaded && (currentTrack?.item.extras?["shouldTranscode"] as bool? ?? false);
  String get container =>
      isTranscoding ? settings.transcodingStreamingFormat.codec : metadata?.mediaSourceInfo.container ?? "";
  int? get size => isTranscoding ? null : metadata?.mediaSourceInfo.size;
  MediaStream? get audioStream => isTranscoding
      ? null
      : metadata?.mediaSourceInfo.mediaStreams.firstWhereOrNull((stream) => stream.type == "Audio");
  // Transcoded downloads will not have a valid MediaStream, but will have
  // the target transcode bitrate set for the mediasource bitrate.  Other items
  // should have a valid mediaStream, so use that audio-only bitrate instead of the
  // whole-file bitrate.
  int? get bitrate => isTranscoding
      ? (settings.transcodingStreamingFormat.codec == 'flac' ? null : settings.transcodeBitrate)
      : audioStream?.bitRate ?? metadata?.mediaSourceInfo.bitrate;
  int? get sampleRate => audioStream?.sampleRate;
  int? get bitDepth => audioStream?.bitDepth;

  List<FeatureProperties> get features {
    final queueService = GetIt.instance<QueueService>();

    final List<FeatureProperties> features = [];

    if (queueService.playbackSpeed != 1.0) {
      features.add(
        FeatureProperties(text: AppLocalizations.of(context)!.playbackSpeedFeatureText(queueService.playbackSpeed)),
      );
    }

    if (FinampSettingsHelper.finampSettings.currentVolume != 1.0) {
      features.add(
        FeatureProperties(
          text: AppLocalizations.of(
            context,
          )!.currentVolumeFeatureText((FinampSettingsHelper.finampSettings.currentVolume * 100).floor()),
        ),
      );
    }

    for (var feature in configuration.features) {
      // TODO this will likely be extremely outdated if offline, hide?
      if (feature == FinampFeatureChipType.playCount && currentTrack?.baseItem?.userData?.playCount != null) {
        features.add(
          FeatureProperties(
            type: feature,
            text: AppLocalizations.of(context)!.playCountValue(currentTrack!.baseItem!.userData?.playCount ?? 0),
          ),
        );
      }

      if (feature == FinampFeatureChipType.additionalPeople && (currentTrack?.baseItem?.people?.isNotEmpty ?? false)) {
        currentTrack?.baseItem?.people?.forEach((person) {
          features.add(FeatureProperties(type: feature, text: "${person.role}: ${person.name}"));
        });
      }

      if (feature == FinampFeatureChipType.playbackMode) {
        if (currentTrack?.item.extras?["downloadedTrackPath"] != null) {
          features.add(FeatureProperties(type: feature, text: AppLocalizations.of(context)!.playbackModeLocal));
        } else {
          if (isTranscoding) {
            features.add(FeatureProperties(type: feature, text: AppLocalizations.of(context)!.playbackModeTranscoding));
          } else {
            features.add(
              //TODO differentiate between direct streaming and direct playing
              // const FeatureProperties(
              //   text: "Direct Streaming",
              // ),
              FeatureProperties(type: feature, text: AppLocalizations.of(context)!.playbackModeDirectPlaying),
            );
          }
        }
      }

      if (metadata?.mediaSourceInfo != null) {
        if (feature == FinampFeatureChipType.codec || feature == FinampFeatureChipType.bitRate) {
          // only add this feature the first time
          if (!features.any((f) => f.type == FinampFeatureChipType.codec)) {
            features.add(
              FeatureProperties(
                type: feature,
                text:
                    "${configuration.features.contains(FinampFeatureChipType.codec) ? container.toUpperCase() : ""}${configuration.features.contains(FinampFeatureChipType.codec) && configuration.features.contains(FinampFeatureChipType.bitRate) && bitrate != null ? " @ " : ""}${configuration.features.contains(FinampFeatureChipType.bitRate) && bitrate != null ? AppLocalizations.of(context)!.kiloBitsPerSecondLabel(bitrate! ~/ 1000) : ""}",
              ),
            );
          }
        }

        if (feature == FinampFeatureChipType.bitDepth && bitDepth != null) {
          features.add(FeatureProperties(type: feature, text: AppLocalizations.of(context)!.numberAsBit(bitDepth!)));
        }

        if (feature == FinampFeatureChipType.sampleRate && sampleRate != null) {
          features.add(
            FeatureProperties(
              type: feature,
              text: AppLocalizations.of(context)!.numberAsKiloHertz(sampleRate! / 1000.0),
            ),
          );
        }

        if (feature == FinampFeatureChipType.size && size != null) {
          features.add(FeatureProperties(type: feature, text: FileSize.getSize(size)));
        }
      }

      if (feature == FinampFeatureChipType.normalizationGain &&
          FinampSettingsHelper.finampSettings.volumeNormalizationActive) {
        double? effectiveGainChange = getGainForCurrentPlayback(currentTrack!.item, currentTrack!.baseItem);
        if (effectiveGainChange != null) {
          features.add(
            FeatureProperties(
              type: feature,
              text: AppLocalizations.of(context)!.numberAsDecibel(double.parse(effectiveGainChange.toStringAsFixed(1))),
            ),
          );
        }
      }
    }
    return features;
  }
}

class FeatureProperties {
  const FeatureProperties({required this.text, this.type});

  final String text;
  final FinampFeatureChipType? type;
}

class FeatureChips extends ConsumerWidget {
  const FeatureChips({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final queueService = GetIt.instance<QueueService>();

    final metadata = ref.watch(currentTrackMetadataProvider).unwrapPrevious();

    // TODO refactor this to not rebuild on every settings change
    final settings = ref.watch(finampSettingsProvider).requireValue;
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
          metadata: metadata.valueOrNull,
        );

        // log feature state for debugging
        //TODO if feature chips are disabled, this won't be logged, but is super useful for debugging. Ideally, move the whole metadata stuff into the metadata provider and log it there, and then use the generated values to create the feature chips if needed
        featureLogger.finer("Current track features: ${featureState.properties}");

        return Padding(
          padding: const EdgeInsets.only(left: 32.0, right: 32.0),
          child: ScrollConfiguration(
            // Allow drag scrolling on desktop
            behavior: ScrollConfiguration.of(context).copyWith(dragDevices: PointerDeviceKind.values.toSet()),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Features(
                backgroundColor: IconTheme.of(context).color?.withOpacity(0.1) ?? _defaultBackgroundColour,
                features: featureState,
              ),
            ),
          ),
        );
      },
    );
  }
}

class Features extends StatelessWidget {
  const Features({super.key, required this.features, this.backgroundColor, this.color});

  final FeatureState features;
  final Color? backgroundColor;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    var featureList = features.features;
    return Wrap(
      spacing: 4.0,
      runSpacing: 4.0,
      children: List.generate(featureList.length, (index) {
        final feature = featureList[index];

        return _FeatureContent(
          backgroundColor: IconTheme.of(context).color?.withOpacity(0.1) ?? _defaultBackgroundColour,
          feature: feature,
          color: color,
        );
      }),
    );
  }
}

class _FeatureContent extends StatelessWidget {
  const _FeatureContent({required this.feature, required this.backgroundColor, this.color});

  final FeatureProperties feature;
  final Color? backgroundColor;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Container(
      // decoration: BoxDecoration(
      //   color: backgroundColor ?? _defaultBackgroundColour,
      //   borderRadius: _borderRadius,
      // ),
      constraints: const BoxConstraints(maxWidth: 220),
      padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 2.0),
      child: Text(
        feature.text,
        style: Theme.of(
          context,
        ).textTheme.displaySmall!.copyWith(fontSize: 11, fontWeight: FontWeight.w300, overflow: TextOverflow.ellipsis),
        softWrap: false,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}
