import 'package:flutter/material.dart';

import '../components/ViewSelector/ViewList.dart';

class ViewSelector extends StatelessWidget {
  const ViewSelector({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Select Music Library"),
      ),
      body: ViewList(),
    );
  }
}
