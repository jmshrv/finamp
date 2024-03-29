import 'package:finamp/models/jellyfin_models.dart';
import 'package:finamp/services/vibration_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vibrate/flutter_vibrate.dart';

class AlphabetList extends StatefulWidget {
  final Function(String) callback;

  final SortOrder sortOrder;

  const AlphabetList(
      {super.key, required this.callback, required this.sortOrder});

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
    return Container(
      alignment: Alignment.centerRight,
      child: SingleChildScrollView(
        padding: EdgeInsets.only(
          right: 2,
          bottom: MediaQuery.paddingOf(context).bottom,
        ),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              alphabet.length,
              (x) => InkWell(
                onTap: () {
                  VibrationHelper.feedback(FeedbackType.heavy);
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
    );
  }

  void orderTheList(List<String> list) {
    widget.sortOrder == SortOrder.ascending
        ? list.sort()
        : list.sort((a, b) => b.compareTo(a));
  }
}
