part of 'permissions_cubit.dart';

class PermissionState  {
  final PermissionStatus locationPermission;
  final PermissionStatus cameraPermission;
  final PermissionStatus photosPermission;
  final PermissionStatus notificationPermission;

  const PermissionState({
    this.locationPermission = PermissionStatus.denied,
    this.cameraPermission = PermissionStatus.denied,
    this.photosPermission = PermissionStatus.denied,
    this.notificationPermission = PermissionStatus.denied,
  });

  PermissionState copyWith({
    PermissionStatus? locationPermission,
    PermissionStatus? cameraPermission,
    PermissionStatus? photosPermission,
    PermissionStatus? notificationPermission,
  }) {
    return PermissionState(
      locationPermission: locationPermission ?? this.locationPermission,
      cameraPermission: cameraPermission ?? this.cameraPermission,
      photosPermission: photosPermission ?? this.photosPermission,
      notificationPermission: notificationPermission ?? this.notificationPermission,
    );
  }

  /// هل جميع الأذونات الأساسية ممنوحة؟
  bool get allGranted =>
      locationPermission.isGranted &&
          cameraPermission.isGranted &&
          (photosPermission.isGranted || photosPermission.isLimited) &&
          notificationPermission.isGranted;

  /// هل أي من الأذونات مرفوض دائمًا؟
  bool get anyPermanentlyDenied =>
      locationPermission.isPermanentlyDenied ||
          cameraPermission.isPermanentlyDenied ||
          photosPermission.isPermanentlyDenied ||
          notificationPermission.isPermanentlyDenied;


}
