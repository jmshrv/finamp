import 'dart:io';

import 'package:finamp/components/InteractionSettingsScreen/disable_vibration.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../components/InteractionSettingsScreen/swipe_insert_queue_next_selector.dart';
import '../components/InteractionSettingsScreen/FastScrollSelector.dart';
import '../components/InteractionSettingsScreen/disable_gestures.dart';

class InteractionSettingsScreen extends StatelessWidget {
  const InteractionSettingsScreen({Key? key}) : super(key: key);

  static const routeName = "/settings/interactions";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.interactions),
      ),
      body: Scrollbar(
        child: ListView(
          children: [
            const SwipeInsertQueueNextSelector(),
            const FastScrollSelector(),
            const DisableGestureSelector(),
            const DisableVibrationSelector(),
          ],
        ),
      ),
    );
  }
}
