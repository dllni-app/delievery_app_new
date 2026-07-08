import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/di/injection.dart';
import '../../../../core/notification/notification_navigator.dart';
import '../../../delivery/presentation/cubit/delivery_cubit.dart';
import '../../../delivery/presentation/pages/delivery_disputes_page.dart';
import '../../../delivery/presentation/pages/delivery_orders_page.dart';
import '../../../notification/presentation/pages/notification_screen.dart';
import '../../../user/presentation/pages/driver_more_page.dart';
import '../pages/home_screen.dart';

part 'home_state.dart';

@lazySingleton
class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(HomeState());

  void initNav() {
    final nav = [
      _ShellTab(
        titleKey: 'الرئيسية',
        icon: Icons.home_outlined,
        selectedIcon: Icons.home,
        widget: const HomeScreen(),
      ),
      _ShellTab(
        titleKey: 'طلباتي',
        icon: Icons.list_alt_outlined,
        selectedIcon: Icons.list_alt,
        widget:  DeliveryOrdersPage(),
      ),
      _ShellTab(
        titleKey: 'الإشعارات',
        icon: Icons.notifications_none,
        selectedIcon: Icons.notifications,
        widget: const NotificationScreen(),
      ),
      _ShellTab(
        titleKey: 'البلاغات',
        icon: Icons.report_gmailerrorred_outlined,
        selectedIcon: Icons.report,
        widget:  DeliveryDisputesPage(),
      ),
      _ShellTab(
        titleKey: 'المزيد',
        icon: Icons.more_horiz,
        selectedIcon: Icons.more,
        widget: const DriverMorePage(),
      ),
    ];

    emit(state.copyWith(navBar: nav, selectedIndex: 0));
    _onTabSelected(0);
  }

  void changeIndex(int index) {
    if (index == state.selectedIndex) return;
    emit(state.copyWith(selectedIndex: index));
    _onTabSelected(index);
  }

  void _onTabSelected(int index) {
    switch (index) {
      case 0:
        getIt<DeliveryCubit>().loadDashboard();
        break;
      case 1:
        getIt<DeliveryCubit>().loadDashboard();
        break;
      case 3:
        getIt<DeliveryCubit>().loadDisputes();
        break;
      default:
        break;
    }
  }

  void changeFile(File? file) {
    // Reserved for profile image picker flow.
  }

  void deleteFile() {
    // Reserved for profile image picker flow.
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

class _ShellTab {
  const _ShellTab({
    required this.titleKey,
    required this.icon,
    required this.selectedIcon,
    required this.widget,
  });

  final String titleKey;
  final IconData icon;
  final IconData selectedIcon;
  final Widget widget;
}
