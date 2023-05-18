import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
import 'package:audio_service/audio_service.dart';
import 'package:palette_generator/palette_generator.dart';

import '../../models/jellyfin_models.dart' as jellyfin_models;
import '../../models/finamp_models.dart';
import 'package:finamp/services/queue_service.dart';
import '../../to_contrast.dart';

class PlayerScreenAppBarTitle extends StatefulWidget {

  const PlayerScreenAppBarTitle({Key? key}) : super(key: key);

  @override
  State<PlayerScreenAppBarTitle> createState() => _PlayerScreenAppBarTitleState();
}

class _PlayerScreenAppBarTitleState extends State<PlayerScreenAppBarTitle> {
  final QueueService _queueService = GetIt.instance<QueueService>();

  @override
  Widget build(BuildContext context) {

    final currentTrackStream = _queueService.getCurrentTrackStream();

    return StreamBuilder<QueueItem?>(
      stream: currentTrackStream,
      initialData: _queueService.getCurrentTrack(),
      builder: (context, snapshot) {
        final queueItem = snapshot.data!;

        return Baseline(
          baselineType: TextBaseline.alphabetic,
          baseline: 0,
          child: Column(
            children: [
              Text(
                "Playing From ${queueItem.source.type.name}",
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w300,
                  color: Colors.white.withOpacity(0.7),
                ),
              ),
              const Padding(padding: EdgeInsets.symmetric(vertical: 2)),
              Text(
                queueItem.source.name,
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
