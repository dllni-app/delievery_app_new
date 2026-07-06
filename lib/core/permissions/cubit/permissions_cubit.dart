import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:device_info_plus/device_info_plus.dart';

import '../permission_service.dart';

part 'permissions_state.dart';

// تأكد من استبدال 'your_app_name' باسم مشروعك الفعلي

@injectable
class PermissionCubit extends Cubit<PermissionState> {
  final PermissionManager _permissionManager;

  PermissionCubit(this._permissionManager) : super(const PermissionState()) {
    checkInitialPermissions();
  }

  Future<void> checkInitialPermissions() async {
    final locStatus = await _permissionManager.getLocationPermissionStatus();
    final camStatus = await Permission.camera.status;
    final photosStatus = await Permission.photos.status;
    final notStatus = await Permission.notification.status;

    emit(
      state.copyWith(
        locationPermission: locStatus,
        cameraPermission: camStatus,
        photosPermission: photosStatus,
        notificationPermission: notStatus,
      ),
    );
  }

  Future<void> requestLocationPermission() async {
    if (state.locationPermission.isGranted) return;

    PermissionStatus status;
    if (state.locationPermission.isPermanentlyDenied) {
      await openAppSettings();
      status = await _permissionManager.getLocationPermissionStatus();
    } else {
      status = await _permissionManager.requestLocationPermission();
    }

    emit(state.copyWith(locationPermission: status));
  }

  Future<void> requestCameraPermission() async {
    if (state.cameraPermission.isGranted) return;

    PermissionStatus status;
    if (state.cameraPermission.isPermanentlyDenied) {
      await openAppSettings();
      status = await Permission.camera.status;
    } else {
      status = await _permissionManager.requestCameraPermission();
    }

    emit(state.copyWith(cameraPermission: status));
  }

  Future<PermissionStatus> requestPhotosPermission() async {
    if (Platform.isAndroid) {
      final androidInfo = await DeviceInfoPlugin().androidInfo;
      final sdk = androidInfo.version.sdkInt;

      if (sdk >= 33) {
        return await Permission.photos.request();
      } else {
        return await Permission.storage.request();
      }
    } else if (Platform.isIOS) {
      return await Permission.photos.request();
    } else {
      return PermissionStatus.denied;
    }
  }


  Future<void> requestNotificationPermission() async {
    if (state.notificationPermission.isGranted) return;

    PermissionStatus status;
    if (state.notificationPermission.isPermanentlyDenied) {
      await openAppSettings();
      status = await Permission.notification.status;
    } else {
      status = await _permissionManager.requestNotificationPermission();
    }

    emit(state.copyWith(notificationPermission: status));
  }

  Future<void> requestAllCorePermissions() async {
    if (!state.locationPermission.isGranted) {
      await requestLocationPermission();
    }
    if (!state.cameraPermission.isGranted) {
      await requestCameraPermission();
    }
    if (!(state.photosPermission.isGranted || state.photosPermission.isLimited)) {
      await requestPhotosPermission();
    }
    if (!state.notificationPermission.isGranted) {
      await requestNotificationPermission();
    }
    await checkInitialPermissions();
  }

  Future<void> openSettings() async {
    await openAppSettings();
    await checkInitialPermissions();
  }
}
