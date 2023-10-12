import 'package:flutter/material.dart';

class AlphabetList extends StatefulWidget {
  final Function(String) callback;

  const AlphabetList({super.key, required this.callback});

  @override
  State<AlphabetList> createState() => _AlphabetListState();
}

class _AlphabetListState extends State<AlphabetList> {
  List<String> alphabet = ['#'] +
      List.generate(26, (int index) {
        return String.fromCharCode('A'.codeUnitAt(0) + index);
      });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 2),
        child: SingleChildScrollView(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                alphabet.length,
                (x) => InkWell(
                  onTap: () {
                    widget.callback(alphabet[x]);
                  },
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                    child: Text(
                      alphabet[x].toUpperCase(),
                    ),
                  ),
                ),
              )),
        ),
      ),
    );
  }
}
