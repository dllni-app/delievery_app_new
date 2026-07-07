// import 'package:flutter/material.dart';
// import 'package:gt_express/common/design/design.dart';
// import 'package:gt_express/common/design/src/widgets/animation_widget/animated_scale_widget.dart';
// import 'package:gt_express/common/design/src/widgets/animation_widget/animated_title_text_widget.dart';
// import 'package:gt_express/router/app_router.dart';
//
// import '../../../../../common/design/src/widgets/my_custom_widget/rotating_widget.dart';
// import '../../../../../common/extensions/src/context_extensions.dart';
// import '../../../../../common/helper/src/app_varibles.dart';
// import '../../../../../common/helper/src/helper_func.dart';
// import '../../../../../common/helper/src/locale_keys.dart';
//
// class DrawerLangExpansionWidget extends StatelessWidget {
//   final ValueNotifier<bool> isArabic;
//
//   const DrawerLangExpansionWidget({super.key, required this.isArabic});
//
//   @override
//   Widget build(BuildContext context) {
//     return ExpansionTile(
//       title: Row(
//         crossAxisAlignment: .center,
//         children: [
//           AnimatedScaleWidget(
//             child: Icon(
//               Icons.language_outlined,
//               color: context.navBarSelectedColor,
//               size: 30,
//             ),
//           ),
//           SizedBox(width: 10),
//           AnimatedTitleTextWidget(
//             child: Text(
//               LocaleKeys.profileLanguage.tr(),
//               style: context.headlineSmall(fontSize: 16),
//             ),
//           ),
//         ],
//       ),
//       children: [
//         ValueListenableBuilder(
//           valueListenable: isArabic,
//           builder: (context, value, child) {
//             return InkWell(
//               onTap:
//                   context.isArabic==false?
//                   () {
//                 isArabic.value = true;
//
//                 context.setLocale(const Locale('ar'));
//                 AppVariables.setCurrentLang(context);
//                 HelperFunc.changeLang();
//
//                 context.pushNamedAndRemoveUntil(
//                   RouteName.splash,
//                       (e) => false,
//                 );
//               }:null,
//               child: Row(
//                 children: [
//                   Transform.scale(
//                     scale: 1.5,
//                     child: Checkbox(
//                       value: value,
//                       onChanged: null, // ممنوع الضغط عليه مباشرة
//                     ),
//                   ),
//                   Text(
//                     LocaleKeys.profileArabic.tr(),
//                     style: context.headlineSmall(fontSize: 16),
//                   ),
//                 ],
//               ),
//             );
//           },
//         ),
//         ValueListenableBuilder(
//           valueListenable: isArabic,
//           builder: (context, value, child) {
//             return InkWell(
//               onTap:
//                   context.isArabic==true?
//                   () {
//                 isArabic.value = false;
//
//                 context.setLocale(const Locale('en'));
//                 AppVariables.setCurrentLang(context);
//                 HelperFunc.changeLang();
//
//                 context.pushNamedAndRemoveUntil(
//                   RouteName.splash,
//                       (e) => false,
//                 );
//               }:null,
//               child: Row(
//                 children: [
//                   Transform.scale(
//                     scale: 1.5,
//                     child: Checkbox(
//                       value: !value,
//                       onChanged: null,
//                     ),
//                   ),
//                   Text(
//                     LocaleKeys.profileEnglish.tr(),
//                     style: context.headlineSmall(fontSize: 16),
//                   ),
//                 ],
//               ),
//             );
//           },
//         ),
//       ],
//     );
//   }
// }
//
