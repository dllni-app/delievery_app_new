// import 'package:carousel_slider/carousel_slider.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:smooth_page_indicator/smooth_page_indicator.dart';
// import '../../../../../common/design/src/theme/const.dart';
// import '../../../../../common/design/src/widgets/cach_network_image.dart';
// import '../../../../../common/extensions/src/context_extensions.dart';
// import '../../../../../common/helper/src/locale_keys.dart';
// import '../../../../banners/presentation/bloc/banners_bloc.dart';
// import '../home loading widgets/carousel_slider_loading_widget.dart';
//
// class HomeBannersWidget extends StatefulWidget {
//   final BannersBloc bannersBloc;
//   final CarouselSliderController _carouselController;
//
//   const HomeBannersWidget({
//     super.key,
//     required this.bannersBloc,
//     required CarouselSliderController carouselController,
//   }) : _carouselController = carouselController;
//
//   @override
//   State<HomeBannersWidget> createState() => _HomeBannersWidgetState();
// }
//
// class _HomeBannersWidgetState extends State<HomeBannersWidget> {
//   late final ValueNotifier<int> currentIndex;
//
//   @override
//   void initState() {
//     currentIndex = ValueNotifier(0);
//
//     // TODO: implement initState
//     super.initState();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return SizedBox(
//       height: context.width * .5,
//
//       child: BlocBuilder<BannersBloc, BannersState>(
//         bloc: widget.bannersBloc,
//         builder: (context, state) {
//           return state.getAllBannersData.builder(
//             onSuccess: (_) {
//               return SizedBox(
//                 width: context.width,
//                 child: Stack(
//                   alignment: AlignmentDirectional.center,
//                   children: [
//                     CarouselSlider.builder(
//                       carouselController: widget._carouselController,
//                       itemCount: state.getAllBannersData.data!.data!.length,
//                       itemBuilder:
//                           (
//                             BuildContext context,
//                             int itemIndex,
//                             int pageViewIndex,
//                           ) {
//                             return Container(
//                               width: context.width,
//
//                               alignment: Alignment.center,
//                               decoration: BoxDecoration(
//                                 color: Color.fromRGBO(221, 221, 221, 1),
//                                 borderRadius: BorderRadius.circular(16),
//                               ),
//                               child: CacheNetworkImage(
//                                 imageUrl: state
//                                     .getAllBannersData
//                                     .data!
//                                     .data![itemIndex]
//                                     .images!
//                                     .original!,
//                                 borderRadius: BorderRadius.circular(16),
//                               ),
//                             );
//                           },
//                       options: CarouselOptions(
//                         viewportFraction: 1,
//                         initialPage: 0,
//                         enableInfiniteScroll: true,
//                         enlargeCenterPage: false,
//                         autoPlay: true,
//                         autoPlayInterval: const Duration(seconds: 3),
//                         autoPlayAnimationDuration: const Duration(
//                           milliseconds: 800,
//                         ),
//                         autoPlayCurve: Curves.fastOutSlowIn,
//
//                         onPageChanged: (index, reason) {
//                           setState(() {
//                             currentIndex.value = index;
//                           });
//                         },
//                       ),
//                     ),
//                     Align(
//                       alignment: AlignmentDirectional.bottomCenter,
//                       child: Padding(
//                         padding: const EdgeInsets.only(bottom: 16),
//                         child: ValueListenableBuilder(
//                           valueListenable: currentIndex,
//                           builder: (context, value, child) {
//                             return AnimatedSmoothIndicator(
//                               activeIndex: value,
//                               count: state.getAllBannersData.data!.data!.length,
//
//                               effect: WormEffect(
//                                 dotWidth: 10,
//                                 dotHeight: 10,
//                                 activeDotColor: Colors.white,
//                                 dotColor:  Colors.white.withOpacity(.4),
//                               ),
//                               onDotClicked: (index) {
//                                 widget._carouselController.animateToPage(index);
//                               },
//                             );
//                           },
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               );
//             },
//             failedWidget: Column(
//               children: [
//                 Text(
//                   state.getAllBannersData.errorMessage,
//                   style: context.bodySmall(fontSize: 16),
//                   textAlign: TextAlign.center,
//                 ),
//                 Space.vM4,
//                 SizedBox(
//                   width: context.width * .7,
//                   child: ElevatedButton(
//                     onPressed: () {
//                       widget.bannersBloc.add(GetBannersEvent());
//                     },
//                     child: Text(LocaleKeys.retry.tr(),style: context.bodyMedium(
//                       color: Colors.white
//                     ),),
//                   ),
//                 ),
//               ],
//             ),
//             loadingWidget: CarouselSliderLoadingWidget(),
//           );
//         },
//       ),
//     );
//   }
// }
