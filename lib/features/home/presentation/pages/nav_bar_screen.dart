import 'package:dllne_deliver_app/features/home/presentation/widgets/shell_bottom_nav_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart' as d;
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../common/design/src/theme/theme/theme_collection.dart';
import '../../../../common/extensions/src/context_extensions.dart';
import '../../../../common/helper/src/locale_keys.dart';
import '../../../../core/di/injection.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../delivery/presentation/pages/delivery_orders_page.dart';
import '../../../financial/presentation/pages/driver_financial_page.dart';
import '../../../notification/presentation/bloc/notification_bloc.dart';
import '../../../notification/presentation/pages/notification_screen.dart';
import '../../../user/presentation/bloc/user_bloc.dart';
import '../../../user/presentation/pages/new_more_screen.dart';
import '../cubit/home_cubit.dart';
import 'new_home_screen.dart';

class NavBarScreen extends StatefulWidget {
  const NavBarScreen({super.key});

  @override
  State<NavBarScreen> createState() => _NavBarScreenState();
}

class _DriverTopAppBar extends StatelessWidget {
  final String title;
  final String avatarName;
  final VoidCallback onNotificationPressed;

  const _DriverTopAppBar({
    required this.title,
    required this.avatarName,
    required this.onNotificationPressed,
  });

  @override
  Widget build(BuildContext context) {
    return d.Directionality(
      textDirection: d.TextDirection.ltr,
      child: Container(
        color: Colors.white,
        padding: EdgeInsets.fromLTRB(
          16,
          MediaQuery.paddingOf(context).top + 16,
          16,
          8,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            BlocBuilder<NotificationBloc, NotificationState>(
              bloc: getIt<NotificationBloc>(),
              builder: (context, notificationState) {
                return InkWell(
                  borderRadius: BorderRadius.circular(999),
                  onTap: onNotificationPressed,
                  child: SizedBox(
                    width: 40,
                    height: 40,
                    child: Center(
                      child: Badge(
                        isLabelVisible: notificationState.isNew,
                        child: Icon(
                          Icons.notifications_none,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Flexible(
                  child: Text(
                    title,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                      color: AppColors.primary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: 12),
                CircleAvatar(
                  radius: 20,
                  backgroundColor: AppColors.primary,
                  child: Text(
                    _initial(avatarName),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _initial(String name) {
    final trimmed = name.trim();
    if (trimmed.isEmpty) return '-';
    return trimmed[0];
  }
}

// I make it global for new_more_screen.dart
late final HomeCubit homeCubit;

class _NavBarScreenState extends State<NavBarScreen> {
  late final PageController pageController;
  late final UserBloc userBloc;

  String _titleForIndex(int index, String driverName) {
    return switch (index) {
      1 => 'الطلبات',
      2 => 'المستحقات',
      3 => 'الإشعارات',
      4 => 'المزيد',
      _ => driverName,
    };
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (homeCubit.state.selectedIndex != 0) {
          homeCubit.changeIndex(0);
          return false;
        }

        final shouldExit = await showDialog<bool>(
          context: context,
          barrierDismissible: false,
          builder: (context) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              insetPadding: const EdgeInsets.symmetric(horizontal: 20),
              contentPadding: const EdgeInsets.all(24),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    LocaleKeys.exitConfirmationTitle.tr(),
                    style: TextStyle(fontSize: 18),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8, bottom: 16),
                    child: Text(
                      LocaleKeys.exitConfirmationMessage.tr(),
                      style: TextStyle(fontSize: 14, color: Colors.black),
                    ),
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => Navigator.of(context).pop(false),
                          child: Text(LocaleKeys.ratingNo.tr()),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () => Navigator.of(context).pop(true),
                          child: Text(
                            LocaleKeys.ratingYes.tr(),
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        );

        return shouldExit ?? false;
      },
      child: BlocConsumer<HomeCubit, HomeState>(
        bloc: homeCubit,
        listenWhen: (pre, next) => pre.selectedIndex != next.selectedIndex,
        listener: (context, state) {
          pageController.jumpToPage(state.selectedIndex);
        },
        builder: (context, state) {
          return Scaffold(
            backgroundColor: Colors.white,
            appBar: PreferredSize(
              preferredSize: const Size.fromHeight(64),
              child: BlocBuilder<UserBloc, UserState>(
                bloc: userBloc,
                builder: (context, userState) {
                  final driverName =
                      userState.driverGetMeData.data?.data?.firstName ?? '-';
                  return _DriverTopAppBar(
                    title: _titleForIndex(state.selectedIndex, driverName),
                    avatarName: driverName,
                    onNotificationPressed: () => homeCubit.changeIndex(3),
                  );
                },
              ),
            ),
            body: PageView(
              controller: pageController,
              physics: const NeverScrollableScrollPhysics(),
              children: const [
                NewHomeScreen(),
                DeliveryOrdersPage(),
                DriverFinancialPage(),
                NotificationScreen(),
                NewMoreScreen(),
              ],
            ),
            bottomNavigationBar: ShellBottomNavBar(
              selectedIndex: state.selectedIndex,
              onTap: homeCubit.changeIndex,
            ),
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: ThemeCollection.lightTheme.scaffoldBackgroundColor,
        statusBarIconBrightness: Brightness.dark,
        systemNavigationBarColor: Colors.white,
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
    );
    pageController = PageController();
    homeCubit = getIt<HomeCubit>();
    userBloc = getIt<UserBloc>();
    userBloc.add(DriverGetMeEvent());

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (homeCubit.state.pendingNotificationData != null) {
        homeCubit.processPendingNotification();
      }
    });
    super.initState();
  }
}
