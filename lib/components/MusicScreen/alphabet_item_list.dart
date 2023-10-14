import 'package:finamp/models/jellyfin_models.dart';
import 'package:flutter/material.dart';

class AlphabetList extends StatefulWidget {
  final Function(String) callback;
  final List<BaseItemDto>? items;

  const AlphabetList({super.key, required this.callback, this.items});

  @override
  State<AlphabetList> createState() => _AlphabetListState();
}

class _AlphabetListState extends State<AlphabetList> {
  // List<String> alphabet = ['#'] +
  //     List.generate(26, (int index) {
  //       return String.fromCharCode('A'.codeUnitAt(0) + index);
  //     });
  List<String> alphabet = [];


  List<String> get getAlphabet => alphabet;

  @override
  void initState() {
    fulfillLetterWithItemsDisplayed([]);
    super.initState();
  }


  @override
  void didUpdateWidget(AlphabetList oldWidget) {
    if(widget.items != null && oldWidget.items != null) {
      List<BaseItemDto> allElements = [];
      allElements.addAll(oldWidget.items!);
      allElements.addAll(widget.items!);
      fulfillLetterWithItemsDisplayed(allElements);
    }
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

  void fulfillLetterWithItemsDisplayed(List<BaseItemDto>? list) {
    Set<String> letters = <String>{};
    List<BaseItemDto>? elements = list != null && list.isNotEmpty ? list:widget.items;
    if(elements != null) {
      for (BaseItemDto item in elements) {
        if (item.name != null && item.name!.isNotEmpty) {
          RegExp isALetter = RegExp('[A-Z]');
          String firstLetter = item.name![0].toUpperCase();
          if(isALetter.hasMatch(firstLetter)){
            letters.add(firstLetter);
          }
          else {
            letters.add('#');
          }
        }
      }
    }
    if (letters.isNotEmpty) {
      setState(() {
        alphabet = letters.toList();
      });
    }
  }
}
