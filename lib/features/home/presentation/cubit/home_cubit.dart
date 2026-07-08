import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/di/injection.dart';
import '../../../../core/notification/notification_navigator.dart';
import '../../../delivery/presentation/cubit/delivery_cubit.dart';

part 'home_state.dart';

@lazySingleton
class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(HomeState());
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
