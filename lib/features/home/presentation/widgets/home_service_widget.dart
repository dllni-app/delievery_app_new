// import 'package:flutter/material.dart';
// import '../../../../common/design/src/theme/const.dart';
// import '../../../../common/design/src/widgets/animation_widget/animated_scale_widget.dart';
// import '../../../../common/design/src/widgets/svg_asset.dart';
// import '../../../../common/extensions/src/context_extensions.dart';
//
// class HomeServiceWidget extends StatelessWidget {
//   final String svgImage;
//   final String title;
//   final String subTitle;
//   // final SearchType searchType;
//
//   const HomeServiceWidget(
//       {super.key, required this.svgImage, required this.title, required this.subTitle, required this.searchType});
//
//
//   @override
//   Widget build(BuildContext context) {
//     return Expanded(
//       child: AnimatedScaleWidget(
//         child: InkWell(
//           borderRadius: BorderRadius.circular(16),
//           onTap: () {
//             context.pushNamed(RouteName.search, arguments: SearchScreenParams(
//                 searchType: searchType
//             ));
//           },
//
//           child: Container(
//             padding: EdgeInsets.all(24),
//             decoration: BoxDecoration(
//               color: Colors.white,
//               borderRadius: BorderRadius.circular(16),
//               border: Border.all(color: context.textFieldBorderColor),
//             ),
//             child: Column(
//               children: [
//                 Container(
//                   padding: EdgeInsets.all(12),
//                   margin: EdgeInsets.only(bottom: 8),
//                   decoration: BoxDecoration(
//                     borderRadius: BorderRadius.circular(12),
//
//                     color: context.primarySwatch.withOpacity(.1),
//                   ),
//                   child: SvgAsset(svgImage, color: context.navBarSelectedColor,),
//                 ),
//                 Text(
//                   title,
//                   style: context.headlineSmall(fontSize: 18),
//                   textAlign: TextAlign.center,
//                 ),
//                 Space.vS2,
//                 Text(
//                   subTitle,
//                   style: context.bodyMedium(
//                     color: context.hintColor,
//                     fontSize: 16,
//                   ),
//                   softWrap: true,
//                   textAlign: TextAlign.center,
//
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
