import 'dart:async';

import 'package:finamp/models/jellyfin_models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vibrate/flutter_vibrate.dart';

import '../../color_schemes.g.dart';

enum Drag {
  start,
  update,
  end;
}

class AlphabetList extends StatefulWidget {
  final Function(String) callback;

  final SortOrder sortOrder;

  final Widget child;

  const AlphabetList(
      {super.key,
      required this.callback,
      required this.sortOrder,
      required this.child});

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

  String? _currentSelected;
  String? _toBeSelected;
  bool _displayPreview = false;
  double _letterHeight = 20;

  @override
  void didUpdateWidget(AlphabetList oldWidget) {
    orderTheList(alphabet);
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    // This gestureDetector blocks the horizontal drag to switch tabs gesture
    // while dragging on alphabet, but still allows all gestures on main content.
    // I don't know why this works, there's weird interactions between the listener,
    // gestureDetecters, and the stack.
    return GestureDetector(
      onVerticalDragStart: (_) {},
      child: Stack(
        children: [
          widget.child,
          if (_currentSelected != null && _displayPreview)
            Positioned(
              left: 20,
              top: 20,
              child: Container(
                width: MediaQuery.sizeOf(context).width / 3,
                height: MediaQuery.sizeOf(context).width / 3,
                decoration: BoxDecoration(
                    color: Theme.of(context).cardColor.withOpacity(0.85),
                    borderRadius: BorderRadius.circular(20)),
                child: FittedBox(
                    child: Text(_currentSelected!,
                        style: const TextStyle(fontSize: 120))),
              ),
            ),
          Positioned(
            right: 0,
            top: -10,
            bottom: -10,
            child: Container(
              padding: EdgeInsets.only(
                  top: 10,
                  bottom: MediaQuery.paddingOf(context).bottom + 10,
                  right: 3 + MediaQuery.paddingOf(context).right),
              decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(12.0)),
                  boxShadow: [
                    BoxShadow(
                        offset: const Offset(5, 0),
                        blurRadius: 10.0,
                        spreadRadius: 5.0,
                        color: Theme.of(context).brightness == Brightness.light
                            ? darkColorScheme.background.withOpacity(0.15)
                            : darkColorScheme.background.withOpacity(0.7))
                  ]),
              child: LayoutBuilder(builder: (context, constraints) {
                _letterHeight = constraints.maxHeight / alphabet.length;
                return Listener(
                  onPointerDown: (x) =>
                      updateSelected(x.localPosition, Drag.start),
                  onPointerMove: (x) =>
                      updateSelected(x.localPosition, Drag.update),
                  onPointerUp: (x) => updateSelected(x.localPosition, Drag.end),
                  behavior: HitTestBehavior.opaque,
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        alphabet.length,
                        (x) => Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 0),
                          height: _letterHeight,
                          child: FittedBox(
                            child: Text(
                              alphabet[x].toUpperCase(),
                            ),
                          ),
                        ),
                      )),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }

  void updateSelected(Offset position, Drag state) {
    String previousToBeSelected = _toBeSelected ?? '';
    if (position.dx > -20) {
      _toBeSelected = alphabet[
          (position.dy / _letterHeight).floor().clamp(0, alphabet.length - 1)];
      if (previousToBeSelected != _toBeSelected) {
        Vibrate.feedback(FeedbackType.light);
      }
    }

    if (state == Drag.start) {
      setState(() {
        _displayPreview = true;
      });
    }
    if (state == Drag.end && _toBeSelected != null) {
      Vibrate.feedback(FeedbackType.selection);
      widget.callback(_toBeSelected ?? _currentSelected ?? '');
    }

    if (state == Drag.end) {
      Future.delayed(const Duration(milliseconds: 50), () {
        if (mounted) {
          setState(() {
            _displayPreview = false;
            _currentSelected = null;
          });
        }
      });
    } else if (_currentSelected != _toBeSelected) {
      setState(() {
        if (_currentSelected != null) {
          _displayPreview = true;
        }
        _currentSelected = _toBeSelected;
      });
    }
  }

  void orderTheList(List<String> list) {
    widget.sortOrder == SortOrder.ascending
        ? list.sort()
        : list.sort((a, b) => b.compareTo(a));
  }
}
