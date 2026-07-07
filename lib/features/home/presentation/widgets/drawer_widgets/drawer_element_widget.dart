// import 'package:flutter/material.dart';
// import 'package:gt_express/common/design/src/widgets/animation_widget/animated_scale_widget.dart';
// import 'package:gt_express/common/design/src/widgets/my_custom_widget/rotating_widget.dart';
// import '../../../../../common/design/src/widgets/animation_widget/animated_title_text_widget.dart';
// import '../../../../../common/design/src/widgets/svg_asset.dart';
// import '../../../../../common/extensions/src/context_extensions.dart';
//
// class DrawerElementWidget extends StatelessWidget {
//   final String svgImage;
//   final String title;
//   final  VoidCallback? onTap;
//
//   const DrawerElementWidget({super.key, required this.svgImage, required this.title, this.onTap});
//
//   @override
//   Widget build(BuildContext context) {
//     return InkWell(
//       onTap: onTap,
//       child: Padding(
//         padding: const EdgeInsets.all(20),
//         child: Row(
//           children: [
//             AnimatedScaleWidget(
//               child: SvgAsset(
//                 svgImage,
//                 color: context.navBarSelectedColor,
//               ),
//             ),
//             SizedBox(width: 10),
//             AnimatedTitleTextWidget(
//               child: Text(
//                 title,
//                 style: context.headlineSmall(fontSize: 16),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
