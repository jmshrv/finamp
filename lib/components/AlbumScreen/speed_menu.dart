import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:flutter_vibrate/flutter_vibrate.dart';
import 'package:get_it/get_it.dart';

import 'package:finamp/services/queue_service.dart';
import '../../services/finamp_settings_helper.dart';
import '../Buttons/simple_button.dart';
import 'preset_chip.dart';

final _queueService = GetIt.instance<QueueService>();
final presets = [0.5, 0.75, 1.0, 1.25, 1.5, 1.75, 2.0, 2.5, 3.0];

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
  final _formKey = GlobalKey<FormState>();
  final _settingsListener = FinampSettingsHelper.finampSettingsListener;

  InputDecoration inputFieldDecoration() {
    return InputDecoration(
      filled: true,
      fillColor: widget.iconColor.withOpacity(0.1),
      contentPadding:
          const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
      label: Center(child: Text(AppLocalizations.of(context)!.speed)),
      floatingLabelBehavior: FloatingLabelBehavior.never,
      constraints: const BoxConstraints(
        maxWidth: 125,
      ),
      border: OutlineInputBorder(
        borderSide: BorderSide.none,
        borderRadius: BorderRadius.circular(16),
      ),
    );
  }

  void saveSpeedInput(value) {
    final valueDouble =
        (min(max(double.parse(value!), 0), 5) * 100).roundToDouble() / 100;

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
      margin: EdgeInsets.only(top: 10.0, bottom: 10.0, left: 10.0, right: 10.0),
      child: Padding(
        padding: const EdgeInsets.only(top: 12.0, bottom: 12.0),
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
                    padding: EdgeInsets.only(top: 8.0, left: 25.0, right: 25.0),
                    child: Form(
                      key: _formKey,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SimpleButton(
                            text: AppLocalizations.of(context)!.reset,
                            icon: TablerIcons.arrow_back_up_double,
                            iconColor: widget.iconColor,
                            onPressed: () {
                              _queueService.setPlaybackSpeed(1.0);
                            },
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 12.0),
                            child: TextFormField(
                              controller: _textController,
                              keyboardType: TextInputType.number,
                              textAlign: TextAlign.center,
                              decoration: inputFieldDecoration(),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return AppLocalizations.of(context)!.required;
                                }

                                if (double.tryParse(value) == null) {
                                  return AppLocalizations.of(context)!
                                      .invalidNumber;
                                }
                                return null;
                              },
                              onSaved: (value) => saveSpeedInput(value),
                              onFieldSubmitted: (value) =>
                                  saveSpeedInput(value),
                            ),
                          ),
                          child ?? const SizedBox(),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            },
            child: SimpleButton(
              text: AppLocalizations.of(context)!.apply,
              icon: TablerIcons.check,
              iconColor: widget.iconColor,
              onPressed: () {
                if (_formKey.currentState?.validate() == true) {
                  _formKey.currentState!.save();
                }
              },
            )),
      ),
    );
  }
}
