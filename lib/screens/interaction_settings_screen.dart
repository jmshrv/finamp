import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../components/InteractionSettingsScreen/FastScrollSelector.dart';
import '../components/InteractionSettingsScreen/disable_gestures.dart';
import '../components/InteractionSettingsScreen/disable_vibration.dart';
import '../components/InteractionSettingsScreen/swipe_insert_queue_next_selector.dart';

class InteractionSettingsScreen extends StatelessWidget {
  const InteractionSettingsScreen({Key? key}) : super(key: key);

  static const routeName = "/settings/interactions";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.interactions),
      ),
      body: ListView(
        children: const [
          SwipeInsertQueueNextSelector(),
          FastScrollSelector(),
          DisableGestureSelector(),
          DisableVibrationSelector(),
        ],
      ),
    );
  }
}
