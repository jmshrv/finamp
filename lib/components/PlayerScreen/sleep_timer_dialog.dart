import 'dart:ffi';
import 'dart:math';

import 'package:finamp/components/PlayerScreen/queue_list.dart';
import 'package:finamp/components/print_duration.dart';
import 'package:finamp/models/finamp_models.dart';
import 'package:finamp/services/media_state_stream.dart';
import 'package:finamp/services/progress_state_stream.dart';
import 'package:finamp/services/queue_service.dart';
import 'package:flutter/material.dart';
import 'package:finamp/l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
import 'package:rxdart/rxdart.dart';

import '../../services/finamp_settings_helper.dart';
import '../../services/music_player_background_task.dart';

class SleepTimerDialog extends ConsumerStatefulWidget {
  const SleepTimerDialog({super.key});

  @override
  ConsumerState<SleepTimerDialog> createState() => _SleepTimerDialogState();
}

class _SleepTimerDialogState extends ConsumerState<SleepTimerDialog> {
  final _audioHandler = GetIt.instance<MusicPlayerBackgroundTask>();
  final _textController = TextEditingController(
      text: (DefaultSettings.sleepTimerDurationSeconds ~/ 60).toString());
  final _formKey = GlobalKey<FormState>();
  // SleepTimerType _selectedMode = SleepTimerType.duration; // Default selection
  SleepTimer newSleepTimer = SleepTimer(
      SleepTimerType.duration, DefaultSettings.sleepTimerDurationSeconds);

  final _trackCountController = TextEditingController(text: "2");

  bool durationMode = true;
  bool trackMode = false;
  bool finishTrack = false;
  bool afterCurrentTrack = false;

  void saveSleepTimer() {
    // TODO: do we need this in both locations?
    _audioHandler.startSleepTimer(newSleepTimer);
    FinampSetters.setSleepTimer(newSleepTimer);
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        switchTheme: Theme.of(context).switchTheme.copyWith(
              trackOutlineColor: MaterialStateProperty.all(
                Theme.of(context).colorScheme.primary.withOpacity(0.5),
              ),
            ),
      ),
      child: AlertDialog(
        title: Text(AppLocalizations.of(context)!.setSleepTimer),
        content: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Duration (Minutes) Row
              Row(
                children: [
                  Switch.adaptive(
                    value: durationMode,
                    inactiveThumbColor: Theme.of(context).colorScheme.primary,
                    onChanged: (value) {
                      setState(() {
                        durationMode = value;
                        if (value) {
                          if (newSleepTimer.type != SleepTimerType.duration) {
                            newSleepTimer.type = SleepTimerType.duration;
                          }
                          trackMode = false;
                          afterCurrentTrack = false;
                        } else {
                          finishTrack = false;
                        }
                      });
                    },
                  ),
                  const SizedBox(width: 8),
                  const Text("Minutes"),
                  const Spacer(),
                  SizedBox(
                    width: 80,
                    child: TextFormField(
                      controller: _textController,
                      keyboardType: TextInputType.number,
                      enabled: durationMode,
                      decoration: const InputDecoration(
                        isDense: true,
                      ),
                      onChanged: (value) {
                        if (value.isNotEmpty)
                          newSleepTimer.length =
                              (double.parse(value) * 60).round();
                      },
                      validator: (value) {
                        if (!durationMode &&
                            newSleepTimer.type == SleepTimerType.duration)
                          return AppLocalizations.of(context)!.required;
                        if (!durationMode) return null;

                        if (value == null || value.isEmpty) {
                          return AppLocalizations.of(context)!.required;
                        }
                        if (double.tryParse(value) == null ||
                            double.parse(value) <= 0) {
                          return AppLocalizations.of(context)!.invalidNumber;
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 8),

              // Finish Track Switch (alone)
              Row(
                children: [
                  Switch.adaptive(
                    value: finishTrack,
                    inactiveThumbColor: Theme.of(context).colorScheme.primary,
                    onChanged: (value) {
                      setState(() {
                        finishTrack = value;
                        if (newSleepTimer.type != SleepTimerType.duration) {
                          newSleepTimer.type = SleepTimerType.duration;
                        }
                        if (value) {
                          trackMode = false;
                          afterCurrentTrack = false;
                          durationMode = true;
                        }
                        newSleepTimer.finishTrack = value;
                      });
                    },
                  ),
                  const SizedBox(width: 8),
                  const Text("Finish Track"),
                ],
              ),

              Divider(
                color: Theme.of(context).colorScheme.secondary.withOpacity(0.3),
              ),

              // Tracks Row
              Row(
                children: [
                  Switch.adaptive(
                    value: trackMode,
                    inactiveThumbColor: Theme.of(context).colorScheme.primary,
                    onChanged: (value) {
                      setState(() {
                        trackMode = value;
                        if (newSleepTimer.type != SleepTimerType.tracks)
                          newSleepTimer.type = SleepTimerType.tracks;
                        if (value) {
                          durationMode = false;
                          finishTrack = false;
                          afterCurrentTrack = false;
                          newSleepTimer.length =
                              int.parse(_trackCountController.value.text);
                        }
                      });
                    },
                  ),
                  const SizedBox(width: 8),
                  const Text("Tracks"),
                  const Spacer(),
                  SizedBox(
                    width: 80,
                    child: TextFormField(
                      controller: _trackCountController,
                      keyboardType: TextInputType.number,
                      enabled: trackMode,
                      onChanged: (value) {
                        if (value.isNotEmpty) {
                          setState(() {
                            newSleepTimer.length = int.parse(value);
                          });
                        }
                      },
                      decoration: const InputDecoration(
                        isDense: true,
                      ),
                      validator: (value) {
                        if ((!trackMode && !afterCurrentTrack) &&
                            newSleepTimer.type == SleepTimerType.tracks)
                          return AppLocalizations.of(context)!.required;

                        // TODO: On set, calculate duration from queue?
                        if (!trackMode) return null;
                        if (value == null || value.isEmpty) {
                          return AppLocalizations.of(context)!.required;
                        }
                        if (int.tryParse(value) == null ||
                            int.parse(value) <= 0) {
                          return AppLocalizations.of(context)!.invalidNumber;
                        }
                        return null;
                      },
                    ),
                  )
                ],
              ),
              Divider(
                color: Theme.of(context).colorScheme.secondary.withOpacity(0.3),
              ),
              // Finish Track Switch (alone)
              Row(
                children: [
                  Switch.adaptive(
                    value: afterCurrentTrack,
                    inactiveThumbColor: Theme.of(context).colorScheme.primary,
                    onChanged: (value) {
                      setState(() {
                        afterCurrentTrack = value;
                        if (newSleepTimer.type != SleepTimerType.tracks) {
                          newSleepTimer.type = SleepTimerType.tracks;
                        }
                        if (value) {
                          trackMode = false;
                          durationMode = false;
                          finishTrack = false;
                          newSleepTimer.finishTrack = true;
                          newSleepTimer.length = 1;
                        }
                      });
                    },
                  ),
                  const SizedBox(width: 8),
                  const Text("After current track"),
                ],
              ),
              StreamBuilder(
                  stream: Rx.combineLatest2<ProgressState, FinampQueueInfo?,
                          (ProgressState?, FinampQueueInfo?)>(
                      progressStateStream,
                      GetIt.instance<QueueService>().getQueueStream(),
                      (a, b) => (a, b)),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      ProgressState progressState = snapshot.data!.$1!;
                      FinampQueueInfo queueInfo = snapshot.data!.$2!;
                      Duration currentTrackRemainingDuration =
                          (progressState.mediaItem!.duration! -
                              progressState.position);
                      Duration queueRemainingDuration =
                          queueInfo.remainingDuration;
                      Duration remaining;
                      if (durationMode) {
                        int? finalTrackIndex = queueInfo.getTrackIndexAfter(
                            newSleepTimer.totalDuration -
                                currentTrackRemainingDuration);
                        Duration? durationOfFinalTrack;
                        Duration? durationUntilFinalTrack;
                        Duration? durationUntilEndOfFinalTrack;
                        if (finalTrackIndex != null) {
                          durationOfFinalTrack = queueInfo
                              .fullQueue[finalTrackIndex - 1].item.duration!;
                          durationUntilFinalTrack = newSleepTimer
                                      .totalDuration <
                                  currentTrackRemainingDuration
                              ? Duration.zero
                              : currentTrackRemainingDuration +
                                  queueInfo.getDurationUntil(finalTrackIndex -
                                      queueInfo.currentTrackIndex);
                          durationUntilEndOfFinalTrack = newSleepTimer
                                      .totalDuration <
                                  currentTrackRemainingDuration
                              ? currentTrackRemainingDuration
                              : durationUntilFinalTrack + durationOfFinalTrack;
                        }
                        remaining = finishTrack
                            ? Duration(
                                milliseconds: min(
                                    durationUntilEndOfFinalTrack
                                            ?.inMilliseconds ??
                                        queueRemainingDuration.inMilliseconds,
                                    (queueRemainingDuration +
                                            currentTrackRemainingDuration)
                                        .inMilliseconds))
                            : Duration(
                                milliseconds: min(
                                    newSleepTimer.totalDuration.inMilliseconds,
                                    (queueRemainingDuration +
                                            currentTrackRemainingDuration)
                                        .inMilliseconds));
                      } else if (trackMode) {
                        remaining = currentTrackRemainingDuration +
                            queueInfo.getDurationUntil(newSleepTimer.length);
                      } else if (afterCurrentTrack) {
                        remaining = currentTrackRemainingDuration +
                            queueInfo.getDurationUntil(1);
                      } else {
                        remaining = Duration.zero;
                      }
                      var remainText =
                          printDuration(remaining, leadingZeroes: false);
                      final remainingLabelFullHours = (remaining.inHours);
                      final remainingLabelFullMinutes =
                          (remaining.inMinutes) % 60;
                      final remainingLabelSeconds = (remaining.inSeconds) % 60;
                      final remainingLabelString =
                          "${remainingLabelFullHours > 0 ? "$remainingLabelFullHours ${AppLocalizations.of(context)!.hours} " : ""}${remainingLabelFullMinutes > 0 ? "$remainingLabelFullMinutes ${AppLocalizations.of(context)!.minutes} " : ""}$remainingLabelSeconds ${AppLocalizations.of(context)!.seconds}";
                      return Padding(
                          padding: const EdgeInsets.only(top: 4.0, right: 8.0),
                          child: Text(
                            AppLocalizations.of(context)!
                                .sleepTimerProjectedDuration(remainText),
                            semanticsLabel: AppLocalizations.of(context)!
                                .sleepTimerProjectedDuration(
                                    remainingLabelString),
                            style: Theme.of(context).textTheme.labelSmall,
                          ));
                    }
                    return const SizedBox.shrink();
                  }),
            ],
          ),
        ),
        actions: [
          TextButton(
            child: Text(MaterialLocalizations.of(context).cancelButtonLabel),
            onPressed: () => Navigator.of(context).pop(),
          ),
          TextButton(
            child: Text(MaterialLocalizations.of(context).okButtonLabel),
            onPressed: () {
              if (_formKey.currentState?.validate() ?? false) {
                _formKey.currentState!.save();
                Navigator.of(context).pop();
                saveSleepTimer();
              }
            },
          )
        ],
      ),
    );
  }
}
