import 'package:flutter/material.dart';
import 'package:marquee/marquee.dart';

class AutoScrollTextWidget extends StatelessWidget {
  final String text;
  final TextStyle? style;
  final double width;
  final double blankSpace;
  final double velocity;
  final Duration pauseAfterRound;
  final double startPadding;

  const AutoScrollTextWidget({
    Key? key,
    required this.text,
    required this.style,
    required this.width,
    this.blankSpace = 20.0,
    this.velocity = 50.0,
    this.pauseAfterRound = const Duration(seconds: 1),
    this.startPadding = 0.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textPainter = TextPainter(
      text: TextSpan(text: text, style: style),
      maxLines: 1,
      textDirection: TextDirection.rtl,
    )..layout();

    bool needsScroll = textPainter.width > width;

    return SizedBox(
      width: width,
      height: style!.fontSize != null ? style!.fontSize! + 8 : 24,
      child: needsScroll
          ? Marquee(
        text: text,
        style: style,
        scrollAxis: Axis.horizontal,
        blankSpace: blankSpace,
        velocity: velocity,
        pauseAfterRound: pauseAfterRound,
        startPadding: startPadding,
        accelerationDuration: const Duration(seconds: 1),
        accelerationCurve: Curves.linear,
        decelerationDuration: const Duration(milliseconds: 500),
        decelerationCurve: Curves.easeOut,
      )
          : Text(
        text,
        style: style,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}



class FlexibleAutoScrollText extends StatelessWidget {
  final String text;
  final TextStyle? style;
  final double blankSpace;
  final double velocity;
  final Duration pauseAfterRound;
  final double startPadding;
  final TextDirection textDirection;

  const FlexibleAutoScrollText({
    Key? key,
    required this.text,
    this.style,
    this.blankSpace = 20.0,
    this.velocity = 50.0,
    this.pauseAfterRound = const Duration(seconds: 1),
    this.startPadding = 0.0,
    this.textDirection = TextDirection.rtl,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final maxWidth = constraints.maxWidth;

        final textPainter = TextPainter(
          text: TextSpan(text: text, style: style),
          maxLines: 1,
          textDirection: textDirection,
        )..layout();

        final textWidth = textPainter.width;
        final needsScroll = textWidth > maxWidth;

        return SizedBox(
          height: textPainter.height,
          child: needsScroll
              ? Marquee(
            text: text,
            style: style,
            scrollAxis: Axis.horizontal,
            blankSpace: blankSpace,
            velocity: velocity,
            pauseAfterRound: pauseAfterRound,
            startPadding: startPadding,
            accelerationDuration: const Duration(seconds: 1),
            accelerationCurve: Curves.linear,
            decelerationDuration: const Duration(milliseconds: 500),
            decelerationCurve: Curves.easeOut,
          )
              : Text(
            text,
            style: style,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        );
      },
    );
  }
}