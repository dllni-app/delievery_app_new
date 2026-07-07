// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:permission_handler/permission_handler.dart';
// import '../../../../common/extensions/src/context_extensions.dart';
// import '../../../../common/extensions/src/image_provider.dart';
// import '../../../../common/helper/src/locale_keys.dart';
// import '../../../../core/di/injection.dart';
// import '../../../../core/permissions/cubit/permissions_cubit.dart';
//
// Future<void>
// buildPickImageSheet({
//   required BuildContext context,
//   required PermissionCubit permissionCubit,
//   required ValueNotifier<File?> valueNotifier,
// })
// async {
//
//   await showModalBottomSheet(
//     context: context,
//     // isScrollControlled: true,
//     // backgroundColor: Colors.transparent,
//     useRootNavigator: true,
//     backgroundColor:  context.scaffoldBackgroundColor,
//     // isDismissible: true,
//     // enableDrag: true,
//     builder: (context) {
//       return Container(
//         decoration: BoxDecoration(
//           color: context.scaffoldBackgroundColor,
//           borderRadius: BorderRadius.only(
//             topLeft: Radius.circular(15),
//             topRight: Radius.circular(15),
//           ),
//         ),
//
//         margin: const EdgeInsets.symmetric(vertical: 20),
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//           children: [
//             Expanded(
//               child: GestureDetector(
//                 onTap: () async {
//                   await _handlePhotosPermission(
//                     context: context,
//                     permissionCubit: permissionCubit,
//                     valueNotifier: valueNotifier,
//                   );
//                 },
//                 child: _buildOption(
//                   context,
//                   icon: Icons.image_outlined,
//                   text: LocaleKeys.fromGallery.tr(),
//                   borderColor: context.primarySwatchOpacity,
//                   isStart: true,
//                 ),
//               ),
//             ),
//
//             // 📸 زر الكاميرا
//             Expanded(
//               child: GestureDetector(
//                 onTap: () async {
//                   await _handleCameraPermission(
//                     context: context,
//                     permissionCubit: permissionCubit,
//                     valueNotifier: valueNotifier,
//                   );
//                 },
//                 child: _buildOption(
//                   context,
//                   icon: Icons.camera_alt_outlined,
//                   text: LocaleKeys.fromCamera.tr(),
//                   borderColor: context.primarySwatch,
//                   isStart: false,
//                 ),
//               ),
//             ),
//           ],
//         ),
//       );
//     },
//   );
// }
//
// Widget _buildOption(
//     BuildContext context, {
//       required IconData icon,
//       required String text,
//       required Color borderColor,
//       required bool isStart,
//     })
// {
//   return Container(
//     margin: EdgeInsetsDirectional.only(
//       top: 12,
//       bottom: 12,
//       start: isStart ? 20 : 10,
//       end: isStart ? 10 : 20,
//     ),
//     height: context.height * .18,
//     decoration: BoxDecoration(
//       borderRadius: BorderRadius.circular(15),
//       border: Border.all(color: borderColor, width: 3),
//     ),
//     child: Center(
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Icon(icon),
//           SizedBox(height: context.height * .01),
//           Text(text, style: context.headlineSmall()),
//         ],
//       ),
//     ),
//   );
// }
//
// Future<void> _handlePhotosPermission({
//   required BuildContext context,
//   required PermissionCubit permissionCubit,
//   required ValueNotifier<File?> valueNotifier,
// })
// async {
//   final currentStatus = permissionCubit.state.photosPermission;
//
//   if (currentStatus.isGranted || currentStatus.isLimited) {
//     print('Enter IsGranted');
//     valueNotifier.value =
//     await getIt<ImageProviderHelper>().pickImageFromGallery();
//     return;
//   }
//
//   if (currentStatus.isPermanentlyDenied) {
//     print('Enter isPermanentlyDenied');
//     await openAppSettings();
//     await permissionCubit.checkInitialPermissions();
//     return;
//   }
//
//   print('Enter else → requesting permission');
//   print('Current: $currentStatus');
//
//   // ⏳ طلب الإذن
//   final newStatus = await permissionCubit.requestPhotosPermission();
//
//   // ✅ إذا تمت الموافقة، نفّذ اختيار الصورة
//   if (newStatus.isGranted || newStatus.isLimited) {
//     valueNotifier.value =
//     await getIt<ImageProviderHelper>().pickImageFromGallery();
//   } else {
//     print('Permission denied or restricted');
//   }
// }
//
//
// Future<void> _handleCameraPermission({
//   required BuildContext context,
//   required PermissionCubit permissionCubit,
//   required ValueNotifier<File?> valueNotifier,
// })
// async {
//   final state = permissionCubit.state;
//
//   if (state.cameraPermission.isGranted || state.cameraPermission.isLimited) {
//     valueNotifier.value =
//     await getIt<ImageProviderHelper>().pickImageFromCamera();
//   } else if (state.cameraPermission.isPermanentlyDenied) {
//     await openAppSettings();
//     await permissionCubit.checkInitialPermissions();
//   } else {
//     await permissionCubit.requestCameraPermission();
//     final newState = permissionCubit.state;
//     if (newState.cameraPermission.isGranted ||
//         newState.cameraPermission.isLimited) {
//       valueNotifier.value =
//       await getIt<ImageProviderHelper>().pickImageFromCamera();
//     }
//   }
// }