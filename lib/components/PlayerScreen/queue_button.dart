import 'package:finamp/components/Buttons/simple_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';

import 'queue_list.dart';

class QueueButton extends StatelessWidget {
  const QueueButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SimpleButton(
        text: AppLocalizations.of(context)!.queue,
        icon: TablerIcons.playlist,
        onPressed: () {
          showQueueBottomSheet(context);
        });
  }
}
