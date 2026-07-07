// import 'package:evowash_user_flutter_app/common/extensions/extensions.dart';
// import 'package:flutter/material.dart';
// import '../../../../common/design/src/theme/assets.gen.dart';
// import '../../../../common/design/src/widgets/gradiant_widgets/gradient_widget.dart';
// import '../../../../common/design/src/widgets/svg_asset.dart';
// import '../../../../common/helper/src/locale_keys.dart';
//
// class ServiceWidget extends StatelessWidget {
//   const ServiceWidget({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(10),
//         color: Colors.white,
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//
//         children: [
//           ClipRRect(
//             borderRadius: const BorderRadius.only(
//               topRight: Radius.circular(10),
//               topLeft: Radius.circular(10),
//             ),
//             child: Container(
//               decoration: const BoxDecoration(
//                 borderRadius: BorderRadius.only(
//                   topRight: Radius.circular(10),
//                   topLeft: Radius.circular(10),
//                 ),
//               ),
//               clipBehavior: Clip.antiAlias,
//               child: Assets.images.png.word.image(
//                 width: double.infinity,
//                 fit: BoxFit.cover,
//               ),
//             ),
//           ),
//           Padding(
//             padding: EdgeInsetsDirectional.only(start: 8.0),
//             child: Text(
//               'خدمة إصلاح الكهرباء',
//               style: context.textTheme.labelSmall!.copyWith(
//                 fontSize: 10,
//                 fontWeight: FontWeight.w600,
//               ),
//             ),
//           ),
//           Padding(
//             padding: EdgeInsetsDirectional.only(start: 8.0, bottom: 8),
//             child: Row(
//               children: [
//                 Icon(Icons.edit_location, color: Colors.grey,size: 8,),
//                 Padding(
//                   padding: const EdgeInsets.symmetric(horizontal:  4.0),
//                   child: Text(
//                     'كهرباء',
//                     style: context.textTheme.bodySmall!.copyWith(
//                       fontSize: 8,
//                       fontWeight: FontWeight.w500,
//                     ),
//                   ),
//                 ),
//                 Icon(Icons.edit_location, color: Colors.grey,size: 8),
//                 Padding(
//                   padding: const EdgeInsets.symmetric(horizontal: 4.0),
//                   child: Text(
//                     '4.5',
//                     style: context.textTheme.bodySmall!.copyWith(
//                       fontSize: 8,
//                       fontWeight: FontWeight.w500,
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           Padding(
//             padding: const EdgeInsets.only(bottom: 8.0),
//             child: Row(
//               children: [
//                 Expanded(
//                   child: GradientWidget(
//                     borderRadius: BorderRadius.circular(500),
//                     child: Padding(
//                       padding: const EdgeInsets.symmetric(vertical: 8.0),
//                       child: Center(
//                         child: Text(
//                           LocaleKeys.homeOrderNow.tr(),
//                           style: context.textTheme.titleSmall!.copyWith(
//                             fontWeight: FontWeight.w800,
//                             fontSize: 10
//                           ),
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//                 GradientWidget(
//                   boxShape: BoxShape.circle,
//                   width: context.width * .1,
//                   isSecond: true,
//                   child: Padding(
//                     padding: const EdgeInsets.all(10),
//                     child: Center(
//                       child: SvgAsset(
//                         Assets.icons.home.comment,
//                         width: 18,
//                         height: 18,
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
