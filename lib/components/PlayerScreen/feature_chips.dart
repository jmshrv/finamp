import 'dart:ui';

import 'package:collection/collection.dart';
import 'package:file_sizes/file_sizes.dart';
import 'package:finamp/models/finamp_models.dart';
import 'package:finamp/models/jellyfin_models.dart';
import 'package:finamp/services/current_track_metadata_provider.dart';
import 'package:finamp/services/metadata_provider.dart';
import 'package:finamp/services/music_player_background_task.dart';
import 'package:finamp/services/queue_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';

import '../../services/finamp_settings_helper.dart';

final _defaultBackgroundColour = Colors.white.withOpacity(0.1);

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

  bool get isDownloaded => metadata?.isDownloaded ?? false;
  bool get isTranscoding =>
      !isDownloaded && (currentTrack?.item.extras?["shouldTranscode"] ?? false);
  String get container =>
      isTranscoding ? "aac" : metadata?.mediaSourceInfo.container ?? "";
  int? get size => isTranscoding ? null : metadata?.mediaSourceInfo.size;
  MediaStream? get audioStream => isTranscoding
      ? null
      : metadata?.mediaSourceInfo.mediaStreams
          .firstWhereOrNull((stream) => stream.type == "Audio");
  // Transcoded downloads will not have a valid MediaStream, but will have
  // the target transcode bitrate set for the mediasource bitrate.  Other items
  // should have a valid mediaStream, so use that audio-only bitrate instead of the
  // whole-file bitrate.
  int? get bitrate => isTranscoding
      ? settings.transcodeBitrate
      : audioStream?.bitRate ?? metadata?.mediaSourceInfo.bitrate;
  int? get sampleRate => audioStream?.sampleRate;
  int? get bitDepth => audioStream?.bitDepth;

  List<FeatureProperties> get features {
    final queueService = GetIt.instance<QueueService>();

    final List<FeatureProperties> features = [];

    if (queueService.playbackSpeed != 1.0) {
      features.add(
        FeatureProperties(
          text: AppLocalizations.of(context)!
              .playbackSpeedFeatureText(queueService.playbackSpeed),
        ),
      );
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

    if (currentTrack?.baseItem?.people?.isNotEmpty ?? false) {
      currentTrack?.baseItem?.people?.forEach((person) {
        features.add(
          FeatureProperties(
            text: "${person.role}: ${person.name}",
          ),
        );
      });
    }

    if (currentTrack?.item.extras?["downloadedSongPath"] != null) {
      features.add(
        FeatureProperties(
          text: AppLocalizations.of(context)!.playbackModeLocal,
        ),
      );
    } else {
      if (isTranscoding) {
        features.add(
          FeatureProperties(
            text: AppLocalizations.of(context)!.playbackModeTranscoding,
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

    if (metadata?.mediaSourceInfo != null) {
      if (bitrate != null) {
        features.add(
          FeatureProperties(
            text:
                "${container.toUpperCase()} @ ${AppLocalizations.of(context)!.kiloBitsPerSecondLabel(bitrate! ~/ 1000)}",
          ),
        );
      }

      if (bitDepth != null) {
        features.add(
          FeatureProperties(
            text: AppLocalizations.of(context)!.numberAsBit(bitDepth!),
          ),
        );
      }

      if (sampleRate != null) {
        features.add(
          FeatureProperties(
            text: AppLocalizations.of(context)!
                .numberAsKiloHertz(sampleRate! / 1000.0),
          ),
        );
      }

      if (size != null) {
        features.add(
          FeatureProperties(
            text: FileSize.getSize(size),
          ),
        );
      }
    }

    if (FinampSettingsHelper.finampSettings.volumeNormalizationActive) {
      double? effectiveGainChange =
          getEffectiveGainChange(currentTrack!.item, currentTrack!.baseItem);
      if (effectiveGainChange != null) {
        features.add(
          FeatureProperties(
            text: AppLocalizations.of(context)!.numberAsDecibel(
                double.parse(effectiveGainChange.toStringAsFixed(1))),
          ),
        );
      }
    }

    return features;
  }
}

class FeatureProperties {
  const FeatureProperties({
    required this.text,
  });

  final String text;
}

class FeatureChips extends ConsumerWidget {
  const FeatureChips({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final queueService = GetIt.instance<QueueService>();

    final metadata = ref.watch(currentTrackMetadataProvider).unwrapPrevious();

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
                  metadata: metadata.valueOrNull,
                );

                return Padding(
                  padding: const EdgeInsets.only(left: 32.0, right: 32.0),
                  child: ScrollConfiguration(
                    // Allow drag scrolling on desktop
                    behavior: ScrollConfiguration.of(context).copyWith(
                        dragDevices: PointerDeviceKind.values.toSet()),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Features(
                        backgroundColor:
                            IconTheme.of(context).color?.withOpacity(0.1) ??
                                _defaultBackgroundColour,
                        features: featureState,
                      ),
                    ),
                  ),
                );
              });
        });
  }
}

class Features extends StatelessWidget {
  const Features({
    super.key,
    required this.features,
    this.backgroundColor,
    this.color,
  });

  final FeatureState features;
  final Color? backgroundColor;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 4.0,
      runSpacing: 4.0,
      children: List.generate(features.features.length, (index) {
        final feature = features.features[index];

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
    super.key,
    required this.feature,
    required this.backgroundColor,
    this.color,
  });

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
        style: Theme.of(context).textTheme.displaySmall!.copyWith(
            fontSize: 11,
            fontWeight: FontWeight.w300,
            overflow: TextOverflow.ellipsis),
        softWrap: false,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}
