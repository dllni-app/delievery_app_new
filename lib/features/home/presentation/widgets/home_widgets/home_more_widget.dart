// import 'package:evowash_user_flutter_app/common/extensions/extensions.dart';
// import 'package:flutter/material.dart';
// import '../../../../common/design/src/widgets/gradiant_widgets/gradient_widget.dart';
// import '../../../../common/helper/src/locale_keys.dart';
//
// class HomeMoreWidget extends StatelessWidget {
//   const HomeMoreWidget({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return SliverToBoxAdapter(
//       child: Padding(
//         padding: const EdgeInsets.symmetric(vertical: 8.0),
//         child: Row(
//           children: [
//             Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   LocaleKeys.homeRecommended.tr(),
//                   style: context.textTheme.headlineMedium!.copyWith(
//                     fontWeight: FontWeight.w900,
//                     fontSize: 14,
//                   ),
//                 ),
//                 Text(
//                   LocaleKeys.homeDependOn.tr(),
//                   style: context.textTheme.bodySmall!.copyWith(
//                     fontSize: 10,
//                     fontWeight: FontWeight.w400,
//                   ),
//                 ),
//               ],
//             ),
//             Spacer(),
//             GradientWidget(
//               borderRadius: BorderRadius.circular(500),
//               child: Container(
//                 padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 24),
//                 child: Text(
//                   LocaleKeys.homeMore.tr(),
//                   style: context.textTheme.titleSmall!.copyWith(
//                     fontWeight: FontWeight.w800,
//                     fontSize: 10,
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
