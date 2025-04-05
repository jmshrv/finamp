import 'package:finamp/models/finamp_models.dart';
import 'package:flutter/material.dart';
import 'package:finamp/l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';

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
      text: (DefaultSettings.sleepTimerDuration ~/ 60).toString());
  final _formKey = GlobalKey<FormState>();
  // SleepTimerType _selectedMode = SleepTimerType.duration; // Default selection
  int selectedValue = 5; // Default to 5 minutes
  bool trackMode = false;
  final _trackCountController = TextEditingController(text: "1");
  final ScrollController _scrollController = ScrollController();
  late double viewPortWidth;
  bool endOnCurrent = false;
  final markerTotalWidth = 6.0; // 2px line + 4px margin

  void _updateSelectedValue() {
    final offset = _scrollController.offset;
    final centerPosition = offset + (viewPortWidth / 2);
    final nearestItem = ((centerPosition - (viewPortWidth / 2)) / markerTotalWidth).round();
    final nearestValue = nearestItem + 1; // 1-based index

    if (nearestValue != selectedValue && nearestValue > 0 && nearestValue <= 120) {
      setState(() {
        selectedValue = nearestValue;
      });
    }
  }

  void _snapToNearestMarker() {
    final offset = _scrollController.offset;
    final centerPosition = offset + (viewPortWidth / 2);
    final nearestItem = ((centerPosition - (viewPortWidth / 2)) / markerTotalWidth).round();
    // Animate to exact position (centered)
    _scrollController.animateTo(
      (nearestItem * markerTotalWidth) - (viewPortWidth / 2) + (markerTotalWidth * 5), // Center offset
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeOut,
    );
  }

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_updateSelectedValue);
  }

  @override
  Widget build(BuildContext context) {
    viewPortWidth = MediaQuery.of(context).size.width;

    return AlertDialog(
      title: Text(AppLocalizations.of(context)!.setSleepTimer),
      content: SizedBox(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              '$selectedValue ${AppLocalizations.of(context)?.minutes ?? "minute(s)"}',
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
            Stack(
              alignment: Alignment.center,
              children: [
                // Center indicator line
                Container(
                  width: 2,
                  height: 40,
                  color: Theme.of(context).colorScheme.primary.withValues(),
                ),
                // Scrollable list with lines
                NotificationListener<ScrollNotification>(
                  onNotification: (notification) {
                    if (notification is ScrollEndNotification) {
                      _snapToNearestMarker();
                    }
                    return false;
                  },
                  child: SizedBox(
                    height: 60,
                    width: viewPortWidth,
                    child: SingleChildScrollView(
                      controller: _scrollController,
                      scrollDirection: Axis.horizontal,
                      physics: const BouncingScrollPhysics(),
                      child: Row(
                        children: [
                          // TODO: Need a better way to centre/pad the markers
                          SizedBox(width: viewPortWidth / 3),

                          ...List.generate(120, (index) {
                            final isMultipleOf5 = (index + 1) % 5 == 0;
                            final isSelected = index + 1 == selectedValue;

                            return SizedBox(
                              width: markerTotalWidth,
                              height: 50,
                              child: Stack(
                                clipBehavior: Clip.none,
                                alignment: Alignment.topCenter,
                                children: [
                                  // Marker line
                                  Positioned(
                                    top: 0,
                                    child: Container(
                                      width: 2,
                                      height: isMultipleOf5 ? 30 : 20,
                                      color: isSelected
                                          ? Theme.of(context)
                                              .colorScheme
                                              .primary
                                          : const Color.fromARGB(
                                              76, 255, 255, 255),
                                    ),
                                  ),

                                  // Label (for multiples of 5)
                                  if (isMultipleOf5)
                                    Positioned(
                                      top: 32,
                                      left:
                                          -12, // shift left so it's centered visually
                                      child: SizedBox(
                                        width: 30,
                                        child: Text(
                                          '${index + 1}',
                                          textAlign: TextAlign.center,
                                          style: Theme.of(context)
                                              .textTheme
                                              .labelSmall
                                              ?.copyWith(
                                                fontSize: 10,
                                                color: isSelected
                                                    ? Theme.of(context)
                                                        .colorScheme
                                                        .primary
                                                    : Colors.grey[400],
                                              ),
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            );
                          }),

                          SizedBox(width: (viewPortWidth / 3) + markerTotalWidth),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const Divider(),
            Builder(builder: (context) {
              return SwitchListTile.adaptive(
                  title: Text("Number of Tracks"),
                  value: trackMode,
                  onChanged: (value) {
                    setState(() {
                      trackMode = value;
                    });
                  });
            }),
if (trackMode)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: TextFormField(
                  controller: _trackCountController,
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return AppLocalizations.of(context)!.required;
                    }
                    if (int.tryParse(value) == null || int.parse(value) <= 0) {
                      return AppLocalizations.of(context)!.invalidNumber;
                    }
                    return null;
                  },
                ),
              ),


            Builder(builder: (context) {
              return SwitchListTile.adaptive(
                  title: Text("Finish track"),
                  value: endOnCurrent,
                  onChanged: (value) {
                    setState(() {
                      endOnCurrent = value;
                    });
                  });
            })
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
            if (_formKey.currentState?.validate() == true) {
              _formKey.currentState!.save();
              Navigator.of(context).pop();
            }
          },
        )
      ],
    );
  }
}
