import 'package:flutter/material.dart';

import '../models/FinampModels.dart';
import '../components/TabsSettingsScreen/HideTabToggle.dart';

class TabsSettingsScreen extends StatelessWidget {
  const TabsSettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Customisation"),
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
