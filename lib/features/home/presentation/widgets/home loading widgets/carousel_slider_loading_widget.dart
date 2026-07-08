
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

import '../../../../../common/design/src/widgets/shimmer_widget.dart';
import '../../../../../common/extensions/src/context_extensions.dart';

class CarouselSliderLoadingWidget extends StatelessWidget {
  const CarouselSliderLoadingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return CarouselSlider.builder(

      itemCount: 3,
      itemBuilder:
          (
          BuildContext context,
          int itemIndex,
          int pageViewIndex,
          ) {
        return Container(
          width: MediaQuery.of(context).size.width,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: Color.fromRGBO(221, 221, 221, 1),
            borderRadius: BorderRadius.circular(16),
          ),
          child: ShimmerWidget(
            borderRadius: BorderRadius.circular(16),
          ),
        );
      },
      options: CarouselOptions(
          height: MediaQuery.of(context).size.width*.5,
        viewportFraction: 1,
        initialPage: 0,
        enableInfiniteScroll: true,
        enlargeCenterPage: false,

        onPageChanged: (index, reason) {

        },
      ),
    );
  }
}
