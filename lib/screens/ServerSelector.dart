import 'package:flutter/material.dart';

import '../components/ServerSelector/ServerSelectorForm.dart';

class ServerSelector extends StatelessWidget {
  const ServerSelector({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Select Server"),
      ),
      body: ServerSelectorForm(),
    );
  }
}
