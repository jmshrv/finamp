import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../models/finamp_models.dart';
import '../components/TabsSettingsScreen/hide_tab_toggle.dart';

class TabsSettingsScreen extends StatelessWidget {
  const TabsSettingsScreen({Key? key}) : super(key: key);

  static const routeName = "/settings/tabs";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.tabs),
      ),
      body: Scrollbar(
        child: ListView.builder(
          itemCount: TabContentType.values.length,
          itemBuilder: (context, index) {
            return HideTabToggle(tabContentType: TabContentType.values[index]);
          },
        ),
      ),
    );
  }
}
