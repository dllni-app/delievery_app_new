import 'package:flutter/material.dart';

import '../../../../common/extensions/src/context_extensions.dart';

class PhoneText extends StatelessWidget {
  final String text;
  final TextStyle? style;

  const PhoneText({super.key, required this.text, this.style});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Text(
        formatPhone(text),
        style: style ?? context.displaySmall(fontSize: 14),
        overflow: TextOverflow.ellipsis,
        maxLines: 1,
      ),
    );
  }

  String formatPhone(String phone) {
    phone = phone.replaceAll(' ', '').replaceAll('-', '');

    final start = phone.substring(0, phone.length >= 4 ? 4 : phone.length);
    final number = phone.length > 4 ? phone.substring(4) : '';

    final parts = <String>[];
    for (var i = 0; i < number.length; i += 3) {
      final end = (i + 3 < number.length) ? i + 3 : number.length;
      parts.add(number.substring(i, end));
    }

    return parts.isEmpty ? start : '$start ${parts.join(' ')}';
  }
}
