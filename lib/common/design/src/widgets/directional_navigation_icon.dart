import 'package:flutter/material.dart';

enum NavigationArrowPurpose { back, forward }

/// Mirrors only the arrow direction while preserving the supplied glyph.
class DirectionalNavigationIcon extends StatelessWidget {
  const DirectionalNavigationIcon({
    super.key,
    required this.purpose,
    required this.child,
    required this.childPointsRight,
  });

  final NavigationArrowPurpose purpose;
  final Widget child;
  final bool childPointsRight;

  @override
  Widget build(BuildContext context) {
    final isRtl = Directionality.of(context) == TextDirection.rtl;
    final targetPointsRight = purpose == NavigationArrowPurpose.back
        ? isRtl
        : !isRtl;
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Transform.flip(
        flipX: childPointsRight != targetPointsRight,
        child: child,
      ),
    );
  }
}
