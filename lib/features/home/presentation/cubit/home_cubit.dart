import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import '../../../../common/design/src/theme/assets.gen.dart';
import '../../../../common/helper/src/locale_keys.dart';
import '../../../../core/notification/notification_navigator.dart';
import '../../../notification/presentation/pages/notification_screen.dart';
import '../pages/home_screen.dart';
import '../widgets/custom_nav_bar.dart';

part 'home_state.dart';

@lazySingleton
class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(HomeState());

  void initNav({required PageController controller}) {
    final nav = [
      CustomBottomNavBarItem(
        title: LocaleKeys.navBarHome,
        icon: Assets.images.svg.navBar.home,
        widget: HomeScreen(),
      ),
      // CustomBottomNavBarItem(
      //   title: LocaleKeys.navBarService,
      //   icon: Assets.images.svg.navBar.servises,
      //   widget: AdvertisementScreen(),
      // ),
      CustomBottomNavBarItem(
        title: LocaleKeys.navBarNotifications,
        icon: Assets.images.svg.navBar.notifications,
        widget: NotificationScreen(),
      ),
      // CustomBottomNavBarItem(
      //   title: LocaleKeys.navBarInquiries,
      //   icon: Assets.images.svg.navBar.search,
      //   widget: ProductsScreen(),
      // ),
    ];

    emit(state.copyWith(navBar: nav, selectedIndex: 0));
  }

  void changeIndex(int index) {
    emit(state.copyWith(selectedIndex: index));
  }

  void changeFile(File? file) {
    emit(state.copyWith(file: file));
  }

  void deleteFile() {
    emit(state.copyWith(file: null)); // Reset the file to null
  }

  void setPendingNotification(Map<String, dynamic> data) {
    emit(state.copyWith(pendingNotificationData: data));
  }

  void clearPendingNotification() {
    emit(state.copyWith(pendingNotificationData: null));
  }

  void processPendingNotification() {
    final data = state.pendingNotificationData;

    if (data == null) return;

    try {
      NotificationNavigator.navigateFromData(data);
    } finally {
      clearPendingNotification();
    }
  }
}
