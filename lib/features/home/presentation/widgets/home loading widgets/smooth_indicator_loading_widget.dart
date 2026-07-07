
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class SmoothIndicatorLoadingWidget extends StatelessWidget {
  const SmoothIndicatorLoadingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return AnimatedSmoothIndicator(
      activeIndex: 1,
      count: 3,

      effect: ExpandingDotsEffect(
        dotWidth: 10,
        dotHeight: 10,
        activeDotColor: const Color.fromRGBO(236, 237, 237, 1),
        dotColor: const Color.fromRGBO(236, 237, 237, .5),

      ),
      onDotClicked: (index) {

      },
    );
  }
}
