//
// import 'package:evowash_user_flutter_app/common/extensions/extensions.dart';
// import 'package:flutter/material.dart';
//
// import '../../../../common/design/src/widgets/shimmer_widget.dart';
// import '../../../../common/helper/src/locale_keys.dart';
// import '../../../service/presentation/widgets/washing_loading_widget.dart';
//
// class AccessoryLoadingWidget extends StatelessWidget {
//   const AccessoryLoadingWidget({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         Padding(
//           padding: EdgeInsets.symmetric(horizontal: 20),
//           child: Row(
//
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Text(
//                 LocaleKeys.navBarAccessories.tr(),
//                 style: context.labelSmall(
//                   fontSize: 20,
//                   fontFamily: "Nasaq",
//                 ),
//               ),
//               ShimmerTextWidget(
//                 width: context.width*.2,
//                 height: context.width*.07,
//                 borderRadius: BorderRadius.circular(4),
//               )
//             ],
//           ),
//         ),
//         ListView.builder(
//           padding: const EdgeInsets.symmetric(
//             vertical: 16,
//             horizontal: 20,
//           ),
//
//
//           itemCount: 2,
//           itemBuilder: (context, index) {
//             return ShimmerWashingWidget();
//           },
//           shrinkWrap: true,
//           physics: NeverScrollableScrollPhysics(),
//         ),
//       ],
//     );
//   }
// }
