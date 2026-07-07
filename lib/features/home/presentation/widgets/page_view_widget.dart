// import 'package:flutter/material.dart';
// import 'package:u_bau/common/design/src/theme/theme.dart';
// import 'package:u_bau/common/extensions/extensions.dart';
//
// import '../../../../common/design/src/widgets/svg_asset.dart';
//
// class PageViewPage extends StatelessWidget {
//   final String title;
//   final String smallTitle;
//   final String subTitle;
//   final String image;
//
//   const PageViewPage(
//       {super.key,
//         required this.title,
//         required this.smallTitle,
//         required this.subTitle,
//         required this.image});
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: SizedBox(
//         width: double.infinity,
//         child: Column(
//           children: [
//             Padding(
//               padding: EdgeInsets.only(top: context.height*.1),
//               child: Text(title,
//                   textAlign: TextAlign.center,
//                   style: Theme.of(context).textTheme.headlineLarge),
//             ),
//             Padding(
//               padding: EdgeInsets.only(top: context.height*.01),
//               child: Text(smallTitle,
//                   textAlign: TextAlign.center,
//                   style: Theme.of(context).textTheme.headlineLarge),
//             ),
//             Padding(
//                 padding: EdgeInsets.only(top: context.height*.05),
//                 child: SizedBox(
//                   width: context.width*.7,
//                   child: Text(subTitle,
//                       textAlign: TextAlign.center,
//                       style: Theme.of(context).textTheme.headlineSmall),
//                 )),
//             Padding(
//               padding: EdgeInsets.only(top:context.height*.08),
//               child: Image.asset(
//                 image,
//                 width: context.width*.9,
//                 height: context.height*.35,
//                 fit: BoxFit.fill,
//
//
//               ),
//             ),
//
//           ],
//         ),
//       ),
//     );
//   }
// }