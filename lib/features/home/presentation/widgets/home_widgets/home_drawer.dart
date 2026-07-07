// import 'package:flutter/material.dart';
// import 'package:u_bau/common/extensions/extensions.dart';
// import 'package:u_bau/common/helper/helper.dart';
// import 'package:u_bau/features/auth/presentation/bloc/auth_bloc.dart';
// import 'package:u_bau/router/app_router.dart';
// import '../../../../common/design/src/widgets/dialog.dart';
// import '../../../../common/design/src/widgets/my_text.dart';
//
// class HomeDrawerWidget extends StatelessWidget {
//   final AuthBloc authBloc;
//
//   const HomeDrawerWidget({super.key, required this.authBloc});
//
//   @override
//   Widget build(BuildContext context) {
//     //  final lang=context.locale.languageCode;
//     final user = AppVariables.user;
//     return Column(
//       children: [
//         Stack(
//           alignment: Alignment.center,
//           children: [
//             Container(
//               color: context.primaryColor,
//               width: double.infinity,
//               height: context.height * .17,
//             ),
//             Column(
//               children: [
//                 Center(
//                   child: SizedBox(
//                       width: context.width * .25,
//                       child: ClipOval(child: Image.network(user.photo!))),
//                 ),
//                 SizedBox(
//                   height: context.height * .01,
//                 ),
//                 Center(
//                     child: MyText(
//                         text: user.name!,
//                         color: Colors.white,
//                         size: 18,
//                         font: FontWeight.w400))
//               ],
//             ),
//           ],
//         ),
//         ExpansionTile(
//           title: const MyText(
//               text: 'Account',
//               color: Colors.black,
//               size: 18,
//               font: FontWeight.w400),
//           collapsedIconColor: context.primaryColor,
//           children: [
//             ListTile(
//               title: const MyText(
//                   text: 'Profile',
//                   color: Colors.black,
//                   size: 18,
//                   font: FontWeight.w400),
//               onTap: () {
//                 context.pushNamed(RouteName.profile);
//               },
//               leading: const Icon(Icons.account_circle_outlined),
//             ),
//             ListTile(
//               title: const MyText(
//                   text: 'Update Profile',
//                   color: Colors.black,
//                   size: 18,
//                   font: FontWeight.w400),
//               onTap: () {
//                 context.pushNamed(RouteName.updateProfile);
//               },
//               leading: const Icon(Icons.update),
//             )
//           ],
//         ),
//         ExpansionTile(
//           title: const MyText(
//               text: 'privacy',
//               color: Colors.black,
//               size: 18,
//               font: FontWeight.w400),
//           collapsedIconColor: context.primaryColor,
//           children: [
//             // ListTile(
//             //   title: const MyText(
//             //       text: 'Reset Password',
//             //       color: Colors.black,
//             //       size: 18,
//             //       font: FontWeight.w400),
//             //   onTap: () {
//             //     // Navigator.of(context).push(MaterialPageRoute(builder: (_) {
//             //     //   return ResetPasswordPage();
//             //     // }));
//             //   },
//             //   leading: const Icon(Icons.change_circle_outlined),
//             // ),
//             // ListTile(
//             //   title: const MyText(
//             //       text: 'Update Password',
//             //       color: Colors.black,
//             //       size: 18,
//             //       font: FontWeight.w400),
//             //   onTap: () {},
//             //   leading: const Icon(Icons.update),
//             // ),
//             ListTile(
//               title: const MyText(
//                   text: 'Delete My Account',
//                   color: Colors.black,
//                   size: 18,
//                   font: FontWeight.w400),
//               onTap: () {
//                 showAlertDialog(
//                   context: context,
//                   title: 'Delete Account',
//                   subTitle: 'Are u sure u want to delete your account for ever',
//                   fun: () async {
//                     authBloc.add(DeleteMeEvent());
//                   },
//                   titleColor: Colors.red,
//                   actionButColor: Colors.red,);
//               },
//               leading: const Icon(Icons.delete_outline),
//             )
//           ],
//         ),
//         // Switch(value:val , onChanged: (val){
//         //
//         //   if(lang=='en'){
//         //     context.setLocale(const Locale('ar'));
//         //   }else{context.setLocale(const Locale('en'));}
//         //
//         //
//         //
//         // }
//
//
//         ListTile(
//           title: const MyText(
//               text: 'Sign Out',
//               color: Colors.black,
//               size: 18,
//               font: FontWeight.w400),
//           onTap: () {
//             showAlertDialog(context: context,
//                 title: 'Sign Out',
//                 subTitle: 'Are u sure u want to sign out',
//                 fun: () async {
//                   HelperFunc.logout();
//                   context.pushReplacementNamed(RouteName.splash);
//                 },
//                 titleColor: Colors.red,
//                 actionButColor: Colors.red);
//           },
//           leading: const Icon(Icons.logout),
//         ),
//       ],
//     );
//   }
// }
