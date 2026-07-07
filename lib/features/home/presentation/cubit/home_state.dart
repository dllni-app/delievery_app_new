part of 'home_cubit.dart';


class HomeState {
  final List<CustomBottomNavBarItem> navBar;
  final int selectedIndex;
  final Map<String, dynamic>? pendingNotificationData;


  HomeState({
    this.navBar = const [],
    this.selectedIndex = 0,
    this.pendingNotificationData,


  });

  HomeState copyWith({
    List<CustomBottomNavBarItem>? navBar,
    int? selectedIndex,
    File? file, // Use nullable explicitly
    bool resetFile = false,
    Map<String, dynamic>? pendingNotificationData,


    // Add this flag for file reset
  })
  {
    return HomeState(// Use flag to reset the file to null
      navBar: navBar ?? this.navBar,
      selectedIndex: selectedIndex ?? this.selectedIndex,
      pendingNotificationData:
      pendingNotificationData ?? this.pendingNotificationData,
    );
  }



}
