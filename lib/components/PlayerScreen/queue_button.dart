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
    if (MediaQuery.sizeOf(context).height > 400) {
      return IconButton(
          icon: const Icon(TablerIcons.playlist),
          visualDensity: const VisualDensity(horizontal: -4, vertical: -4),
          tooltip: AppLocalizations.of(context)!.queue,
          onPressed: () {
            showQueueBottomSheet(context);
          });
    } else {
      return const SizedBox.shrink();
    }
  }
}
