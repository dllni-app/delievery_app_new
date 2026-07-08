import 'dart:ui';

import 'package:flutter/material.dart';

import 'app_colors.dart';

class LightPalette implements AppColorPalette {
  @override
  String get fontFamily => 'Cairo';

  //
  // @override
  // MaterialColor get primarySwatch =>
  //     const MaterialColor(
  //       0xFF183830,
  //       {
  //         50: Color(0xFFE3EAE8),
  //         100: Color(0xFFB9CBC6),
  //         200: Color(0xFF8BA9A0),
  //         300: Color(0xFF5D8779),
  //         400: Color(0xFF3B6D5D),
  //         500: Color(0xFF183830), // PRIMARY
  //         600: Color(0xFF16322B),
  //         700: Color(0xFF122B24),
  //         800: Color(0xFF0E241D),
  //         900: Color(0xFF081712),
  //       },
  //     );

  @override
  MaterialColor get primarySwatch => const MaterialColor(
    0xFF1E2A78,
    {
      50: Color(0xFFE8EAF4),
      100: Color(0xFFC5CAE4),
      200: Color(0xFF9EA7D2),
      300: Color(0xFF7684C0),
      400: Color(0xFF5869B1),
      500: Color(0xFF1E2A78), // PRIMARY
      600: Color(0xFF1B266E),
      700: Color(0xFF172163),
      800: Color(0xFF131B59),
      900: Color(0xFF0C1246),
    },
  );
  @override
  Color get secondarySwatch => Color(0xFF6C63FF);


  @override
  // TODO: implement scaffoldBackground
  Color get scaffoldBackground => const Color(0xFFF8F9FA);


  @override
  Brightness get brightness => Brightness.light;

  @override
  Color get primary => const Color(0xFF1E2A78);

  @override
  Color get onPrimary => Colors.white;

  @override
  Color get primaryContainer => const Color(0xFFECFDF5);

  @override
  Color get onPrimaryContainer => const Color(0xFF054CBC);

  @override
  Color get secondary => const Color(0xFF559BB4);

  @override
  Color get onSecondary => Colors.white;

  @override
  Color get secondaryContainer => const Color(0xFFE6F0F4);

  @override
  Color get onSecondaryContainer => const Color(0xFFFF7A00);

  @override
  Color get tertiary => const Color(0xFFD3601F);

  @override
  Color get onTertiary => Colors.white;

  @override
  Color get tertiaryContainer => const Color(0xFFFFDBCB);

  @override
  Color get onTertiaryContainer => const Color(0xFFD3601F);

  @override
  Color get error => const Color(0xFFBA1A1A);

  @override
  Color get onError => const Color(0xFFFFDAD6);

  @override
  Color get errorContainer => const Color(0xFF8B1E2D);

  @override
  Color get onErrorContainer => const Color(0xFF8B1E2D);

  @override
  Color get background => const Color(0xFFFEF4EB);

  @override
  Color get onBackground => const Color(0xFF1F1F1F);

  @override
  Color get surface => const Color(0xFFd9dadb);

  @override
  Color get onSurface => const Color(0xFF1F1F1F);

  @override
  Color get surfaceVariant => const Color(0xFFF5F5F5);

  @override
  Color get onSurfaceVariant => const Color(0xFF707070);

  @override
  Color get outline => const Color(0xFFDEDEDE);

  @override
  Color get shadow => const Color(0x33000000);

  @override
  Color get inverseSurface => const Color(0xFF2F2F2F);

  @override
  Color get onInverseSurface => const Color(0xFFF5F5F5);

  @override
  Color get inversePrimary => const Color(0xFF8CB4EA);

  @override
  Color get card => const Color(0xFFFFFFFF);

  @override
  Color get cardHighlighted => const Color(0xFFF5F5F5);

  @override
  Color get disabled => const Color(0xFFEAEAEA);

  @override
  Color get divider => const Color(0xFFE7E5E4);

  @override
  Color get textFieldBorder => const Color(0xFFC6C5D3);

  //717171
  @override
  Color get textFieldBackground => const Color(0xFFF8F9FA);

  @override
  Color get success => const Color(0xFF2E7D32);

  @override
  Color get successBackGround => const Color(0xFFF0FDF4);

  @override
  Color get warning => const Color(0xFFFFC107);

  @override
  Color get info => const Color(0xFF2196F3);


  @override
  // TODO: implement black
  Color get black => const Color.fromARGB(255, 0, 0, 0);

  @override
  // TODO: implement textColor
  Color get textColor => const Color(0xFF191C1D);

  @override
  // TODO: implement textFieldHintColor
  Color get textFieldHintColor => const Color(0xFF767682);


  @override
  // TODO: implement headlineColor
  Color get headlineColor => const Color.fromRGBO(30, 30, 29, 1);

  @override
  // TODO: implement grey
  Color get grey => const Color.fromRGBO(113, 113, 133, 1);

  @override
  // TODO: implement fieldLabelColor
  Color get fieldLabelColor => const Color(0xFF717171);

  @override
  // TODO: implement langColor
  Color get langColor => const Color(0xFF682CDB);


  @override
  // TODO: implement numberColor
  Color get numberColor => const Color(0xFFEAF0FC);

  @override
  // TODO: implement shareColor
  Color get shareColor => const Color(0xFFA22CDB);


  @override
  // TODO: implement versionColor
  Color get versionColor => const Color(0xFFF2D144);

  @override
  // TODO: implement starsRateColor
  Color get starsRateColor => const Color(0xFFF2D144);

  @override
  // TODO: implement carProfileColor
  Color get carProfileColor => const Color(0xFF079FE0);


  @override
  // TODO: implement borderGradientStartColor
  Color get borderGradientStartColor => Color.fromRGBO(40, 160, 242, 1);


  @override
  // TODO: implement borderGradientEndColor
  Color get borderGradientEndColor => Color.fromRGBO(22, 89, 193, 1);


  ///


  @override
  // TODO: implement notificationOrderCompleted
  Color get notificationOrderCompleted => Color.fromRGBO(5, 76, 188, 1);

  @override
  // TODO: implement notificationAdd
  Color get notificationAdd => Color.fromRGBO(104, 44, 219, 1);

  @override
  // TODO: implement notificationAttention
  Color get notificationAttention => Color.fromRGBO(162, 44, 219, 1);

  @override
  // TODO: implement notificationDelete
  Color get notificationDelete => Color.fromRGBO(251, 44, 54, 1);


  @override
  // TODO: implement notificationRequest
  Color get notificationRequest => Color.fromRGBO(5, 76, 188, 1);

  @override
  // TODO: implement notificationSchuled
  Color get notificationSchuled => Color.fromRGBO(5, 76, 188, 1);

  @override
  // TODO: implement hintColor
  Color get hintColor => Color(0xFF6B7280);

  @override
  Color get textSubColor => Color(0xFF454651);

  @override
  Color get anotherTextColor => Color(0xFF44655B);

  @override
  Color get navBarColor => const Color(0xFFA8A29E);

  @override
  Color get navBarSelectedColor =>Color(0xFF6C63FF);

  @override
  Color get appBarColor => const Color(0xFF6C63FF);

  @override
  Color get iconBackGround => const Color(0xFFC3E7DB);

  @override
  Color get onWay => const Color(0xFF2563EB);

  @override
  Color get onWayBackground => const Color(0xFFEFF6FF);

  @override
  Color get inTransitColor => const Color(0xFFD4A017);

  @override
  Color get pickedUp => const Color(0xFF4C8DAE);


}