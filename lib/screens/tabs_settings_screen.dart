import 'package:finamp/services/finamp_settings_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../components/TabsSettingsScreen/hide_tab_toggle.dart';

class TabsSettingsScreen extends StatefulWidget {
  const TabsSettingsScreen({Key? key}) : super(key: key);

  static const routeName = "/settings/tabs";

  @override
  State<TabsSettingsScreen> createState() => _TabsSettingsScreenState();
}

class _TabsSettingsScreenState extends State<TabsSettingsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.tabs),
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                FinampSettingsHelper.resetTabs();
              });
            },
            icon: const Icon(Icons.refresh),
            tooltip: AppLocalizations.of(context)!.resetTabs,
          )
        ],
      ),
      body: Scrollbar(
        child: ReorderableListView.builder(
          // buildDefaultDragHandles: false,
          itemCount: FinampSettingsHelper.finampSettings.tabOrder.length,
          itemBuilder: (context, index) {
            return HideTabToggle(
              tabContentType:
                  FinampSettingsHelper.finampSettings.tabOrder[index],
              key:
                  ValueKey(FinampSettingsHelper.finampSettings.tabOrder[index]),
            );
          },
          onReorder: (oldIndex, newIndex) {
            // It's a bit of a hack to call setState with no actual widget
            // state, but it saves us from using listeners
            setState(() {
              // For some weird reason newIndex is one above what it should be
              // when oldIndex is lower. This if statement is in Flutter's
              // ReorderableListView documentation.
              if (oldIndex < newIndex) {
                newIndex -= 1;
              }

              final oldValue =
                  FinampSettingsHelper.finampSettings.tabOrder[oldIndex];
              final newValue =
                  FinampSettingsHelper.finampSettings.tabOrder[newIndex];

              FinampSettingsHelper.setTabOrder(oldIndex, newValue);
              FinampSettingsHelper.setTabOrder(newIndex, oldValue);
            });
          },
        ),
      ),
    );
  }
}
