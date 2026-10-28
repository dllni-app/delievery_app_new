import 'package:flutter/material.dart';

import '../directional_navigation_icon.dart';

class FlippableImage extends StatelessWidget {
  final Widget child;

  const FlippableImage({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return DirectionalNavigationIcon(
      purpose: NavigationArrowPurpose.forward,
      childPointsRight: false,
      child: child,
    );
  }
}
