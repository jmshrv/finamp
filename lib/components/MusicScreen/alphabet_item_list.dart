import 'package:finamp/models/jellyfin_models.dart';
import 'package:flutter/material.dart';

class AlphabetList extends StatefulWidget {
  final Function(String) callback;
  final List<BaseItemDto>? items;

  final String sortOrder;

  const AlphabetList({super.key, required this.callback, this.items, required this.sortOrder});

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
          RegExp startWithThe = RegExp('^the', caseSensitive: false);
          String firstLetter = item.name![0].toUpperCase();
          // Rare edge case, songs and artists that start with "the" than are
          // not supposed to have. We ignore them as Jellyfin does to have
          // a correct order of letters
          if(item.name!.startsWith(startWithThe)){
            List<String> split = item.name!.split(startWithThe);
            firstLetter = split[1].trim()[0];
          }
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
      List<String> listOfLetters = letters.toList();
      orderTheList(listOfLetters);
      setState(() {
        alphabet = listOfLetters;
      });
    }
  }

  void orderTheList(List<String> list) {
    widget.sortOrder == "Ascending"
        ? list.sort()
        : list.sort((a, b) => b.compareTo(a));
  }
}
