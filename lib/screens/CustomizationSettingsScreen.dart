import 'package:finamp/components/CustomizationSettingsScreen/HideTabToggle.dart';
import 'package:flutter/material.dart';

// import '../components/AudioServiceSettingsScreen/StopForegroundSelector.dart';

class CustomizationSettingsScreen extends StatelessWidget {
  const CustomizationSettingsScreen({Key? key}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Customization"),
      ),
      body: Scrollbar(
        child: ListView(
          children: [
            HideTabToggle(tabTitle: "Artists",),
            HideTabToggle(tabTitle: "Albums",),
            HideTabToggle(tabTitle: "Playlists",),
            HideTabToggle(tabTitle: "Songs",)
          ],
        ),
      ),
    );
  }
}
