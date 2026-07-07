import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../common/design/src/theme/theme/theme_collection.dart';
import '../../../../common/extensions/src/context_extensions.dart';
import '../../../../common/helper/src/locale_keys.dart';
import '../../../../core/di/injection.dart';
import '../cubit/home_cubit.dart';
import '../widgets/custom_nav_bar.dart';
import '../widgets/home_widgets/home_app_bar_widget.dart';

class NavBarScreen extends StatefulWidget {
  const NavBarScreen({super.key});

  @override
  _NavBarScreenState createState() => _NavBarScreenState();
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

    homeCubit = getIt<HomeCubit>()
      ..initNav(controller: pageController);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (
      homeCubit.state.pendingNotificationData != null
      ) {
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

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // 1️⃣ لو كنا في تب غير 0 → نرجع للتب 0
        if (homeCubit.state.selectedIndex != 0) {
          homeCubit.changeIndex(0);

          return false; // ❌ لا خروج
        }

        // 2️⃣ نحن في nav 0 → نعرض Dialog
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
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            side: BorderSide(
                              width: 1,
                              color: context.primarySwatch,
                            ),
                          ),
                          onPressed: () {
                            Navigator.of(context).pop(false);
                          },
                          child: Text(
                            LocaleKeys.ratingNo.tr(),
                            style: context.bodyMedium(fontSize: 14),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).pop(true);
                          },
                          child: Text(
                            LocaleKeys.ratingYes.tr(),

                            style: context.bodyMedium(
                              color: Colors.white,
                              fontSize: 14,
                            ),
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
        listenWhen: (pre, next) => (pre.selectedIndex != next.selectedIndex),
        listener: (context, state) {
          pageController.jumpToPage(state.selectedIndex);
        },
        builder: (context, state) {
          return Scaffold(
            // drawer: DrawerWidget(
            //   homeCubit: homeCubit,
            // ),
            body: Column(
              children: [
                HomeAppBarWidget(),
                Expanded(
                  child: PageView(
                    controller: pageController,
                    physics: const NeverScrollableScrollPhysics(),
                    children: state.navBar.map((tab) => tab.widget).toList(),
                  ),
                ),
              ],
            ),
            bottomNavigationBar: CustomNavBar(
              currentIndex: state.selectedIndex,
              onTap: (index) {
                homeCubit.changeIndex(index);
              },
              items: state.navBar,
            ),

          );
        },
      ),
    );
  }
}
