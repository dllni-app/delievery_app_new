import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../common/design/src/theme/assets.gen.dart';
import '../../../../common/design/src/widgets/my_custom_widget/rotating_widget.dart';
import '../../../../common/design/src/widgets/svg_asset.dart';
import '../../../../common/extensions/src/context_extensions.dart';
import '../../../../common/helper/src/locale_keys.dart';
import '../../../../core/di/injection.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../router/app_router.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';

class ListTileDivider extends StatelessWidget {
  final String title;
  final String svgIcon;
  final bool hasDivider;
  final VoidCallback? onTap;
  final Color color;
  final bool isNext;

  const ListTileDivider({
    super.key,
    required this.title,
    required this.svgIcon,
    this.hasDivider = false,
    this.onTap,
    required this.color,
    this.isNext = true,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          ListTile(
            title: Text(
              title,
              style: TextStyle(fontSize: 16),
            )
                .animate()
                .fadeIn(delay: 200.ms, duration: 600.ms)
                .scale(
                  begin: const Offset(0.5, 0.5),
                  end: const Offset(1, 1),
                  curve: Curves.elasticOut,
                ),
            leading: SolidShadowButtonWidget(color: color, svgIcon: svgIcon)
                .animate()
                .fadeIn(delay: 200.ms, duration: 600.ms)
                .scale(
                  begin: const Offset(0.5, 0.5),
                  end: const Offset(1, 1),
                  curve: Curves.elasticOut,
                ),
            trailing: isNext
                ? FlippableImage(
                    child: SvgAsset(
                      Assets.images.svg.nextArrowIcon,
                      color: AppColors.primary,
                      width: 24,
                    ),
                  )
                : const SizedBox(),
          ),
          hasDivider
              ? Container(
                  width: double.infinity,
                  height: 1,
                  margin: const EdgeInsets.symmetric(vertical: 16),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.grey.withOpacity(0),
                        Colors.grey.withOpacity(.5),
                        Colors.grey.withOpacity(0),
                      ],
                      begin: AlignmentDirectional.centerStart,
                      end: AlignmentDirectional.centerEnd,
                    ),
                  ),
                )
              : const SizedBox(),
        ],
      ),
    );
  }
}

class SolidShadowButtonWidget extends StatelessWidget {
  final Color color;
  final String svgIcon;

  const SolidShadowButtonWidget({
    super.key,
    required this.color,
    required this.svgIcon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.2),
            offset: const Offset(0, 2),
            blurRadius: 6,
          ),
        ],
      ),
      child: SvgAsset(svgIcon, color: color, width: 24, height: 24),
    );
  }
}

class ListTileLogOutWidget extends StatefulWidget {
  const ListTileLogOutWidget({super.key});

  @override
  State<ListTileLogOutWidget> createState() => _ListTileLogOutWidgetState();
}

class _ListTileLogOutWidgetState extends State<ListTileLogOutWidget> {
  late final AuthBloc authBloc;

  @override
  void initState() {
    authBloc = getIt<AuthBloc>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final isArabic = context.locale.languageCode == 'ar';

    return BlocListener<AuthBloc, AuthState>(
      bloc: authBloc,
      listener: (context, state) {
        state.logOutData.listenerFunction(
          onSuccess: () {
            context.pushNamedAndRemoveUntil(RouteName.splash, (e) => false);
          },
        );
      },
      child: GestureDetector(
        onTap: () {
          showDialog(
            context: context,
            builder: (_) {
              return AlertDialog(
                content: SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const SizedBox(height: 12),
                      Text(
                        LocaleKeys.profileConfirmLogOut.tr(),
                        style: TextStyle(
                          fontSize: 20,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        LocaleKeys.profileAreUSure.tr(),
                        style: TextStyle(fontSize: 14),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 24),
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton(
                              onPressed: () => context.pop(),
                              child: Text(
                                LocaleKeys.profileBack.tr(),
                                style: TextStyle(
                                  color: AppColors.primary,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () => authBloc.add(LogOutEvent()),
                              child: Text(
                                LocaleKeys.drawerLogOut.tr(),
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                    ],
                  ),
                ),
              );
            },
          );
        },
        child: ListTile(
          title: Text(
            LocaleKeys.drawerLogOut.tr(),
            style: TextStyle(
              fontSize: 16,
              color: Colors.red,
            ),
          ),
          leading: Padding(
            padding: const EdgeInsets.all(10),
            child: SvgAsset(
              Assets.images.svg.drawer.logOutIcon,
              color: Colors.red,
              width: 25,
              height: 25,
            ),
          ),
          trailing: Transform(
            alignment: Alignment.center,
            transform: Matrix4.identity()..scale(isArabic ? 1.0 : -1.0, -1.0),
            child: SvgAsset(
              Assets.images.svg.nextArrowIcon,
              color: Colors.red,
            ),
          ),
        ),
      ),
    );
  }
}
