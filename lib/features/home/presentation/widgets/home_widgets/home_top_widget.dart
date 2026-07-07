// import 'package:evowash_user_flutter_app/common/extensions/extensions.dart';
// import 'package:flutter/material.dart';
// import '../../../../common/design/src/theme/assets.gen.dart';
// import '../../../../common/design/src/widgets/gradiant_widgets/gradient_widget.dart';
// import '../../../../common/design/src/widgets/svg_asset.dart';
// import '../../../../common/helper/src/locale_keys.dart';
//
// class HomeTopWidget extends StatelessWidget {
//   const HomeTopWidget({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return SliverToBoxAdapter(
//       child: Padding(
//         padding: EdgeInsetsDirectional.only(top: context.height * .04,bottom: 14),
//         child: Row(
//           children: [
//           ClipOval(
//               child: Assets.images.jpg.logo.image(
//                 height: context.width * .1,
//                 fit: BoxFit.cover,
//               ),),
//             Padding(
//               padding:  EdgeInsetsDirectional.only(start: 8),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//
//                   Text(
//                         ' ${LocaleKeys.homeHello.tr()} , Ahmad Kake',
//                         style: context.textTheme.labelMedium!.copyWith(
//                           fontWeight: FontWeight.w900,
//                           fontSize: 16
//                         ),
//                       ),
//                   Row(
//
//                         children: [
//                           Icon(Icons.location_on, color: context.primarySwatch),
//                           Text(
//                             'Location',
//                             style: context.textTheme.headlineSmall!.copyWith(
//                               color: context.primarySwatch,
//                               fontSize: 12,
//                               fontWeight: FontWeight.w600
//                             ),
//                           ),
//                         ],
//                       ),
//                 ],
//               ),
//             ),
//               Spacer(),
//               Row(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               GradientWidget(
//                 boxShape: BoxShape.circle,
//                 width: context.width * .1,
//                 child: Padding(
//                   padding: const EdgeInsets.all(10.0),
//                   child: Center(
//                     child: SvgAsset(
//                       Assets.icons.home.appBar2,
//                       width: 18,
//                       height: 18,
//                     ),
//                   ),
//                 ),
//               ),
//               GradientWidget(
//                 boxShape: BoxShape.circle,
//                 width: context.width * .1,
//                 isSecond: true,
//                 child: Padding(
//                   padding: const EdgeInsets.all(10),
//                   child: Center(
//                     child: SvgAsset(
//                       Assets.icons.home.mail,
//                       width: 18,
//                       height: 18,
//                     ),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//           ],
//         ),
//
//         // child: ListTile(
//         //
//         //   title: Text(
//         //     ' ${LocaleKeys.homeHello.tr()} , Ahmad Kake',
//         //     style: context.textTheme.labelMedium!.copyWith(
//         //       fontWeight: FontWeight.w900,
//         //       fontSize: 16
//         //     ),
//         //   ),
//         //   subtitle: Row(
//         //     children: [
//         //       Icon(Icons.location_on, color: context.primaryColor),
//         //       Text(
//         //         'Location',
//         //         style: context.textTheme.headlineSmall!.copyWith(
//         //           color: context.primaryColor,
//         //           fontSize: 12,
//         //           fontWeight: FontWeight.w600
//         //         ),
//         //       ),
//         //     ],
//         //   ),
//         //   leading: ClipOval(
//         //     child: Assets.images.jpg.logo.image(
//         //       height: context.width * .1,
//         //       fit: BoxFit.cover,
//         //     ),
//         //   ),
//         //   trailing: Row(
//         //     mainAxisSize: MainAxisSize.min,
//         //     children: [
//         //       GradientWidget(
//         //         child: Center(
//         //           child: SvgAsset(
//         //             Assets.icons.home.appBar2,
//         //             width: 18,
//         //             height: 18,
//         //           ),
//         //         ),
//         //         boxShape: BoxShape.circle,
//         //         width: context.width * .1,
//         //       ),
//         //       GradientWidget(
//         //         child: Center(
//         //           child: SvgAsset(
//         //             Assets.icons.home.mail,
//         //             width: 18,
//         //             height: 18,
//         //           ),
//         //         ),
//         //         boxShape: BoxShape.circle,
//         //         width: context.width * .1,
//         //         isSecond: true,
//         //       ),
//         //     ],
//         //   ),
//         // ),
//       ),
//     );
//   }
// }
