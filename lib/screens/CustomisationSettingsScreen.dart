import 'package:flutter/material.dart';

import '../models/FinampModels.dart';
import '../components/CustomizationSettingsScreen/HideTabToggle.dart';

class CustomisationSettingsScreen extends StatelessWidget {
  const CustomisationSettingsScreen({Key? key}) : super(key: key);

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
