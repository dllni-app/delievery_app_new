import 'package:flutter/material.dart';
import '../../../../common/design/src/theme/assets.gen.dart';
import '../../../../common/design/src/theme/const.dart';
import '../../../../common/design/src/widgets/auto_scroll_text_widget.dart';
import '../../../../common/design/src/widgets/cach_network_image.dart';
import '../../../../common/extensions/src/context_extensions.dart';
import '../../../../common/helper/src/locale_keys.dart';
import '../../../../common/models/notification_model.dart';
import '../../../../core/notification/notification_navigator.dart';
import 'package:intl/intl.dart';

class NotificationWidget extends StatelessWidget {
  final NotificationModel notification;

  // "args": {
  //                         "route": "productDetails",
  //                         "status": {
  //                             "label": "In transit",
  //                             "image": "https://gt-express.eidosteam.com/storage/status-icons/in_transit.png"
  //                         },
  //                         "tracking_number": "GTX-10000001"
  //                     },

  const NotificationWidget({super.key, required this.notification});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
        padding: const EdgeInsets.all(16),
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: notification.readAt != null
                ? context.dividerColor
                : context.primarySwatch,
            width: 1,
          ),
          boxShadow: const [
            BoxShadow(
              offset: Offset(0, 1),
              color: Color.fromRGBO(0, 0, 0, .05),
              blurRadius: 2,
              spreadRadius: 0,
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,

          children: [
            /// IMAGE (20% width)
            SizedBox(
              width: context.width * .2,
              height: context.width * .2,
              child: Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: context.navBarSelectedColor.withOpacity(.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: CacheNetworkImage(
                  imageUrl:
                      notification.data?.args?['status']['image'] ??
                      Assets.images.png.logo,
                ),
              ),
            ),

            Space.hS3,

            /// CONTENT
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  FlexibleAutoScrollText(
                    text:
                        notification.data?.args?['tracking_number'] ??
                        LocaleKeys.nullText.tr(),
                    style: context.bodyLarge(
                      fontSize: 16,
                      color: context.hintColor,
                    ),
                  ),
                  Space.vS1,
                  Text(
                    notification.data?.body ?? LocaleKeys.nullText.tr(),
                    style: context.bodySmall(fontSize: 14),
                    softWrap: true,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),

            Space.hS3,

            /// RIGHT SIDE
            SizedBox(
              height: context.width * .2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Text(
                    formatNotificationDate(notification.createdAt),
                    style: context.bodySmall(
                      fontSize: 12,
                      color: context.hintColor,
                    ),
                  ),
                  Space.vS1,
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color:
                          notification.data?.args?['status']['value'] ==
                              "picked_up"
                          ? context.pickedUp.withOpacity(.1)
                          : notification.data?.args?['status']['value'] ==
                                "in_transit"
                          ? context.inTransit.withOpacity(.2)
                          : notification.data?.args?['status']['value'] ==
                                'cancelled'
                          ? context.errorColor.withOpacity(.1)
                          : context.successBackGround,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      notification.data?.args?['status']['label'] ?? '',
                      style: context.headlineSmall(
                        color:
                        notification.data?.args?['status']['value'] ==
                            "picked_up"
                            ? context.pickedUp
                            : notification.data?.args?['status']['value'] ==
                            "in_transit"
                            ? context.inTransit
                            : notification.data?.args?['status']['value'] ==
                            'cancelled'
                            ? context.errorColor
                            : context.successColor,
                        
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      onTap: () {
        if (notification.data?.args == null) {
          return;
        } else {
          NotificationNavigator.navigateFromScreen(notification.data!.args!);
        }

        // if (notification.type == 'product') {
        //   context.pushNamed(
        //     RouteName.productDetailsScreen,
        //     arguments: ProductDetailsScreenParams(
        //       productBloc: getIt<ProductBloc>(),
        //       id: notification.relatedId!,
        //       image: notification.image,
        //     ),
        //   );
        // }
      },
    );
  }
}

String formatNotificationDate(String? createdAt) {
  // قيمة افتراضية إذا كانت null أو فاضية
  final safeDate = (createdAt == null || createdAt.isEmpty)
      ? DateTime.now().toIso8601String()
      : createdAt;

  final date = DateTime.parse(safeDate).toLocal();
  final now = DateTime.now();

  final today = DateTime(now.year, now.month, now.day);
  final yesterday = today.subtract(const Duration(days: 1));
  final target = DateTime(date.year, date.month, date.day);

  if (target == today) {
    return LocaleKeys.today.tr();
  } else if (target == yesterday) {
    return LocaleKeys.yesterday.tr();
  } else {
    return DateFormat('yyyy/MM/dd', 'en').format(date);
  }
}
