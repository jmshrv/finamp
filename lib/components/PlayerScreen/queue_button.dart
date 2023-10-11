import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'queue_list.dart';

class QueueButton extends StatelessWidget {
  const QueueButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
        icon: const Icon(Icons.queue_music),
        tooltip: AppLocalizations.of(context)!.queue,
        onPressed: () {
          showModalBottomSheet(
            isScrollControlled: true,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(top: Radius.circular(24.0)),
            ),
            context: context,
            builder: (context) {
              return DraggableScrollableSheet(
                expand: false,
                builder: (context, scrollController) {
                  return QueueList(
                    scrollController: scrollController,
                  );
                },
              );
            },
          );
        });
  }
}
