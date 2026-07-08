import 'package:flutter/material.dart';

void showSnack(
  BuildContext context,
  String message, {
  SnackBarType type = SnackBarType.info,
}) {
  final style = switch (type) {
    SnackBarType.success => const (
      icon: Icons.check_circle_rounded,
      background: Color(0xFF1B5E20),
      stripe: Color(0xFF81C784),
    ),
    SnackBarType.failure => const (
      icon: Icons.error_rounded,
      background: Color(0xFFB71C1C),
      stripe: Color(0xFFEF9A9A),
    ),
    SnackBarType.warning => const (
      icon: Icons.warning_amber_rounded,
      background: Color(0xFF8D6E00),
      stripe: Color(0xFFFFE082),
    ),
    SnackBarType.info => const (
      icon: Icons.info_rounded,
      background: Color(0xFF0D47A1),
      stripe: Color(0xFF90CAF9),
    ),
  };

  ScaffoldMessenger.of(context).hideCurrentSnackBar();
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      behavior: SnackBarBehavior.floating,
      elevation: 0,
      backgroundColor: Colors.transparent,
      margin: const EdgeInsets.all(12),
      content: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: style.background,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.14),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 4,
              height: 34,
              decoration: BoxDecoration(
                color: style.stripe,
                borderRadius: BorderRadius.circular(99),
              ),
            ),
            const SizedBox(width: 10),
            Icon(style.icon, color: Colors.white, size: 22),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                message,
                style: const TextStyle(
                  color: Colors.white,
                  fontFamily: 'Cairo',
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  height: 1.25,
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

enum SnackBarType { success, failure, warning, info }
