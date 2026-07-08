import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../common/design/src/theme/assets.gen.dart';
import '../../../../../common/design/src/widgets/svg_asset.dart';
import '../../../../../common/extensions/src/context_extensions.dart';
import '../../../../../common/helper/src/locale_keys.dart';
import '../../../../../core/di/injection.dart';
import '../../../../../core/utils/app_colors.dart';
import '../../../../../router/app_router.dart';
import '../../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../../user/presentation/bloc/user_bloc.dart';

class LogOutWidget extends StatelessWidget {
  final AuthBloc authBloc;

  const LogOutWidget({super.key, required this.authBloc});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
      bloc: authBloc,
      builder: (context, state) {
        return Container(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).padding.bottom,
          ),

          child: InkWell(
            child: Container(
              padding: const EdgeInsets.all(20),

              child: Row(
                children: [
                  SvgAsset(Assets.images.svg.drawer.logOutIcon),
                  SizedBox(width: 10),
                  Text(
                    LocaleKeys.drawerLogOut.tr(),
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.red,
                    ),
                  ),
                ],
              ),
            ),
            onTap: () {
              showDialog(
                context: context,
                builder: (_) {
                  return AlertDialog(
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(height: 12),
                        Text(
                          LocaleKeys.profileConfirmLogOut.tr(),
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.black,
                          ),
                        ),
                        SizedBox(height: 12),
                        Text(
                          LocaleKeys.profileAreUSure.tr(),
                          style: TextStyle(fontSize: 14),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 24),
                        Row(
                          children: [
                            Expanded(
                              child: OutlinedButton(
                                onPressed: () {
                                  context.pop();
                                },
                                child: Text(LocaleKeys.profileBack.tr(),
                                  style: TextStyle(
                                      color: AppColors.primary,
                                      fontSize: 14
                                  ),

                                ),
                              ),
                            ),
                            SizedBox(width: 12),
                            Expanded(
                              child: ElevatedButton(
                                child: Text(LocaleKeys.drawerLogOut.tr(),
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 14
                                  ),


                                ),
                                onPressed: () {
                                  authBloc.add(LogOutEvent());
                                },
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 4),
                      ],
                    ),
                  );
                },
              );
            },
          ),
        );
      },
      listener: (context, state) {
        state.logOutData.listenerFunction(
          onSuccess: () {
            context.pushNamedAndRemoveUntil(RouteName.splash, (e) => false);
          },
        );
      },
    );
  }
}


class DeleteAccountWidget extends StatefulWidget {
  const DeleteAccountWidget({super.key});



  @override
  State<DeleteAccountWidget> createState() => _DeleteAccountWidgetState();
}

class _DeleteAccountWidgetState extends State<DeleteAccountWidget> {

  late final UserBloc userBloc;

  @override
  void initState() {
    userBloc =getIt<UserBloc>();

    // TODO: implement initState
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return BlocConsumer<UserBloc, UserState>(
      bloc: userBloc,
      builder: (context, state) {
        return Container(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).padding.bottom,
          ),

          child: InkWell(
            child: Container(
              padding: const EdgeInsets.all(20),

              child: Row(
                children: [
                  SvgAsset(Assets.images.svg.drawer.delete,color: Colors.red),
                  SizedBox(width: 10),
                  Text(
                    LocaleKeys.deleteAccountTitle.tr(),
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.red,
                    ),
                  ),
                ],
              ),
            ),
            onTap: () {
              showDialog(
                context: context,
                builder: (_) {
                  return AlertDialog(
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(height: 12),
                        Text(
                          LocaleKeys.deleteAccountTitle.tr(),
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.black,
                          ),
                        ),
                        SizedBox(height: 12),
                        Text(
                          LocaleKeys.deleteAccountMessage.tr(),
                          style: TextStyle(fontSize: 14),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 24),
                        Row(
                          children: [
                            Expanded(
                              child: OutlinedButton(
                                onPressed: () {
                                  context.pop();
                                },
                                child: Text(LocaleKeys.deleteAccountCancel.tr(),
                                  style: TextStyle(
                                      color: AppColors.primary,
                                      fontSize: 14
                                  ),

                                ),
                              ),
                            ),
                            SizedBox(width: 12),
                            Expanded(
                              child: ElevatedButton(
                                child: Text(LocaleKeys.deleteAccountConfirm.tr(),
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 14
                                  ),


                                ),
                                onPressed: () {
                                  userBloc.add(UserDeleteMeEvent());
                                },
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 4),
                      ],
                    ),
                  );
                },
              );
            },
          ),
        );
      },
      listener: (context, state) {
        state.deleteMeData.listenerFunction(
          onSuccess: () {
            context.pushNamedAndRemoveUntil(RouteName.splash, (e) => false);
          },
        );
      },
    );
  }
}
