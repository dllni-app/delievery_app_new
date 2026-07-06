// import 'dart:ui';
// import 'package:flutter/src/material/colors.dart';
//
// import 'app_colors.dart';
//
// class DarkPalette implements AppColorPalette {
//   @override
//   MaterialColor get primarySwatch => const MaterialColor(
//     0xFFE91E63,
//     {
//       50: Color(0xFFFCE4EC),
//       100: Color(0xFFF8BBD0),
//       200: Color(0xFFF48FB1),
//       300: Color(0xFFF06292),
//       400: Color(0xFFEC407A),
//       500: Color(0xFFE91E63), // الأساسي
//       600: Color(0xFFD81B60),
//       700: Color(0xFFC2185B),
//       800: Color(0xFFAD1457),
//       900: Color(0xFF880E4F),
//     },
//   );
//
//
//   @override
//   Color get secondarySwatch => Colors.black;
//
//   @override
//   Color get scaffoldBackground => const Color.fromARGB(255, 255, 255, 255);
//
//   @override
//   Brightness get brightness => Brightness.light;
//
//   // 🌸 اللون الأساسي الزهري
//   @override
//   Color get primary => const Color(0xFFE91E63);
//
//   @override
//   Color get onPrimary => Colors.white;
//
//   @override
//   Color get primaryContainer => const Color(0xFFFCE4EC);
//
//   // 🌸 اللون الزهري أيضًا داخل الـ container
//   @override
//   Color get onPrimaryContainer => const Color(0xFFE91E63);
//
//   @override
//   Color get secondary => const Color(0xFFEA80FC);
//   @override
//   Color get onSecondary => Colors.white;
//   @override
//   Color get secondaryContainer => const Color(0xFFF3E5F5);
//   @override
//   Color get onSecondaryContainer => const Color(0xFF9C27B0);
//
//   @override
//   Color get tertiary => const Color(0xFFFF8A65);
//   @override
//   Color get onTertiary => Colors.white;
//   @override
//   Color get tertiaryContainer => const Color(0xFFFFCCBC);
//   @override
//   Color get onTertiaryContainer => const Color(0xFFFF7043);
//
//   @override
//   Color get error => const Color(0xFFFB2C36);
//   @override
//   Color get onError => const Color(0xFFFB2C36);
//   @override
//   Color get errorContainer => const Color(0xFFFB2C36);
//   @override
//   Color get onErrorContainer => const Color(0xFFFB2C36);
//
//   @override
//   Color get background => const Color(0xFFFFF5F8);
//   @override
//   Color get onBackground => const Color(0xFF1F1F1F);
//
//   @override
//   Color get surface => const Color(0xFFFFFFFF);
//   @override
//   Color get onSurface => const Color(0xFF1F1F1F);
//   @override
//   Color get surfaceVariant => const Color(0xFFF5F5F5);
//   @override
//   Color get onSurfaceVariant => const Color(0xFF707070);
//
//   @override
//   Color get outline => const Color(0xFFDEDEDE);
//   @override
//   Color get shadow => const Color(0x33000000);
//
//   @override
//   Color get inverseSurface => const Color(0xFF2F2F2F);
//   @override
//   Color get onInverseSurface => const Color(0xFFF5F5F5);
//   @override
//   Color get inversePrimary => const Color(0xFFF48FB1);
//
//   @override
//   Color get card => const Color(0xFFFFFFFF);
//   @override
//   Color get cardHighlighted => const Color(0xFFF5F5F5);
//   @override
//   Color get disabled => const Color(0xFFEAEAEA);
//   @override
//   Color get divider => const Color(0xFFDEDEDE);
//   @override
//   Color get textFieldBorder => const Color.fromRGBO(0, 0, 0, .1);
//
//   @override
//   Color get textFieldBackground => const Color(0xFFFFFFFF);
//
//   @override
//   Color get success => const Color(0xFF00C950);
//   @override
//   Color get warning => const Color(0xFFFFC107);
//   @override
//   Color get info => const Color(0xFF2196F3);
//
//   @override
//   Color get black => const Color(0xFF000000);
//
//   @override
//   Color get textColor => const Color(0xFF231F20);
//
//   @override
//   Color get textFieldHintColor => const Color.fromRGBO(138, 138, 138, 1);
//
//   @override
//   Color get headlineColor => const Color.fromRGBO(30, 30, 29, 1);
//
//   @override
//   Color get grey => const Color.fromRGBO(113, 113, 133, 1);
//
//   @override
//   Color get fieldLabelColor => const Color(0xFF717171);
//
//   @override
//   // TODO: implement langColor
//   Color get langColor =>const Color(0xFF682CDB);
//
//
//   @override
//   Color get numberColor => const Color(0xFFFCE4EC);
//
//   @override
//   // TODO: implement shareColor
//   Color get shareColor => const Color(0xFFA22CDB);
//
//   @override
//   // TODO: implement versionColor
//   Color get versionColor =>const Color(0xFFF2D144);
//
//   @override
//   Color get starsRateColor => const Color(0xFFF2D144);
//
//   @override
//   // TODO: implement carProfileColor
//   Color get carProfileColor => const Color(0xFF079FE0);
//
//
//   @override
//   Color get borderGradientStartColor => const Color(0xFFF06292); // وردي فاتح
//
//   @override
//   Color get borderGradientEndColor => const Color(0xFFC2185B); // وردي غامق
//
// ///
//   @override
//   // TODO: implement notificationOrderCompleted
//   Color get notificationOrderCompleted =>Color.fromRGBO(5, 76, 188, 1);
//   @override
//   // TODO: implement notificationAdd
//   Color get notificationAdd => Color.fromRGBO(104, 44, 219, 1);
//
//   @override
//   // TODO: implement notificationAttention
//   Color get notificationAttention => Color.fromRGBO(162, 44, 219, 1);
//
//   @override
//   // TODO: implement notificationDelete
//   Color get notificationDelete =>  Color.fromRGBO(251, 44, 54, 1);
//
//
//   @override
//   // TODO: implement notificationRequest
//   Color get notificationRequest =>Color.fromRGBO(5, 76, 188, 1);
//
//   @override
//   // TODO: implement notificationSchuled
//   Color get notificationSchuled => Color.fromRGBO(5, 76, 188, 1);
//
// }
