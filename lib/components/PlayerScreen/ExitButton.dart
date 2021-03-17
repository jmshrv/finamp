import 'package:flutter/material.dart';

class ExitButton extends StatelessWidget {
  const ExitButton({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      iconSize: 36,
      icon: Icon(
        Icons.keyboard_arrow_down,
        color: Colors.white,
      ),
      onPressed: () => Navigator.of(context).pop(),
    );
  }
}
