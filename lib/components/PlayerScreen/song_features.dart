import 'package:finamp/models/finamp_models.dart';
import 'package:finamp/services/queue_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get_it/get_it.dart';
import 'package:rxdart/rxdart.dart';

import '../../models/jellyfin_models.dart';
import '../../screens/artist_screen.dart';
import '../../services/finamp_settings_helper.dart';
import '../../services/jellyfin_api_helper.dart';
import '../album_image.dart';

const _radius = Radius.circular(99);
const _borderRadius = BorderRadius.all(_radius);
const _height = 24.0; // I'm sure this magic number will work on all devices
final _defaultBackgroundColour = Colors.white.withOpacity(0.1);

class AudioFeatureState {
  const AudioFeatureState({
    required this.currentTrack,
    required this.settings,
  });

  final FinampQueueItem? currentTrack;
  final FinampSettings settings;

  get features {
    final features = [];

    if (currentTrack?.item.extras?["downloadedSongJson"] != null) {
      features.add(
        const AudioFeatureProperties(
          text: "Locally Playing",
        ),
      );
    } else {
      if (currentTrack?.item.extras?["shouldTranscode"]) {
        features.add(
          AudioFeatureProperties(
            text: "Transcoding @ ${settings.transcodeBitrate ~/ 1000} kbps",
          ),
        );
      } else {
        features.add(
          //TODO differentiate between direct streaming and direct playing
          // const AudioFeatureProperties(
          //   text: "Direct Streaming",
          // ),
          const AudioFeatureProperties(
            text: "Direct Playing",
          ),
        );
      }
    }

    if (currentTrack?.baseItem?.userData?.playCount != null) {
      features.add(
        AudioFeatureProperties(
          text: "${currentTrack!.baseItem!.userData?.playCount} plays",
        ),
      );
    }

    if (currentTrack?.baseItem?.people?.isNotEmpty == true) {
      currentTrack?.baseItem?.people?.forEach((person) {
        features.add(
          AudioFeatureProperties(
            text: "${person.role}: ${person.name}",
          ),
        );
      });
    }

    //TODO get codec information (from just_audio or Jellyfin)

    return features;
    
  }
}

class AudioFeatureProperties {
  const AudioFeatureProperties({
    required this.text,
  });

  final String text;
}

class SongAudioFeatures extends StatelessWidget {

  const SongAudioFeatures({
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
            final featureState = AudioFeatureState(
              currentTrack: snapshot.data,
              settings: settings,
            );
            
            return SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: AudioFeatures(
                backgroundColor: IconTheme.of(context).color?.withOpacity(0.1) ?? _defaultBackgroundColour,
                features: featureState,
              ),
            );
          }
        );
      }
    );
  }
}

class AudioFeatures extends StatelessWidget {
  const AudioFeatures({
    Key? key,
    required this.features,
    this.backgroundColor,
    this.color,
  }) : super(key: key);

  final AudioFeatureState features;
  final Color? backgroundColor;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 4.0,
      runSpacing: 4.0,
      children: List.generate(features.features.length ?? 0, (index) {
        final feature = features.features![index];
          
        return _AudioFeatureContent(
          backgroundColor: IconTheme.of(context).color?.withOpacity(0.1) ?? _defaultBackgroundColour,
          feature: feature,
          color: color,
        );
      }),
    );
  }

}

class _AudioFeatureContent extends StatelessWidget {

  const _AudioFeatureContent({
    Key? key,
    required this.feature,
    required this.backgroundColor,
    this.color,
  }) : super(key: key);

  final AudioFeatureProperties feature;
  final Color? backgroundColor;
  final Color? color;

  @override
  Widget build(BuildContext context) {

    return SizedBox(
      height: 24,
      child: Material(
        color: backgroundColor ?? _defaultBackgroundColour,
        borderRadius: _borderRadius,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Center(
              child: Container(
                constraints: const BoxConstraints(maxWidth: 220),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Text(
                    feature.text,
                    style: Theme.of(context).textTheme.bodySmall!.copyWith(
                      fontWeight: FontWeight.w300,
                      overflow: TextOverflow.ellipsis
                    ),
                    softWrap: false,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
