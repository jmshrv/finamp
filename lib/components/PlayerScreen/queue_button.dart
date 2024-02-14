import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'queue_list.dart';

class QueueButton extends StatelessWidget {
  const QueueButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
        icon: const Icon(TablerIcons.playlist),
        tooltip: AppLocalizations.of(context)!.queue,
        onPressed: () {
          showQueueBottomSheet(context);
        });
  }
}
