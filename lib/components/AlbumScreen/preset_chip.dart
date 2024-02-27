import 'dart:math';
import 'package:flutter/material.dart';
import 'package:finamp/services/queue_service.dart';
import 'package:get_it/get_it.dart';

const _radius = Radius.circular(4);
const _borderRadius = BorderRadius.all(_radius);
final _defaultBackgroundColour = Colors.white.withOpacity(0.1);
const _spacing = 8.0;

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
    this.chipWidth = 64.0,
    this.chipHeight = 44.0,
  }) : super(key: key);

  final PresetTypes type;

  final List<double> values;
  final double activeValue;
  final Function()? onTap;
  final Color? mainColour; // used for different background colours
  final Function()? onPresetSelected;
  final double chipWidth;
  final double chipHeight;

  @override
  State<PresetChips> createState() => _PresetChipsState();
}

class _PresetChipsState extends State<PresetChips> {
  final _queueService = GetIt.instance<QueueService>();
  final _controller = ScrollController();
  bool scrolledAlready = false;

  void scrollToActivePreset(double currentValue, double maxWidth) {
    if (!_controller.hasClients) return;
    var offset = widget.chipWidth * widget.values.indexOf(currentValue) +
        widget.chipWidth / 2 -
        maxWidth / 2 -
        _spacing / 2;

    offset = min(max(0, offset),
        widget.chipWidth * (widget.values.length) - maxWidth - _spacing);

    _controller.animateTo(
      offset,
      duration: Duration(milliseconds: 350),
      curve: Curves.easeOutCubic,
    );
  }

  PresetChip generatePresetChip(value, BoxConstraints constraints) {
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

    final stringValue = "x$value";

    return PresetChip(
      value: stringValue,
      backgroundColour:
          widget.mainColour?.withOpacity(value == widget.activeValue
              ? 0.4
              : (value == 1.0)
                  ? 0.2
                  : 0.1),
      isPresetDefault: value == 1.0,
      width: widget.chipWidth,
      height: widget.chipHeight,
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
          spacing: _spacing,
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
    required this.height,
    this.value = "",
    this.onTap,
    this.backgroundColour,
    this.isPresetDefault,
  }) : super(key: key);

  final double width;
  final double height;
  final String value;
  final void Function()? onTap;
  final Color? backgroundColour;
  final bool? isPresetDefault;

  @override
  Widget build(BuildContext context) {
    final backgroundColor = backgroundColour ?? _defaultBackgroundColour;
    final color = Theme.of(context).textTheme.bodySmall?.color ?? Colors.white;

    return TextButton(
      style: TextButton.styleFrom(
        backgroundColor: backgroundColor,
        shape: const RoundedRectangleBorder(borderRadius: _borderRadius),
        minimumSize: Size(width, height),
        padding: const EdgeInsets.symmetric(horizontal: 2.0),
        visualDensity: VisualDensity.compact,
      ),
      onPressed: onTap,
      child: Text(
        value,
        style: TextStyle(
          color: color,
          overflow: TextOverflow.visible,
          fontWeight: isPresetDefault! ? FontWeight.w700 : FontWeight.normal,
        ),
        softWrap: false,
      ),
    );
  }
}
