import 'package:flutter/material.dart';

class ConfirmationPromptDialogWithActions extends AlertDialog {
  const ConfirmationPromptDialogWithActions({
    Key? key,
    required this.promptText,
    required this.labels,
    required this.functions,
    required this.onAborted,
  }) : super(key: key);

  final String promptText;
  final List<String> labels;
  final List<void Function()> functions;
  final void Function() onAborted;

  @override
  Widget build(BuildContext context) {
    List<Widget> optionButtons = List.empty(growable: true);

    for (var index = 0; index < labels.length; index++) {
      optionButtons.add(
        Container(
          width: 300,
          padding: const EdgeInsets.all(5.0),
          constraints: const BoxConstraints(
            maxWidth: 300.0
          ),
          child: TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              functions[index]();
            },
            child: Text(
              labels[index],
              textAlign: TextAlign.center,
              softWrap: true
            ))
        ),
      );
    }

    optionButtons.add(
      Container(
        width: 130,
        padding: const EdgeInsets.all(5.0),
        constraints: const BoxConstraints(
          maxWidth: 150.0
        ),
        child: TextButton(
          onPressed: () {
            Navigator.of(context).pop();
            onAborted();
          },
          child: Text(
            "Cancel",
            textAlign: TextAlign.center,
            softWrap: true
          )
        )
      ),
    );

    return AlertDialog(
      buttonPadding: const EdgeInsets.all(0.0),
      contentPadding: const EdgeInsets.all(0.0),
      insetPadding: const EdgeInsets.all(32.0),
      actionsPadding: const EdgeInsets.all(0.0),
      actionsAlignment: MainAxisAlignment.spaceEvenly,
      actionsOverflowAlignment: OverflowBarAlignment.center,
      actionsOverflowDirection: VerticalDirection.down,
      title: Text(
        promptText,
        textAlign: TextAlign.center,
        style: const TextStyle(fontSize: 18),
      ),
      actions: optionButtons,
    );
  }
}
