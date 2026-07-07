// import 'package:evowash_user_flutter_app/common/extensions/extensions.dart';
// import 'package:flutter/material.dart';
// import '../../../../common/design/src/widgets/gradiant_widgets/gradient_widget.dart';
// import '../../../../common/design/src/widgets/svg_asset.dart';
//
// class CategoryWidget extends StatefulWidget {
//   final String name;
//   final String svgImage;
//   final int index;
//   final ValueNotifier<int> valueNotifier;
//
//   const CategoryWidget({
//     super.key,
//     required this.name,
//     required this.svgImage,
//     required this.index,
//     required this.valueNotifier,
//   });
//
//   @override
//   State<CategoryWidget> createState() => _CategoryWidgetState();
// }
//
// class _CategoryWidgetState extends State<CategoryWidget> {
//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       child: ValueListenableBuilder(
//         valueListenable: widget.valueNotifier,
//         builder: (BuildContext context, value, Widget? child) {
//           return  GradientWidget(
//             borderRadius: BorderRadius.circular(10),
//             isSecond: value==widget.index?true :false,
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//               children: [
//                 SvgAsset(widget.svgImage),
//                 Text(widget.name, style: context.textTheme.titleMedium!.copyWith(
//                   fontWeight: FontWeight.w900,
//                   fontSize: 10
//                 )),
//               ],
//             ),
//           );
//         },
//       ),
//       onTap: () {
//         widget.valueNotifier.value = widget.index;
//       },
//     );
//   }
// }
