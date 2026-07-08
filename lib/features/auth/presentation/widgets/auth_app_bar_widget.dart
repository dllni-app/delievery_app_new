import 'package:flutter/material.dart';

import '../../../../common/design/src/theme/const.dart';
import '../../../../common/extensions/src/context_extensions.dart';
import '../../../../core/utils/app_colors.dart';

class AuthAppBarWidget extends StatelessWidget {
  const AuthAppBarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            offset: Offset(0, 1),
            blurRadius: 2,
            color: Color.fromRGBO(0, 0, 0, .05),
            spreadRadius: 0,
          ),
        ],
        color: Colors.white,
      ),
      child: Column(
        children: [
          Space.vM2,
          Row(
            children: [
              IconButton(
                icon: Icon(
                  Icons.arrow_back_sharp,
                  color: AppColors.primary,
                  size: 30,
                ),
                onPressed: () => context.pop(),
              ),
              Text(
                "GT Express",
                style: TextStyle(
                  fontSize: 20,
                  color: AppColors.primary,
                ),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
            ],
          ),
          Space.vM2,
          Divider(height: 1, color: Colors.grey.shade300),
        ],
      ),
    );
  }
}
