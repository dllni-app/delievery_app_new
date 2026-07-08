import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../common/design/src/theme/assets.gen.dart';
import '../../../../common/design/src/widgets/animation_widget/animated_title_text_widget.dart';
import '../../../../common/extensions/src/context_extensions.dart';
import '../../../../common/helper/src/locale_keys.dart';
import '../../../../core/di/injection.dart';
import '../../../../router/app_router.dart';
import '../bloc/user_bloc.dart';
import '../widgets/build_lang_sheet.dart';
import '../widgets/list_tile_divider.dart';
import '../widgets/phone_text.dart';
import 'personal_information_screen.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  late final UserBloc userBloc;

  @override
  void initState() {
    userBloc = getIt<UserBloc>()..add(UserGetMeEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserBloc, UserState>(
      bloc: userBloc,
      builder: (context, state) {
        return Padding(
          padding: EdgeInsets.only(
            top: MediaQuery.of(context).padding.top,
            left: context.width * .05,
            right: context.width * .05,
          ),
          child: state.getMeData.builder(
            onSuccess: (_) {
              final driver = state.getMeData.data!.data!;

              return RefreshIndicator(
                onRefresh: () async {
                  userBloc.add(UserGetMeEvent());
                },
                child: CustomScrollView(
                  slivers: [
                    SliverPadding(
                      padding: const EdgeInsets.only(top: 10),
                      sliver: SliverToBoxAdapter(
                        child: AnimatedTitleTextWidget(
                          child: Text(
                            LocaleKeys.profile.tr(),
                            style: context.labelSmall(
                              fontSize: 24,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SliverPadding(
                      padding: const EdgeInsets.only(top: 34, bottom: 8),
                      sliver: SliverToBoxAdapter(
                        child: Center(
                          child: Container(
                            width: context.width * .272,
                            height: context.width * .272,
                            decoration: BoxDecoration(
                              border: Border.all(color: context.textFieldBorder),
                              shape: BoxShape.circle,
                              color: context.primaryContainerColor,
                            ),
                            child: Icon(
                              Icons.person,
                              size: context.width * .12,
                              color: context.primarySwatch,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SliverPadding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      sliver: SliverToBoxAdapter(
                        child: Center(
                          child: Text(
                            driver.firstName,
                            style: context.labelSmall(fontSize: 20),
                            softWrap: true,
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ),
                    if (driver.phone.isNotEmpty)
                      SliverToBoxAdapter(
                        child: Center(
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(500),
                              color: const Color.fromRGBO(234, 240, 252, 1),
                            ),
                            padding: const EdgeInsets.symmetric(
                              vertical: 8,
                              horizontal: 24,
                            ),
                            margin: const EdgeInsets.only(bottom: 24),
                            child: PhoneText(text: driver.phone),
                          ),
                        ),
                      ),
                    SliverToBoxAdapter(
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: context.textFieldBorder,
                            width: 1,
                          ),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Column(
                          children: [
                            ListTileDivider(
                              title: LocaleKeys.profilePersonalInformation.tr(),
                              svgIcon: Assets.images.svg.drawer.accountIcon,
                              onTap: () {
                                context.pushNamed(
                                  RouteName.personalInformation,
                                  arguments: PersonalInformationParams(
                                    userBloc: userBloc,
                                  ),
                                );
                              },
                              color: context.primarySwatch,
                              hasDivider: true,
                            ),
                            ListTileDivider(
                              title: LocaleKeys.profileLanguage.tr(),
                              svgIcon: Assets.images.svg.profile.languageIcon,
                              onTap: () {
                                FocusScope.of(context).unfocus();
                                buildLangSheet(context);
                              },
                              color: context.langColor,
                              hasDivider: true,
                            ),
                            ListTileDivider(
                              title: LocaleKeys.profileShareThisLing.tr(),
                              svgIcon: Assets.images.svg.profile.shareIcon,
                              color: context.shareColor,
                              onTap: () {},
                              hasDivider: true,
                            ),
                            ListTileDivider(
                              title: LocaleKeys.profileAppVersion.tr(),
                              svgIcon: Assets.images.svg.profile.versionIcon,
                              color: context.versionColor,
                              onTap: () {},
                              hasDivider: true,
                              isNext: false,
                            ),
                            const ListTileLogOutWidget(),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
            onTapRetry: () => userBloc.add(UserGetMeEvent()),
          ),
        );
      },
    );
  }
}
