// // lib/main.dart (أو في ملف widget منفصل)
//
// import 'package:deal/core/di/injection.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:permission_handler/permission_handler.dart';
//
// import 'cubit/permissions_cubit.dart';
//
// class MyHomePage extends StatefulWidget {
//   @override
//   State<MyHomePage> createState() => _MyHomePageState();
// }
//
// class _MyHomePageState extends State<MyHomePage> {
//
//  // late final PermissionCubit permissionCubit ;
//   @override
//   void initState() {
//     // permissionCubit=getIt<PermissionCubit>();
//     // TODO: implement initState
//     super.initState();
//   }
//
//  // يمكن أن يكون StatelessWidget الآن
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text("Permissions with Cubit")),
//       body: BlocProvider<PermissionCubit>(
//   create: (context) => getIt<PermissionCubit>(),
//   child: BlocConsumer<PermissionCubit, PermissionState>(
//        // bloc: permissionCubit,
//         listener: (context, state) {
//           // الاستماع للتغييرات (مثل عرض SnackBar للخطأ أو عند رفض دائم)
//           if (state.errorMessage != null) {
//             ScaffoldMessenger.of(context).showSnackBar(
//               SnackBar(content: Text(state.errorMessage!), backgroundColor: Colors.red),
//             );
//           }
//           if (state.anyCorePermissionPermanentlyDenied) {
//             // يمكنك عرض تنبيه هنا يقترح فتح الإعدادات
//             print("Some permissions are permanently denied. Suggest opening settings.");
//           }
//         },
//         builder: (context, state) {
//           // إعادة بناء واجهة المستخدم بناءً على الحالة
//           if (state.isLoading) {
//             return Center(child: CircularProgressIndicator());
//           }
//
//           return Center(
//             child: SingleChildScrollView(
//               padding: const EdgeInsets.all(16.0),
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: <Widget>[
//                   Text("Location: ${state.locationPermission.name}"),
//                   ElevatedButton(
//                     onPressed: state.locationPermission.isGranted
//                         ? null // تعطيل الزر إذا كان الإذن ممنوحًا بالفعل
//                         : () => context.read<PermissionCubit>().requestLocationPermission(),
//                     child: Text(state.locationPermission.isPermanentlyDenied
//                         ? "Open Settings (Location)"
//                         : "Request Location"),
//                   ),
//                   Divider(),
//
//                   Text("Camera: ${state.cameraPermission.name}"),
//                   ElevatedButton(
//                     onPressed: state.cameraPermission.isGranted
//                         ? null
//                         : () => context.read<PermissionCubit>().requestCameraPermission(),
//                     child: Text(state.cameraPermission.isPermanentlyDenied
//                         ? "Open Settings (Camera)"
//                         : "Request Camera"),
//                   ),
//                   Divider(),
//
//                   Text("Storage/Photos: ${state.storageOrPhotosPermission.name}"),
//                   ElevatedButton(
//                     onPressed: state.storageOrPhotosPermission.isGranted
//                         ? null
//                         : () => context.read<PermissionCubit>().requestStorageOrPhotosPermission(),
//                     child: Text(state.storageOrPhotosPermission.isPermanentlyDenied
//                         ? "Open Settings (Photos)"
//                         : "Request Photos"),
//                   ),
//                   Divider(),
//
//                   Text("Notifications: ${state.notificationPermission.name}"),
//                   ElevatedButton(
//                     onPressed: state.notificationPermission.isGranted
//                         ? null
//                         : () => context.read<PermissionCubit>().requestNotificationPermission(),
//                     child: Text(state.notificationPermission.isPermanentlyDenied
//                         ? "Open Settings (Notifications)"
//                         : "Request Notifications"),
//                   ),
//                   Divider(),
//
//                   if (state.anyCorePermissionPermanentlyDenied)
//                     ElevatedButton(
//                       onPressed: () => context.read<PermissionCubit>().openSettings(),
//                       child: Text("Open App Settings"),
//                       style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
//                     ),
//                   SizedBox(height: 20),
//                   ElevatedButton(
//                     onPressed: () => context.read<PermissionCubit>().requestAllCorePermissions(),
//                     child: Text("Request All Missing Core Permissions"),
//                     style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
//                   ),
//                   SizedBox(height: 10),
//                   ElevatedButton(
//                     onPressed: () => context.read<PermissionCubit>().checkInitialPermissions(),
//                     child: Text("Re-check All Permissions"),
//                   ),
//                   if (state.allCorePermissionsGranted)
//                     Padding(
//                       padding: const EdgeInsets.only(top: 20.0),
//                       child: Text("All core permissions granted!", style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold)),
//                     )
//                 ],
//               ),
//             ),
//           );
//         },
//       ),
// ),
//     );
//   }
// }