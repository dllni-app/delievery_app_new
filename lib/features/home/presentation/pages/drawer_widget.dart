// import 'package:flutter/material.dart';
// import 'package:gt_express/common/design/src/widgets/animation_widget/animated_scale_widget.dart';
// import 'package:gt_express/common/helper/helper.dart';
// import '../../../../common/design/src/theme/assets.gen.dart';
// import '../../../../common/extensions/src/context_extensions.dart';
// import '../../../../core/di/injection.dart';
// import '../../../auth/presentation/bloc/auth_bloc.dart';
// import '../cubit/home_cubit.dart';
// import '../widgets/drawer_widgets/drawer_contact_us_widget.dart';
// import '../widgets/drawer_widgets/drawer_element_widget.dart';
// import '../widgets/drawer_widgets/drawer_lang_expansion_widget.dart';
// import '../widgets/drawer_widgets/log_out_widget.dart';
//
// class DrawerWidget extends StatefulWidget {
//   final HomeCubit homeCubit;
//
//   const DrawerWidget({super.key, required this.homeCubit});
//
//   @override
//   State<DrawerWidget> createState() => _DrawerWidgetState();
// }
//
// class _DrawerWidgetState extends State<DrawerWidget> {
//   late final AuthBloc authBloc;
//   late final ValueNotifier<bool> isArabic;
//
//   @override
//   void initState() {
//     isArabic = ValueNotifier(AppVariables.getCurrentLang()=='ar'?true:false);
//
//     authBloc = getIt<AuthBloc>();
//
//     // TODO: implement initState
//     super.initState();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Drawer(
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           SizedBox(height: MediaQuery.of(context).padding.top + 20),
//           SizedBox(height: context.height * .01),
//           Padding(
//             padding: EdgeInsets.symmetric(horizontal: 30),
//
//             child: Align(
//               alignment: Alignment.center,
//               child: AnimatedScaleWidget(
//                 child: Text(
//                   AppVariables.user.name??LocaleKeys.nullText.tr(),
//                   style: context.headlineMedium(fontSize: 22),
//                   textAlign: TextAlign.center,
//                 ),
//               ),
//             ),
//           ),
//           Padding(
//             padding: EdgeInsets.symmetric(horizontal: 30),
//
//             child: Align(
//               alignment: Alignment.center,
//               child: AnimatedScaleWidget(
//                 child: Text(
//                   AppVariables.user.email??LocaleKeys.nullText.tr(),
//                   style: context.bodyMedium(
//                     fontSize: 16,
//                     color: context.textSubColor,
//                   ),
//                   textAlign: TextAlign.center,
//                 ),
//               ),
//             ),
//           ),
//
//           Divider(height: 48, color: context.dividerColor),
//           Expanded(
//             child: SingleChildScrollView(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Padding(
//                     padding: EdgeInsetsDirectional.only(start: 20),
//                     child: Text(
//                       LocaleKeys.drawerList.tr(),
//                       style: context.bodySmall(fontSize: 16),
//                     ),
//                   ),
//                   SizedBox(height: 20),
//                   DrawerElementWidget(
//                     svgImage:   Assets.images.svg.navBar.home,
//                     title:LocaleKeys.navBarHome.tr(),
//                     onTap: (){
//                       context.pop();
//                       widget.homeCubit.changeIndex(0);
//                       // context.pushNamed(
//                       //   RouteName.userCars,
//                       //   arguments: UserCarsParams(),
//                       // );
//                     },
//                   ),
//                   DrawerElementWidget(
//                     svgImage:  Assets.images.svg.navBar.servises,
//                     title: LocaleKeys.navBarService.tr(),
//                     onTap: (){
//                       context.pop();
//                       widget.homeCubit.changeIndex(1);
//                     },
//                   ),
//                   DrawerElementWidget(
//                     svgImage:   Assets.images.svg.navBar.notifications,
//                     title: LocaleKeys.navBarNotifications.tr(),
//                     onTap: (){
//                       context.pop();
//                       widget.homeCubit.changeIndex(2);
//                     },
//                   ),
//                   DrawerElementWidget(
//                     svgImage: Assets.images.svg.navBar.search,
//                     title: LocaleKeys.navBarInquiries.tr(),
//                     onTap: (){
//                       context.pop();
//                       widget.homeCubit.changeIndex(3);
//                     },
//                   ),
//
//
//
//                   DrawerLangExpansionWidget(
//                   isArabic: isArabic,
//                   ),
//                   DrawerContactUsWidget(),
//                   DeleteAccountWidget(),
//
//
//                 ],
//               ),
//             ),
//           ),
//           Divider(height: 1, color: context.dividerColor),
//
//           LogOutWidget(
//             authBloc: authBloc,
//           )
//         ],
//       ),
//     );
//   }
// }
