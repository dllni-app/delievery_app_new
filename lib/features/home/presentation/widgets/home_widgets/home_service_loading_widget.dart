// import 'package:evowash_user_flutter_app/common/extensions/extensions.dart';
// import 'package:flutter/material.dart';
// import 'package:shimmer/shimmer.dart';
//
// class HomeServiceLoadingWidget extends StatelessWidget {
//   const HomeServiceLoadingWidget({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return ListView.builder(
//       scrollDirection: Axis.horizontal,
//       itemCount: 5,
//       itemBuilder: (context, index) {
//         return Container(
//           margin: const EdgeInsets.symmetric(horizontal: 8),
//           child: Column(
//             children: [
//               // الشيمر للأيقونة
//               Shimmer.fromColors(
//                 baseColor: const Color.fromRGBO(236, 237, 237, .5),
//                 highlightColor: const Color.fromRGBO(236, 237, 237, 1),
//                 child: Container(
//                   decoration: BoxDecoration(
//                     borderRadius: BorderRadius.circular(16),
//                     gradient: LinearGradient(
//                       colors: [
//                         Color.fromRGBO(40, 160, 242, 1),
//                         Color.fromRGBO(22, 89, 193, 1),
//                       ],
//                       begin: Alignment.topCenter,
//                       end: Alignment.bottomCenter,
//                     ),
//                   ),
//                   width: context.width * .155,
//                   height: context.width * .155,
//                   padding: const EdgeInsets.all(3),
//                   child: Container(
//                     padding: const EdgeInsets.symmetric(vertical: 16),
//                     decoration: BoxDecoration(
//                       borderRadius: BorderRadius.circular(16),
//                       color: Colors.white,
//                     ),
//                   ),
//                 ),
//               ),
//
//               const SizedBox(height: 4),
//
//               // الشيمر للنص
//               Shimmer.fromColors(
//                 baseColor: const Color.fromRGBO(236, 237, 237, .5),
//                 highlightColor: const Color.fromRGBO(236, 237, 237, 1),
//                 child: Container(
//                   width: context.width * .2,
//                   height: 20,
//                   decoration: BoxDecoration(
//                     color: Colors.white,
//                     borderRadius: BorderRadius.circular(8),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         );
//       },
//     );
//
//   }
// }
