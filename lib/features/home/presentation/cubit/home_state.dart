part of 'home_cubit.dart';

class HomeState {
  final List<_ShellTab> navBar;
  final int selectedIndex;
  final Map<String, dynamic>? pendingNotificationData;

  HomeState({
    this.navBar = const [],
    this.selectedIndex = 0,
    this.pendingNotificationData,
  });

  HomeState copyWith({
    List<_ShellTab>? navBar,
    int? selectedIndex,
    Map<String, dynamic>? pendingNotificationData,
  }) {
    return HomeState(
      navBar: navBar ?? this.navBar,
      selectedIndex: selectedIndex ?? this.selectedIndex,
      pendingNotificationData:
          pendingNotificationData ?? this.pendingNotificationData,
    );
  }
}
