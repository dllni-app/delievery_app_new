import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../common/design/src/theme/theme/theme_collection.dart';
import '../../../../common/extensions/src/context_extensions.dart';
import '../../../../common/helper/src/locale_keys.dart';
import '../../../../core/di/injection.dart';
import '../../../notification/presentation/bloc/notification_bloc.dart';
import '../cubit/home_cubit.dart';

class NavBarScreen extends StatefulWidget {
  const NavBarScreen({super.key});

  @override
  State<NavBarScreen> createState() => _NavBarScreenState();
}

class _NavBarScreenState extends State<NavBarScreen> {
  late final HomeCubit homeCubit;
  late final PageController pageController;

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
    homeCubit = getIt<HomeCubit>()..initNav();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (homeCubit.state.pendingNotificationData != null) {
        homeCubit.processPendingNotification();
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  String _titleForTab(int index) {
    if (index < 0 || index >= homeCubit.state.navBar.length) return '';
    return homeCubit.state.navBar[index].titleKey;
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
                    style: context.headlineSmall(fontSize: 18),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8, bottom: 16),
                    child: Text(
                      LocaleKeys.exitConfirmationMessage.tr(),
                      style: context.bodyMedium(
                        fontSize: 14,
                        color: context.textColor,
                      ),
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
                            style: context.bodyMedium(color: Colors.white),
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
            backgroundColor: context.scaffoldBackgroundColor,
              appBar: AppBar(
                backgroundColor: context.scaffoldBackgroundColor,
                elevation: 0,
                scrolledUnderElevation: 0,
                title: Text(
                  _titleForTab(state.selectedIndex),
                  style: context.headlineSmall(
                    fontSize: 18,
                    color: context.primarySwatch,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                actions: [
                  if (state.selectedIndex != 2)
                    BlocBuilder<NotificationBloc, NotificationState>(
                      bloc: getIt<NotificationBloc>(),
                      builder: (context, notificationState) {
                        return IconButton(
                          onPressed: () => homeCubit.changeIndex(2),
                          icon: Badge(
                            isLabelVisible: notificationState.isNew,
                            child: Icon(
                              Icons.notifications_none,
                              color: context.primarySwatch,
                            ),
                          ),
                        );
                      },
                    ),
                ],
              ),
              body: PageView(
                controller: pageController,
                physics: const NeverScrollableScrollPhysics(),
                children: state.navBar.map((tab) => tab.widget).toList(),
              ),
              bottomNavigationBar: NavigationBar(
                selectedIndex: state.selectedIndex,
                onDestinationSelected: homeCubit.changeIndex,
                backgroundColor: context.scaffoldBackgroundColor,
                indicatorColor: context.secondaryColor,
                labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
                destinations: [
                  for (final tab in state.navBar)
                    NavigationDestination(
                      icon: Icon(tab.icon, color: context.navBarColor),
                      selectedIcon: Icon(
                        tab.selectedIcon,
                        color: Colors.white,
                      ),
                      label: tab.titleKey,


                    ),
                ],
              ),
            );
        },
      ),
    );
  }
}
