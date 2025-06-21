import 'package:finamp/components/Buttons/simple_button.dart';
import 'package:finamp/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';

import 'queue_list.dart';

class QueueButton extends ConsumerWidget {
  const QueueButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SimpleButton(
      text: AppLocalizations.of(context)!.queue,
      icon: TablerIcons.playlist,
      onPressed: () {
        showQueueBottomSheet(context, ref);
      },
    );
  }
}
