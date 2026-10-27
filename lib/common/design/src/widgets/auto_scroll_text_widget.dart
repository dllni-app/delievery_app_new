import 'package:flutter/material.dart';
import 'package:marquee/marquee.dart';

TextStyle _resolveCairoStyle(BuildContext context, TextStyle? style) =>
    DefaultTextStyle.of(
      context,
    ).style.merge(style).copyWith(fontFamily: 'Cairo');

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
    final resolvedStyle = _resolveCairoStyle(context, style);
    final textPainter = TextPainter(
      text: TextSpan(text: text, style: resolvedStyle),
      maxLines: 1,
      textDirection: TextDirection.rtl,
      textScaler: MediaQuery.textScalerOf(context),
    )..layout();

    final needsScroll = width.isFinite && textPainter.width > width;
    final textHeight = textPainter.height;
    textPainter.dispose();

    return SizedBox(
      width: width,
      height: textHeight,
      child: needsScroll
          ? Marquee(
              text: text,
              style: resolvedStyle,
              textDirection: TextDirection.rtl,
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
              style: resolvedStyle,
              textDirection: TextDirection.rtl,
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
    final resolvedStyle = _resolveCairoStyle(context, style);
    return LayoutBuilder(
      builder: (context, constraints) {
        final maxWidth = constraints.maxWidth;

        final textPainter = TextPainter(
          text: TextSpan(text: text, style: resolvedStyle),
          maxLines: 1,
          textDirection: textDirection,
          textScaler: MediaQuery.textScalerOf(context),
        )..layout();

        final textWidth = textPainter.width;
        final needsScroll = maxWidth.isFinite && textWidth > maxWidth;
        final textHeight = textPainter.height;
        textPainter.dispose();

        return SizedBox(
          height: textHeight,
          child: needsScroll
              ? Marquee(
                  text: text,
                  style: resolvedStyle,
                  textDirection: textDirection,
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
                  style: resolvedStyle,
                  textDirection: textDirection,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
        );
      },
    );
  }
}
