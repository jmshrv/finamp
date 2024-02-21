import 'dart:math';
import 'package:flutter/material.dart';
import 'package:finamp/services/queue_service.dart';
import 'package:get_it/get_it.dart';

const _radius = Radius.circular(4);
const _borderRadius = BorderRadius.all(_radius);
const _height = 36.0;
final _defaultBackgroundColour = Colors.white.withOpacity(0.1);

enum PresetTypes {
  speed,
}

class PresetChips extends StatefulWidget {
  const PresetChips({
    Key? key,
    required this.type,
    required this.values,
    required this.activeValue,
    this.onTap,
    this.mainColour,
    this.onPresetSelected,
  }) : super(key: key);

  final PresetTypes type;

  final List<double> values;
  final double activeValue;
  final Function()? onTap;
  final Color? mainColour; // used for different background colours
  final Function()? onPresetSelected;

  final chipWidth = 55.0;

  @override
  State<PresetChips> createState() => _PresetChipsState();
}

class _PresetChipsState extends State<PresetChips> {
  final _queueService = GetIt.instance<QueueService>();
  final _controller = ScrollController();
  bool scrolledAlready = false;

  scrollToActivePreset(double currentValue, double maxWidth) {
    if (!_controller.hasClients) return false;
    var offset =
        (widget.chipWidth + 8.0) * widget.values.indexOf(currentValue) -
            maxWidth / 2 +
            widget.chipWidth / 2;

    offset = min(
        max(0, offset), maxWidth - _controller.position.maxScrollExtent + 15);

    _controller.animateTo(
      offset,
      duration: Duration(milliseconds: 350),
      curve: Curves.easeOutCubic,
    );
  }

  generatePresetChip(value, BoxConstraints constraints) {
    // Scroll to the active preset
    if (value == widget.activeValue) {
      if (scrolledAlready) {
        scrollToActivePreset(value, constraints.maxWidth);
      } else {
        Future.delayed(Duration(milliseconds: 200), () {
          scrollToActivePreset(value, constraints.maxWidth);
        });
        scrolledAlready = true;
      }
    }

    var stringValue = "x$value";

    return PresetChip(
      value: stringValue,
      backgroundColour: value == widget.activeValue
          ? widget.mainColour?.withOpacity(0.4)
          : widget.mainColour?.withOpacity(0.1),
      isTextBold: value == 1.0,
      width: widget.chipWidth,
      onTap: () {
        setState(() {});
        _queueService.setPlaybackSpeed(value);
        widget.onPresetSelected?.call();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return SingleChildScrollView(
        controller: _controller,
        scrollDirection: Axis.horizontal,
        child: Wrap(
          spacing: 8.0,
          runSpacing: 8.0,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: List.generate(widget.values.length,
              (index) => generatePresetChip(widget.values[index], constraints)),
        ),
      );
    });
  }
}

class PresetChip extends StatelessWidget {
  const PresetChip({
    Key? key,
    required this.width,
    this.value = "",
    this.onTap,
    this.backgroundColour,
    this.isTextBold,
  }) : super(key: key);

  final double width;
  final String value;
  final void Function()? onTap;
  final Color? backgroundColour;
  final bool? isTextBold;

  @override
  Widget build(BuildContext context) {
    final backgroundColor = backgroundColour ?? _defaultBackgroundColour;
    final color = Theme.of(context).textTheme.bodySmall?.color ?? Colors.white;

    return SizedBox(
      width: width,
      height: _height,
      child: Material(
        color: backgroundColor,
        borderRadius: _borderRadius,
        child: InkWell(
            onTap: onTap,
            borderRadius: _borderRadius,
            child: Center(
              child: Text(
                value,
                style: TextStyle(
                    color: color,
                    overflow: TextOverflow.ellipsis,
                    fontWeight:
                        isTextBold! ? FontWeight.w700 : FontWeight.normal),
                softWrap: false,
              ),
            )),
      ),
    );
  }
}
