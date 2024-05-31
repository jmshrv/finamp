import 'package:flutter/material.dart';

class ScrollingText extends StatefulWidget {
  final String text;
  final TextStyle? style;
  final double blankSpace;
  final double velocity;
  final Duration pauseDuration;
  final int maxLines;

  const ScrollingText({
    Key? key,
    required this.text,
    this.style,
    this.blankSpace = 20.0,
    this.velocity = 25.0,
    this.pauseDuration = const Duration(seconds: 3),
    this.maxLines = 1,
  }) : super(key: key);
s
  @override
  _ScrollingTextState createState() => _ScrollingTextState();
}

class _ScrollingTextState extends State<ScrollingText>
    with TickerProviderStateMixin {
  late ScrollController _scrollController;
  late AnimationController _animationController;
  late double _textWidth;
  late double _containerWidth;
  late double _animationDistance;
  final Duration extraScrollDuration = const Duration(milliseconds: 450);

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _animationController = AnimationController(vsync: this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _startScrolling();
    });
  }

  @override
  void didUpdateWidget(covariant ScrollingText oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.text != widget.text) {
      _resetAndStartScrolling();
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  void _resetAndStartScrolling() {
    _animationController.stop();
    _scrollController.jumpTo(0.0);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _startScrolling();
    });
  }

  void _startScrolling() {
    if (!_scrollController.hasClients) return;

    _scrollController.jumpTo(0.0);
    final totalDistance = _animationDistance +
        (widget.velocity * extraScrollDuration.inMilliseconds / 1000);
    final totalDuration = Duration(
        milliseconds: (totalDistance / widget.velocity * 1000).toInt());

    Future.delayed(widget.pauseDuration, () {
      if (!_scrollController.hasClients) return;
      _animationController.duration = totalDuration;
      _animationController.forward(from: 0.0).then((_) {
        if (_scrollController.hasClients) {
          _scrollController.jumpTo(0.0);
          _startScrolling();
        }
      });

      _animationController.addListener(() {
        if (_scrollController.hasClients) {
          _scrollController.jumpTo(_animationController.value * totalDistance);
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final textPainter = TextPainter(
          text: TextSpan(
            text: widget.text,
            style: widget.style,
          ),
          maxLines: widget.maxLines,
          textDirection: TextDirection.ltr,
        )..layout(maxWidth: double.infinity);

        _textWidth = textPainter.width;
        _containerWidth = constraints.maxWidth;
        _animationDistance = _textWidth + widget.blankSpace;

        if (_textWidth <= _containerWidth && widget.maxLines == 1) {
          return Text(widget.text, style: widget.style);
        }

        return SingleChildScrollView(
          controller: _scrollController,
          scrollDirection: Axis.horizontal,
          physics: const NeverScrollableScrollPhysics(),
          child: Row(
            children: [
              Text(widget.text, style: widget.style),
              SizedBox(width: widget.blankSpace),
              Text(widget.text, style: widget.style),
            ],
          ),
        );
      },
    );
  }
}
