import 'package:permission_handler/permission_handler.dart';
import 'package:injectable/injectable.dart';
import 'package:permission_handler/permission_handler.dart';

// class PermissionManager {
//   /// طلب إذن الموقع
//   Future<PermissionStatus> requestLocationPermission() async {
//     // يمكنك اختيار .location, .locationAlways, .locationWhenInUse
//     return await Permission.locationWhenInUse.request();
//   }
//
//   /// التحقق من حالة إذن الموقع
//   Future<PermissionStatus> getLocationPermissionStatus() async {
//     return await Permission.locationWhenInUse.status;
//   }
//
//   /// طلب إذن الكاميرا
//   Future<PermissionStatus> requestCameraPermission() async {
//     return await Permission.camera.request();
//   }
//
//   /// طلب أذونات الصور/المعرض (تختلف قليلاً بين الأنظمة)
//   /// في أندرويد 13+، قد تحتاج إلى Permission.photos أو Permission.videos
//   /// Permission.storage هو إذن أوسع للإصدارات القديمة.
//   Future<PermissionStatus> requestStorageOrPhotosPermission() async {
//     // هذا مثال مبسط، قد تحتاج إلى منطق أكثر تفصيلاً بناءً على إصدار نظام التشغيل
//     if (await Permission.photos.isGranted || await Permission.storage.isGranted) {
//       // إذا كان أي منهما ممنوحًا بالفعل (خاصة للصور)
//       return PermissionStatus.granted;
//     }
//     // لأندرويد 13+، يُفضل Permission.photos. لأقدم، Permission.storage.
//     // المكتبة قد تتعامل مع هذا داخليًا إلى حد ما، ولكن كن على دراية.
//     // هذا مثال عام، قد تحتاج إلى تكييفه
//     // Permission.storage قد يكون مناسبًا للوصول العام للملفات (إذا كان ضروريًا ومدعومًا)
//     // Permission.photos / Permission.videos للوصول إلى الوسائط على أندرويد 13+
//     return await Permission.photos.request(); // أو Permission.storage.request() حسب الحاجة
//   }
//
//
//   /// طلب إذن الإشعارات (مهم لأندرويد 13+)
//   Future<PermissionStatus> requestNotificationPermission() async {
//     return await Permission.notification.request();
//   }
//
// // ملاحظة: إذن الإنترنت يُمنح تلقائيًا إذا تم تعريفه في AndroidManifest.xml.
// // لا يوجد طلب وقت التشغيل له عادةً.
// // أذونات "القراءة والكتابة" العامة معقدة بسبب Scoped Storage في أندرويد.
// // إذا كنت تقصد القراءة/الكتابة إلى تخزين التطبيق الخاص، فلا تحتاج لأذونات خاصة.
// // إذا كنت تقصد القراءة/الكتابة إلى مجلدات عامة، استخدم requestStorageOrPhotosPermission
// // أو تعامل مع Storage Access Framework في أندرويد (أكثر تعقيدًا).
// }


// lib/services/permission_manager.dart

// يمكنك استخدام @singleton إذا كنت تريد نسخة واحدة فقط من هذا الكلاس في التطبيق
// أو @lazySingleton إذا كنت تريد إنشاؤه فقط عند الحاجة إليه لأول مرة
@lazySingleton
class PermissionManager {
  /// 🔹 طلب إذن الموقع (Location)
  Future<PermissionStatus> requestLocationPermission() async {
    return await Permission.locationWhenInUse.request();
  }

  /// التحقق من حالة إذن الموقع
  Future<PermissionStatus> getLocationPermissionStatus() async {
    return await Permission.locationWhenInUse.status;
  }

  /// 🔹 طلب إذن الكاميرا
  Future<PermissionStatus> requestCameraPermission() async {
    return await Permission.camera.request();
  }

  /// 🔹 طلب إذن الوصول للصور (Photos)
  ///
  /// - في Android 13+ يستخدم Permission.photos
  /// - في iOS يعمل أيضًا للوصول إلى الصور
  Future<PermissionStatus> requestPhotosPermission() async {
    if (await Permission.photos.isGranted || await Permission.photos.isLimited) {
      return PermissionStatus.granted;
    }
    return await Permission.photos.request();
  }

  /// 🔹 طلب إذن الإشعارات (Notifications)
  ///
  /// - مطلوب برمجيًا في Android 13+ وiOS 10+
  Future<PermissionStatus> requestNotificationPermission() async {
    return await Permission.notification.request();
  }
}