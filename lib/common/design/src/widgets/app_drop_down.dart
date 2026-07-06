import 'package:flutter/material.dart';

import '../../../extensions/extensions.dart';
import '../../../helper/helper.dart';
import '../../design.dart';
// import 'package:dropdown_button2/dropdown_button2.dart';

// class AppDropDown<T> extends StatelessWidget {
//   const AppDropDown({
//     super.key,
//     this.width,
//     this.hintText,
//     required this.items,
//     required this.onChanged,
//
//     required this.getString,
//     this.value,
//     this.isLoading = false,
//     this.isFaild = false,
//     this.onTapRetry,
//     this.labelText,
//     this.isPadding = true,
//     this.enable = true,
//   });
//
//   final bool isLoading;
//   final bool isFaild;
//   final bool isPadding;
//   final VoidCallback? onTapRetry;
//   final bool enable;
//   final String? hintText;
//   final String? labelText;
//   final double? width;
//   final T? value;
//   final List<T> items;
//   final void Function(T? value) onChanged;
//   final String Function(T value) getString;
//
//   @override
//   Widget build(BuildContext context) {
//     final baseDecoration = const InputDecoration().applyDefaults(
//       Theme
//           .of(context)
//           .inputDecorationTheme,
//     );
//
//     if (isLoading) {
//       return Container(
//         decoration: BoxDecoration(
//           color: context.scaffoldBackgroundColor,
//           borderRadius: BorderRadius.circular(PRadius.container),
//         ),
//         child: ShimmerWidget(
//           width: width ?? context.width * .9,
//           borderRadius: BorderRadius.circular(PRadius.container),
//           height: 48,
//         ),
//       );
//     }
//
//     if (isFaild) {
//       return GestureDetector(
//         onTap: onTapRetry,
//         child: Container(
//           width: width ?? context.width * .9,
//           height: 48,
//           decoration: BoxDecoration(
//             color: context.scaffoldBackgroundColor.withOpacity(.6),
//             borderRadius: BorderRadius.circular(PRadius.container),
//           ),
//           child: const Icon(Icons.refresh),
//         ),
//       );
//     }
//
//     return Container(
//       margin: EdgeInsets.symmetric(
//         vertical: isPadding == true ? context.width * .02 : 0,
//       ),
//       child:DropdownButtonFormField<T>(
//         menuMaxHeight: context.height * .25,
//
//
//         value: items.contains(value) ? value : null,
//         isExpanded: true,
//         icon: SvgAsset(
//           Assets.images.svg.dropDownImage,
//
//         ),
//           decoration: baseDecoration.copyWith(
//             enabled: enable,
//             fillColor: Colors.white,
//             filled: true,
//             hintText: hintText,
//             labelText: labelText,
//             errorStyle: context.headlineSmall(
//               fontSize: 10,
//               fontWeight: FontWeight.w500,
//               color: context.errorColor,
//             ),
//
//             labelStyle: context.headlineSmall(
//               fontSize: 16,
//               color: context.textFieldHintColor,
//
//             ),
//             floatingLabelStyle:  context.headlineSmall(
//               color: context.primarySwatch  ,
//               fontSize: 11,
//             ),
//             contentPadding: const EdgeInsets.all(PPadding.mainPadding * 1.5),
//
//
//           ),
//           validator: (value) =>
//           value == null ? LocaleKeys.validationRequiredfield.tr() : null,
//         onChanged: onChanged,
//         items: items.map((e) {
//           return DropdownMenuItem<T>(
//             value: e,
//             child: Text(
//                           getString(e),
//                           style: context.headlineSmall(
//                             color: context.themeExt.palette.black,
//                             fontSize: 16,
//                           ),
//                           overflow: TextOverflow.ellipsis,
//                           maxLines: 1,
//                         ),
//           );
//         }).toList(),
//         selectedItemBuilder: (context) {
//           return items.map((e) {
//             return Text(
//                         getString(e),
//                         style: context.headlineSmall(
//                           color: context.textColor,
//                           fontSize: 16,
//                         ),);
//           }).toList();
//         },
//
//
//       )
//       // DropdownButtonFormField2<T>(
//       //   selectedItemBuilder: (context) {
//       //     return items.map(
//       //           (element) => Align(
//       //         alignment: AlignmentDirectional.centerStart,
//       //         child: Text(
//       //           getString(element),
//       //           style: context.headlineSmall(
//       //             color: context.textColor,
//       //             fontSize: 16,
//       //           ),
//       //           maxLines: 1,
//       //           overflow: TextOverflow.ellipsis,
//       //         ),
//       //       ),
//       //     ).toList();
//       //   },
//       //   value: items.contains(value) ? value : null,
//       //   isExpanded: true,
//       //   decoration: baseDecoration.copyWith(
//       //     enabled: enable,
//       //     fillColor: Colors.white,
//       //     filled: true,
//       //     hintText: hintText,
//       //     labelText: labelText,
//       //     errorStyle: context.headlineSmall(
//       //       fontSize: 10,
//       //       fontWeight: FontWeight.w500,
//       //       color: context.errorColor,
//       //     ),
//       //
//       //     labelStyle: context.headlineSmall(
//       //       fontSize: 16,
//       //       color: context.textFieldHintColor,
//       //
//       //     ),
//       //     floatingLabelStyle:  context.headlineSmall(
//       //       color: context.primarySwatch  ,
//       //       fontSize: 11,
//       //     ),
//       //     contentPadding: const EdgeInsets.all(PPadding.mainPadding * 1.5),
//       //
//       //
//       //   ),
//       //   dropdownStyleData: DropdownStyleData(
//       //     direction: DropdownDirection.textDirection,
//       //     // ✅ يجعل القائمة دائمًا تحت
//       //     maxHeight: context.height * .25,
//       //     decoration: BoxDecoration(
//       //       color: Colors.white,
//       //       borderRadius: BorderRadius.circular(PRadius.container),
//       //     ),
//       //
//       //   ),
//       //   iconStyleData: IconStyleData(
//       //     icon: SvgAsset(
//       //       Assets.images.svg.dropDownImage,
//       //
//       //     ),
//       //   ),
//       //
//       //
//       //   validator: (value) =>
//       //   value == null ? LocaleKeys.validationRequiredfield.tr() : null,
//       //   items: items
//       //       .map(
//       //         (element) =>
//       //         DropdownMenuItem<T>(
//       //           value: element,
//       //           child: Padding(
//       //             padding: const EdgeInsetsDirectional.only(start:  8.0),
//       //             child: Text(
//       //               getString(element),
//       //               style: context.headlineSmall(
//       //                 color: context.themeExt.palette.black,
//       //                 fontSize: 16,
//       //               ),
//       //               overflow: TextOverflow.ellipsis,
//       //               maxLines: 1,
//       //             ),
//       //           ),
//       //         ),
//       //   )
//       //       .toList(),
//       //   onChanged: onChanged,
//       // ),
//     );
//   }
// }


//
//
// class AppDropDownWithOutBorder<T> extends StatelessWidget {
//   const AppDropDownWithOutBorder({
//     super.key,
//     this.width,
//     this.hintText,
//     required this.items,
//     required this.onChanged,
//     required this.getString,
//     this.value,
//     this.isLoading = false,
//     this.isFaild = false,
//     this.onTapRetry,
//     this.labelText,
//     this.isPadding = true,
//     this.enable = true,
//   });
//
//   final bool isLoading;
//   final bool isFaild;
//   final bool isPadding;
//   final VoidCallback? onTapRetry;
//   final bool enable;
//   final String? hintText;
//   final String? labelText;
//   final double? width;
//   final T? value;
//   final List<T> items;
//   final void Function(T? value) onChanged;
//   final String Function(T value) getString;
//
//   @override
//   Widget build(BuildContext context) {
//     if (isLoading) {
//       return Container(
//         decoration: BoxDecoration(
//           color: context.scaffoldBackgroundColor,
//           borderRadius: BorderRadius.circular(PRadius.container),
//         ),
//         child: ShimmerWidget(
//           width: width ?? context.width * .9,
//           borderRadius: BorderRadius.circular(PRadius.container),
//           height: 48,
//         ),
//       );
//     }
//
//     if (isFaild) {
//       return GestureDetector(
//         onTap: onTapRetry,
//         child: Container(
//           width: width ?? context.width * .9,
//           height: 48,
//           decoration: BoxDecoration(
//             color: context.scaffoldBackgroundColor.withOpacity(.6),
//             borderRadius: BorderRadius.circular(PRadius.container),
//           ),
//           child: const Icon(Icons.refresh),
//         ),
//       );
//     }
//
//     return Container(
//       margin: EdgeInsets.symmetric(
//         vertical: isPadding == true ? context.width * .02 : 0,
//       ),
//       child: DropdownButtonFormField2<T>(
//         isExpanded: true,
//         value: items.contains(value) ? value : null,
//         decoration: const InputDecoration(
//           border: InputBorder.none,
//           enabledBorder: InputBorder.none,
//           focusedBorder: InputBorder.none,
//           disabledBorder: InputBorder.none,
//           errorBorder: InputBorder.none,
//           isDense: true,
//           contentPadding: EdgeInsets.zero,
//         ),
//         hint: hintText == null
//             ? null
//             : Text(
//           hintText!,
//           style: context.headlineSmall(
//             fontSize: 16,
//             color: context.textFieldHintColor,
//           ),
//         ),
//         dropdownStyleData: DropdownStyleData(
//           direction: DropdownDirection.textDirection, // ✅ يظهر تحت فقط
//           maxHeight: context.height * .25,
//           decoration: BoxDecoration(
//             color: Colors.white,
//             borderRadius: BorderRadius.circular(PRadius.container),
//             boxShadow: [
//               BoxShadow(
//                 color: Colors.black12,
//                 blurRadius: 5,
//                 offset: const Offset(0, 3),
//               ),
//             ],
//           ),
//         ),
//         iconStyleData: IconStyleData(
//           icon: SvgAsset(
//             Assets.images.svg.dropDownImage,
//
//           ),
//         ),
//         items: items
//             .map(
//               (element) => DropdownMenuItem<T>(
//             value: element,
//             child: Text(
//               getString(element),
//               style: context.headlineSmall(
//                 fontSize: 16,
//                 color: context.themeExt.palette.black,
//               ),
//             ),
//           ),
//         )
//             .toList(),
//         onChanged: enable ? onChanged : null,
//       ),
//     );
//   }
// }

