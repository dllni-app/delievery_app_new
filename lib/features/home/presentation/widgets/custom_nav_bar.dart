import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../common/design/src/widgets/auto_scroll_text_widget.dart';
import '../../../../common/design/src/widgets/svg_asset.dart';
import '../../../../common/extensions/src/context_extensions.dart';
import '../../../../common/helper/helper.dart';
import '../../../../core/di/injection.dart';
import '../../../notification/presentation/bloc/notification_bloc.dart';

class CustomNavBar extends StatefulWidget {
  final int currentIndex;
  final Function(int) onTap;
  final List<CustomBottomNavBarItem> items;

  const CustomNavBar({
    required this.currentIndex,
    required this.onTap,
    required this.items,
    Key? key,
  }) : super(key: key);

  @override
  State<CustomNavBar> createState() => _CustomNavBarState();
}

class _CustomNavBarState extends State<CustomNavBar> {
  // late final CartBloc cartBloc;
  late final NotificationBloc notificationBloc;

  @override
  void initState() {
    notificationBloc = getIt<NotificationBloc>()
      ..add(GetAllNotificationEvent(isReload: true));
    // cartBloc = getIt<CartBloc>()..add(GetCartEvent());
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // widget.currentIndex == 2
        //     ? HomeCartWidget(cartBloc:cartBloc)
        //     : SizedBox(),
        Divider(height: 5,color: context.dividerColor),

        Container(
          padding: EdgeInsets.only(
            left: 20,
            right: 20,
            bottom: MediaQuery.of(context).padding.bottom + 16,
            top: 16,
          ),
          decoration: const BoxDecoration(color: Colors.white),
          child: Row(
            mainAxisSize: MainAxisSize.max,


            children: List.generate(widget.items.length, (i) {
              final item = widget.items[i];
              final isSel = i == widget.currentIndex;
              return Expanded(
                child: GestureDetector(
                  onTap: () {

                    // if(i == 2){
                    //   cartBloc.add(GetCartEvent());
                    // }
                    widget.onTap(i);
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    padding: EdgeInsets.symmetric(vertical: 12,horizontal: 12),
                    decoration: isSel
                        ? BoxDecoration(
                            color: context.primaryContainerColor,

                            borderRadius: BorderRadius.circular(1000),
                          )
                        : BoxDecoration(
                            borderRadius: BorderRadius.circular(1000),
                          ),
                    child: Column(

                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Stack(
                          children: [
                            SvgAsset(
                              item.icon,
                              color: isSel ? context.navBarSelectedColor : context.navBarColor,
                              height: 20
                            ),
                            BlocBuilder<NotificationBloc,NotificationState>(
                                bloc: notificationBloc,
                                builder: (context, state) {
                                  return (i == 2 &&
                                      state.isNew) ?
                                  PositionedDirectional(
                                    start: -1,
                                    top: -1,

                                    // 👉 عدّل القيم حسب الذوق
                                    child: Container(
                                      width: 10,
                                      height: 10,
                                      decoration: BoxDecoration(
                                        color: context.errorColor,
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                          color: Colors.white,
                                          width: 1,
                                        ),
                                      ),

                                    ),
                                  ) : SizedBox();
                                })
                          ],
                        ),

                          const SizedBox(width: 11),

                          ConstrainedBox(
                            constraints: BoxConstraints(
                              maxWidth: context.width * .3, // 👈 الحد الأعلى فقط
                            ),

                            child: FlexibleAutoScrollText(
                             text:
                              item.title.tr(),
                              style: context.titleLarge(
                                fontSize: 12,
                                fontWeight: FontWeight.w900,
                                color: isSel?  context.navBarSelectedColor :context.navBarColor
                              ),
                              // maxLines: 1,
                              // overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],

                    ),
                  ),
                ),
              );
            }),
          ),
        ),
      ],
    );
  }
}

class CustomBottomNavBarItem {
  final String title;
  final String icon;
  final Widget widget;

  CustomBottomNavBarItem({
    required this.title,
    required this.icon,
    required this.widget,
  });
  // CustomBottomNavBarItem({
  //   required this.title,
  //   required this.icon,
  //   required this.initialRoute,
  //   GlobalKey<NavigatorState>? navigatorKey,
  // }) : navigatorKey = navigatorKey ?? GlobalKey<NavigatorState>();
}
