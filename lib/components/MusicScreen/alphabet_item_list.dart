import 'package:finamp/models/jellyfin_models.dart';
import 'package:flutter/material.dart';

class AlphabetList extends StatefulWidget {
  final Function(String) callback;

  final String sortOrder;

  const AlphabetList({super.key, required this.callback, required this.sortOrder});

  @override
  State<AlphabetList> createState() => _AlphabetListState();
}

class _AlphabetListState extends State<AlphabetList> {
  List<String> alphabet = ['#'] +
      List.generate(26, (int index) {
        return String.fromCharCode('A'.codeUnitAt(0) + index);
      });


  List<String> get getAlphabet => alphabet;

  @override
  void initState() {
    orderTheList(alphabet);
    super.initState();
  }


  @override
  void didUpdateWidget(AlphabetList oldWidget) {
    orderTheList(alphabet);
    super.didUpdateWidget(oldWidget);
  }

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

  void orderTheList(List<String> list) {
    widget.sortOrder == "Ascending"
        ? list.sort()
        : list.sort((a, b) => b.compareTo(a));
  }
}
