// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:u_bau/common/design/src/widgets/awesomeDialog.dart';
// import 'package:u_bau/common/helper/helper.dart';
// import 'package:u_bau/common/extensions/extensions.dart';
// import 'package:u_bau/core/di/injection.dart';
// import 'package:u_bau/features/home/presentation/cubit/home_cubit.dart';
// import '../../../../common/design/src/theme/theme.dart';
// import '../../../../common/design/src/widgets/app_text_field.dart';
// import '../../../../common/design/src/widgets/my_text.dart';
// import '../../../../common/extensions/src/image_provider.dart';
// import '../../../auth/domain/use_cases/update_me_use_case.dart';
// import '../../../auth/presentation/bloc/auth_bloc.dart';
//
// class UpdateBodyWidget extends StatefulWidget {
//   final AuthBloc authBloc;
//
//   const UpdateBodyWidget({super.key, required this.authBloc});
//
//   @override
//   State<UpdateBodyWidget> createState() => _UpdateBodyWidgetState();
// }
//
// class _UpdateBodyWidgetState extends State<UpdateBodyWidget> {
//   final user = AppVariables.user;
//   late final TextEditingController t1;
//   late final TextEditingController t2;
//
//   late final HomeCubit
//       homeCubit; // Keep the file here for display after image selection
//   // Keep the file here for display after image selection
//
//   final GlobalKey<FormState> _globalKey = GlobalKey();
//
//   @override
//   void initState() {
//     homeCubit = HomeCubit();
//     t1 = TextEditingController(text: user.name);
//     t2 = TextEditingController(text: user.email);
//     super.initState();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return BlocConsumer<HomeCubit, HomeState>(
//       bloc: homeCubit,
//       listener: (context, state) {
//         if (state.file == null) {
//           print("File deleted successfully");
//         }
//         if (state.file != null) {
//           print("File is not null");
//         }
//         // TODO: implement listener
//       },
//       builder: (context, state) {
//         return Scaffold(
//           appBar: AppBar(   elevation: 0,
//             shadowColor: Colors.transparent,
//             title: const MyText(
//               text: 'Update Profile',
//               color: Colors.white,
//               font: FontWeight.w300,
//               size: 18,
//             ),
//           ),
//           body: SingleChildScrollView(
//             child: Form(
//               key: _globalKey,
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Container(
//                     width: double.infinity,
//                     height: context.height * .16,
//                     decoration: BoxDecoration(
//                       color: context.theme.primaryColor,
//                       borderRadius: const BorderRadius.only(
//                         bottomLeft: Radius.circular(80),
//                         bottomRight: Radius.circular(80),
//                       ),
//                       boxShadow: const [
//                         BoxShadow(
//                           color: Color.fromRGBO(0, 0, 0, 0.5),
//                           blurRadius: 15, // Soften the shadow
//                           spreadRadius: 0, // Extend the shadow
//                           offset: Offset(
//                             0, // Move to right 5 horizontally
//                             4.0, // Move to bottom 5 vertically
//                           ),
//                         )
//                       ],
//                     ),
//                     child: Align(
//                       alignment: const Alignment(0, 7),
//                       child: GestureDetector(
//                         onTap: () async {
//                           final val = await picky();
//                           homeCubit.changeFile(val);
//                         },
//                         child: ClipOval(
//                           child: SizedBox(
//                             width: context.width * .35,
//                             // Set the desired size of the circular image
//                             height: context.height * .15,
//                             child: state.file == null
//                                 ? Image.network(
//                                     AppVariables.user.photo!,
//                                     fit: BoxFit
//                                         .cover, // Ensure the image fits the circular container
//                                   )
//                                 : Image.file(
//                                     state.file!,
//                                     fit: BoxFit
//                                         .cover, // Ensure the selected file fits the circular container
//                                   ),
//                           ),
//                         ),
//                       ),
//                     ),
//                   ),
//                   Padding(
//                     padding: const EdgeInsets.only(top: 30),
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         Padding(
//                           padding: const EdgeInsets.only(right: 8.0),
//                           child: Icon(
//                             Icons.edit,
//                             color: context.theme.primaryColor,
//                             size: 20,
//                           ),
//                         ),
//                         MyText(
//                           text: "Edit Profile Image",
//                           size: 18,
//                           color: context.theme.primaryColor,
//                           font: FontWeight.w300,
//                         )
//                       ],
//                     ),
//                   ),
//                   Container(
//                     margin: const EdgeInsets.only(
//                         top: 30, left: 20, right: 20, bottom: 30),
//                     child: Column(
//                       mainAxisAlignment: MainAxisAlignment.start,
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Padding(
//                           padding: const EdgeInsets.symmetric(vertical:  12.0),
//                           child: MyText(
//                               text: 'Edit Account Name :',
//                               color: context.theme.primaryColor,
//                               size: 18,
//                               font: FontWeight.w300),
//                         ),
//                         AppTextField(
//                           prefixIcon: const Icon(
//                             Icons.person,
//
//                           ),
//                           labelText: 'Name',
//                           controller: t1,
//                           validator: (text) => text.isNotShortText,
//                           isPadding: false,
//                         ),
//                         Padding(
//                           padding: const EdgeInsets.symmetric(vertical:  12.0),
//                           child: MyText(
//                               text: 'Edit Account Email :',
//                               color: context.theme.primaryColor,
//                               size: 18,
//                               font: FontWeight.w300),
//                         ),
//                         AppTextField(
//                           isPassword: true,
//                           labelText: 'Email',
//                           controller: t2,
//                           validator: (text) => text.isValidEmail,
//                           isPadding: false,
//                         ),
//                       ],
//                     ),
//                   ),
//                   Divider(
//                     height: 2,
//                     color: context.theme.primaryColor,
//                   ),
//                   Center(
//                     child: Container(
//                       width: 170,
//                       height: 60,
//                       padding: const EdgeInsets.only(top: 12.0),
//                       child: ElevatedButton(
//                         onPressed: () {
//                           if (state.file == null) {
//                           } else {
//                             widget.authBloc.add(UpdateMeEvent(
//                                 params: UpdateMeParams(
//                                     name: t1.text,
//                                     email: t2.text,
//                                     photo: state.file!)));
//                           }
//                         },
//                         style: ButtonStyle(),
//                         child: const Row(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: [
//                             Icon(
//                               Icons.edit,
//                               color: Colors.white,
//                               size: 25,
//                             ),
//                             MyText(
//                               text: 'Update',
//                               color: Colors.white,
//                               size: 20,
//                               font: FontWeight.w500,
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         );
//       },
//     );
//   }
//
//   Future<File?> picky() async {
//     File? fileImage;
//     ImageProviderHelper imageProviderHelper = ImageProviderHelper();
//     fileImage = await imageProviderHelper.pickImageFromGallery();
//
//     if (fileImage != null) {
//       return fileImage;
//     } else {
//       print("No images selected.");
//     }
//   }
// }
