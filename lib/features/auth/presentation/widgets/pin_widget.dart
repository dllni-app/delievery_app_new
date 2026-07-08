import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

import '../../../../common/extensions/src/context_extensions.dart';
import '../../../../core/utils/app_colors.dart';

class PinWidget extends StatelessWidget {
  final PinInputController _pinController;

  const PinWidget({
    super.key,
    required PinInputController pinController,
  }) : _pinController = pinController;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Directionality(
        textDirection: TextDirection.ltr,
        child: MaterialPinField(
          pinController: _pinController,
          length: 6,
          mainAxisSize: MainAxisSize.max,

          /// ✅ سلوك مشابه لـ PinCodeTextField
          keyboardType: TextInputType.number,
          autoFocus: true,
          enabled: true,
          obscureText: false,



          theme: MaterialPinTheme(
            borderRadius: BorderRadius.circular(20),
            borderColor: Colors.grey.shade300,
            focusedBorderColor: AppColors.primary,

            fillColor: Colors.white,
            cursorColor: AppColors.primary,
            textStyle: TextStyle(
              color: AppColors.primary,
              fontSize: 14,
            ),
          ),


        ),
      ),
    );
  }
}