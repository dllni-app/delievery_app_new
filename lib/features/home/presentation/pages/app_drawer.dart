import 'package:flutter/material.dart';

import '../../../../common/design/src/theme/assets.gen.dart';
import '../../../../common/design/src/widgets/animation_widget/animated_scale_widget.dart';
import '../../../../common/design/src/widgets/animation_widget/animated_title_text_widget.dart';
import '../../../../common/design/src/widgets/svg_asset.dart';
import '../../../../common/extensions/src/context_extensions.dart';
import '../../../../common/helper/src/app_varibles.dart';
import '../../../../common/helper/src/locale_keys.dart';
import '../../../../core/di/injection.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../user/presentation/widgets/build_lang_sheet.dart';
import '../cubit/home_cubit.dart';
import '../widgets/drawer_widgets/drawer_contact_us_widget.dart';
import '../widgets/drawer_widgets/log_out_widget.dart';

class AppDrawer extends StatefulWidget {
  final HomeCubit homeCubit;

  const AppDrawer({super.key, required this.homeCubit});

  @override
  State<AppDrawer> createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {
  late final AuthBloc authBloc;

  @override
  void initState() {
    authBloc = getIt<AuthBloc>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: MediaQuery.of(context).padding.top + 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Align(
              alignment: Alignment.center,
              child: AnimatedScaleWidget(
                child: Text(
                  AppVariables.user?.firstName ?? LocaleKeys.nullText.tr(),
                  style: context.headlineMedium(fontSize: 22),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Align(
              alignment: Alignment.center,
              child: AnimatedScaleWidget(
                child: Text(
                  AppVariables.user?.phone ?? LocaleKeys.nullText.tr(),
                  style: context.bodyMedium(
                    fontSize: 16,
                    color: context.textSubColor,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
          Divider(height: 48, color: context.dividerColor),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsetsDirectional.only(start: 20),
                    child: Text(
                      LocaleKeys.drawerList.tr(),
                      style: context.bodySmall(fontSize: 16),
                    ),
                  ),
                  const SizedBox(height: 20),
                  _DrawerNavItem(
                    svgImage: Assets.images.svg.navBar.home,
                    title: LocaleKeys.navBarHome.tr(),
                    onTap: () {
                      context.pop();
                      widget.homeCubit.changeIndex(0);
                    },
                  ),
                  _DrawerNavItem(
                    svgImage: Assets.images.svg.navBar.notifications,
                    title: LocaleKeys.navBarNotifications.tr(),
                    onTap: () {
                      context.pop();
                      widget.homeCubit.changeIndex(1);
                    },
                  ),
                  _DrawerNavItem(
                    svgImage: Assets.images.svg.drawer.accountIcon,
                    title: LocaleKeys.profile.tr(),
                    onTap: () {
                      context.pop();
                      widget.homeCubit.changeIndex(2);
                    },
                  ),
                  _DrawerNavItem(
                    svgImage: Assets.images.svg.profile.languageIcon,
                    title: LocaleKeys.profileLanguage.tr(),
                    onTap: () {
                      context.pop();
                      buildLangSheet(context);
                    },
                  ),
                  const DrawerContactUsWidget(),
                  const DeleteAccountWidget(),
                ],
              ),
            ),
          ),
          Divider(height: 1, color: context.dividerColor),
          LogOutWidget(authBloc: authBloc),
        ],
      ),
    );
  }
}

class _DrawerNavItem extends StatelessWidget {
  final String svgImage;
  final String title;
  final VoidCallback onTap;

  const _DrawerNavItem({
    required this.svgImage,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            AnimatedScaleWidget(
              child: SvgAsset(
                svgImage,
                color: context.navBarSelectedColor,
              ),
            ),
            const SizedBox(width: 10),
            AnimatedTitleTextWidget(
              child: Text(
                title,
                style: context.headlineSmall(fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
