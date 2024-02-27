import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:flutter_vibrate/flutter_vibrate.dart';
import 'package:get_it/get_it.dart';

import 'package:finamp/services/queue_service.dart';
import '../../services/finamp_settings_helper.dart';
import 'preset_chip.dart';

final _queueService = GetIt.instance<QueueService>();
final presets = [0.5, 0.75, 1.0, 1.25, 1.5, 1.75, 2.0, 2.5, 3.0];

class SpeedSlider extends StatefulWidget {
  const SpeedSlider({
    Key? key,
    required this.iconColor,
    required this.saveSpeedInput,
  }) : super(key: key);

  final Color iconColor;
  final Function saveSpeedInput;

  @override
  State<SpeedSlider> createState() => _SpeedSliderState();
}

class _SpeedSliderState extends State<SpeedSlider> {
  double? _dragValue;

  @override
  Widget build(BuildContext context) {
    return SliderTheme(
      data: SliderTheme.of(context).copyWith(
        thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 10),
        trackHeight: 8.0,
        inactiveTrackColor: widget.iconColor.withOpacity(0.35),
        activeTrackColor: widget.iconColor.withOpacity(0.6),
        showValueIndicator: ShowValueIndicator.always,
        valueIndicatorColor: Color.lerp(Colors.black, widget.iconColor, 0.1),
        valueIndicatorTextStyle: Theme.of(context).textTheme.labelLarge,
        valueIndicatorShape: const RectangularSliderValueIndicatorShape(),
      ),
      child: ExcludeSemantics(
        child: Slider(
          min: 0.20,
          max: 5.00,
          value:
              _dragValue ?? FinampSettingsHelper.finampSettings.playbackSpeed,
          onChanged: (value) {
            value = (value / 0.05).round() * 0.05;
            setState(() {
              _dragValue = value;
            });
          },
          onChangeStart: (value) {
            value = (value / 0.05).round() * 0.05;
            setState(() {
              _dragValue = value;
            });
          },
          onChangeEnd: (value) {
            _dragValue = null;
            value = (value / 0.05).round() * 0.05;
            widget.saveSpeedInput(value);
          },
          label:
              (_dragValue ?? FinampSettingsHelper.finampSettings.playbackSpeed)
                  .toStringAsFixed(2),
        ),
      ),
    );
  }
}

class SpeedMenu extends StatefulWidget {
  const SpeedMenu({
    Key? key,
    required this.iconColor,
    this.scrollFunction,
  }) : super(key: key);

  final Color iconColor;
  final Function()? scrollFunction;

  @override
  State<SpeedMenu> createState() => _SpeedMenuState();
}

class _SpeedMenuState extends State<SpeedMenu> {
  final _textController = TextEditingController(
      text: FinampSettingsHelper.finampSettings.playbackSpeed.toString());
  final _settingsListener = FinampSettingsHelper.finampSettingsListener;

  InputDecoration inputFieldDecoration() {
    return InputDecoration(
      filled: true,
      fillColor: widget.iconColor.withOpacity(0.1),
      contentPadding:
          const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
      label: Center(child: Text(AppLocalizations.of(context)!.speed)),
      floatingLabelBehavior: FloatingLabelBehavior.never,
      constraints: const BoxConstraints(
        maxWidth: 82,
        maxHeight: 40,
      ),
      isDense: true,
      border: OutlineInputBorder(
        borderSide: BorderSide.none,
        borderRadius: BorderRadius.circular(16),
      ),
    );
  }

  void saveSpeedInput(double value) {
    final valueDouble = (min(max(value, 0), 5) * 100).roundToDouble() / 100;

    _queueService.setPlaybackSpeed(valueDouble);
    setState(() {});

    refreshInputText();
  }

  void refreshInputText() {
    _textController.text =
        FinampSettingsHelper.finampSettings.playbackSpeed.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: widget.iconColor.withOpacity(0.1),
      ),
      margin: EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
      child: Padding(
        padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
        child: ValueListenableBuilder(
          valueListenable: _settingsListener,
          builder: (BuildContext builder, value, Widget? child) {
            _textController.text =
                FinampSettingsHelper.finampSettings.playbackSpeed.toString();
            return Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                    padding: EdgeInsets.symmetric(horizontal: 12.0),
                    child: PresetChips(
                      type: PresetTypes.speed,
                      mainColour: widget.iconColor,
                      values: presets,
                      activeValue:
                          FinampSettingsHelper.finampSettings.playbackSpeed,
                    )),
                Padding(
                  padding: EdgeInsets.only(top: 6.0),
                  child: SpeedSlider(
                    iconColor: widget.iconColor,
                    saveSpeedInput: saveSpeedInput,
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
