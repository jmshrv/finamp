import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../models/finamp_models.dart';
import '../../../services/finamp_settings_helper.dart';

class HideTabToggle extends ConsumerWidget {
  const HideTabToggle({
    super.key,
    required this.index,
    required this.tabContentType,
  });

  final TabContentType tabContentType;
  final int index;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SwitchListTile.adaptive(
      title: Text(tabContentType.toLocalisedString(context)),
      secondary: ReorderableDragStartListener(
        index: index,
        child: const Icon(Icons.drag_handle),
      ),
      // This should never be null, but it gets set to true if it is.
      value: ref.watch(finampSettingsProvider
              .select((value) => value.value?.showTabs[tabContentType])) ??
          true,
      onChanged: (value) =>
          FinampSettingsHelper.setShowTab(tabContentType, value),
    );
  }
}
