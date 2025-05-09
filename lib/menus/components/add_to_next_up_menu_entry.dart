import 'package:finamp/components/global_snackbar.dart';
import 'package:finamp/l10n/app_localizations.dart';
import 'package:finamp/menus/components/menu_entry.dart';
import 'package:finamp/models/finamp_models.dart';
import 'package:finamp/models/jellyfin_models.dart';
import 'package:finamp/services/downloads_service.dart';
import 'package:finamp/services/feedback_helper.dart';
import 'package:finamp/services/finamp_settings_helper.dart';
import 'package:finamp/services/item_helper.dart';
import 'package:finamp/services/jellyfin_api_helper.dart';
import 'package:finamp/services/queue_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:get_it/get_it.dart';

class AddToNextUpMenuEntry extends ConsumerWidget {
  final BaseItemDto baseItem;

  const AddToNextUpMenuEntry({
    super.key,
    required this.baseItem,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final jellyfinApiHelper = GetIt.instance<JellyfinApiHelper>();
    final downloadsService = GetIt.instance<DownloadsService>();
    final queueService = GetIt.instance<QueueService>();

    return MenuEntry(
      icon: TablerIcons.corner_right_down_double,
      title: AppLocalizations.of(context)!.addToNextUp,
      onTap: () async {
        try {
          FeedbackHelper.feedback(FeedbackType.selection);

          await queueService.addToNextUp(
              items: ref
                      .watch(loadChildTracksProvider(
                        baseItem: baseItem,
                      ))
                      .value ??
                  [],
              source: QueueItemSource(
                type: QueueItemSourceType.nextUpAlbum,
                name: QueueItemSourceName(
                    type: QueueItemSourceNameType.preTranslated,
                    pretranslatedName: baseItem.name ??
                        AppLocalizations.of(context)!.placeholderSource),
                id: baseItem.id,
                item: baseItem,
                contextNormalizationGain: baseItem.normalizationGain,
              ));

          GlobalSnackbar.message(
              (scaffold) => AppLocalizations.of(scaffold)!
                  .confirmAddToNextUp(BaseItemDtoType.fromItem(baseItem).name),
              isConfirmation: true);
          Navigator.pop(context);
        } catch (e) {
          GlobalSnackbar.error(e);
        }
      },
    );
  }
}
