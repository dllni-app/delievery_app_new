import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../common/design/src/theme/assets.gen.dart';
import '../../../../common/design/src/theme/const.dart';
import '../../../../common/design/src/widgets/animation_widget/animated_scale_widget.dart';
import '../../../../common/design/src/widgets/animation_widget/animated_sub_text_widget.dart';
import '../../../../common/design/src/widgets/app_text_field.dart';
import '../../../../common/design/src/widgets/my_custom_widget/my_custom_scaffold.dart';
import '../../../../common/design/src/widgets/my_custom_widget/rotating_widget.dart';
import '../../../../common/design/src/widgets/phone_number_widget/my_phone_number_field_widget.dart';
import '../../../../common/design/src/widgets/svg_asset.dart';
import '../../../../common/extensions/src/context_extensions.dart';
import '../../../../common/extensions/src/validation.dart';
import '../../../../common/helper/src/locale_keys.dart';
import '../../../../core/di/injection.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../router/app_router.dart';
import '../../domain/use_cases/login_use_case.dart';
import '../bloc/auth_bloc.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late final AuthBloc authBloc;
  late final TextEditingController passwordController;
  final GlobalKey<FormState> _globalKey = GlobalKey<FormState>();
  late final FocusNode phoneFocusNode;

  late final FocusNode passwordFocusNode;

  late final ValueNotifier<String>? phoneValue;

  @override
  void initState() {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Colors.white,
        statusBarIconBrightness: Brightness.dark,
        // systemNavigationBarColor:
        //     ThemeCollection.maleTheme.scaffoldBackgroundColor,
        systemNavigationBarColor: Colors.white,
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
    );
    authBloc = getIt<AuthBloc>();
    passwordController = TextEditingController();

    phoneFocusNode = FocusNode();
    passwordFocusNode = FocusNode();
    phoneValue = ValueNotifier('');

    super.initState();
  }

  @override
  void dispose() {
    authBloc.close();
    passwordController.dispose();
    phoneFocusNode.dispose();
    passwordFocusNode.dispose();
    // TODO: implement dispose
    super.dispose();
  }

  void _login() {
    if (!(_globalKey.currentState?.validate() ?? false)) return;

    authBloc.add(
      LoginEvent(
        params: LoginParams(
          phone: phoneValue!.value,
          password: passwordController.text.trim(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
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
                    style: TextStyle(fontSize: 18),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8, bottom: 16),
                    child: Text(
                      LocaleKeys.exitConfirmationMessage.tr(),
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.black,
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
                              color: AppColors.primary,
                            ),
                          ),
                          onPressed: () {
                            Navigator.of(context).pop(false);
                          },
                          child: Text(
                            LocaleKeys.ratingNo.tr(),
                            style: TextStyle(fontSize: 14),
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

                            style: TextStyle(
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

      child: BlocListener<AuthBloc, AuthState>(
        bloc: authBloc,
        listenWhen: (pre, cur) => pre.loginData.status != cur.loginData.status,
        listener: (context, state) {
          state.loginData.listenerFunction(
            onSuccess: () {
              context.pushNamedAndRemoveUntil(RouteName.homeNav, (e) => false);
            },
          );
        },
        child: MyCustomScaffold(
          body: Form(
            key: _globalKey,
            child: Container(
              margin: EdgeInsets.only(
                top: MediaQuery.sizeOf(context).height * .05,
                bottom: MediaQuery.sizeOf(context).height * .05,
              ),

              padding: EdgeInsets.all(22),
              decoration: BoxDecoration(
                color: Colors.white,

                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Color.fromRGBO(0, 0, 0, 0.05),
                    offset: Offset(0, 1),
                    blurRadius: 2,
                  ),
                  BoxShadow(
                    color: Color.fromRGBO(23, 26, 31, 0), // rgba(23,26,31,0)
                    offset: Offset(0, 0),
                    blurRadius: 0,
                    spreadRadius: 0,
                  ),
                ],
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding: EdgeInsets.all(36),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.primary,
                      ),
                      child: SvgAsset(
                        Assets.images.svg.logIn.track,
                        height: 24,
                      ),
                    ),
                    Space.vM4,
                    AnimatedScaleWidget(
                      child: Text(
                        'تطبيق المندوب',
                        style: TextStyle(
                          fontSize: 32,
                          color: Colors.black,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Space.vM1,
                    Space.vS1,
                    AnimatedSubTextWidget(
                      child: Text(
                        'مرحباً بك مجدداً، يرجى تسجيل الدخول للمتابعة',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.black,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Space.vM4,
                    Align(
                      alignment: AlignmentDirectional.centerStart,
                      child: Text(
                        'رقم الهاتف',
                        style: TextStyle(
                          color: Colors.grey.shade300,
                          fontSize: 14,
                        ),
                      ),
                    ),
                    Space.vS3,
                    AnimatedScaleWidget(
                      child: MyPhoneNumberField(
                        hintText: 'أدحل رقم الهاتف',

                        internationalPhoneValue: phoneValue,
                        isMargin: false,
                        textInputAction: TextInputAction.next,
                        focusNode: phoneFocusNode,
                        onSubmitted: (_) => FocusScope.of(
                          context,
                        ).requestFocus(passwordFocusNode),
                      ),
                    ),
                    Space.vM2,
                    Align(
                      alignment: AlignmentDirectional.centerStart,
                      child: Text(
                        "كلمة المرور",
                        style: TextStyle(
                          color: Colors.grey.shade300,
                          fontSize: 14,
                        ),
                      ),
                    ),
                    Space.vS3,
                    AnimatedScaleWidget(
                      child: MyAppTextField(
                        textInputAction: TextInputAction.done,
                        isPadding: false,
                        prefixIcon: SvgAsset(Assets.images.svg.logIn.password),

                        hintText: LocaleKeys.authEnterPassword.tr(),
                        controller: passwordController,
                        validator: (text) => text.validatePassword,
                        keyboardType: TextInputType.visiblePassword,
                        focus: passwordFocusNode,
                        onSubmitted: (_) {
                          passwordFocusNode.unfocus();
                        },
                        isPassword: true,
                      ),
                    ),
                    Space.vM4,
                    SizedBox(
                      width: MediaQuery.sizeOf(context).width,
                      child: AnimatedScaleWidget(
                        child: ElevatedButton(
                          onPressed: () => _login(),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                LocaleKeys.authLogIn.tr(),
                                  style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.white,
                                ),
                              ),
                              Space.hS3,
                              FlippableImage(
                                child: SvgAsset(
                                  Assets.images.svg.logIn.logOut,
                                  height: 18,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Space.vM4,
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: Color(0xFFF3F4F5),
                        borderRadius: BorderRadius.circular(9999),
                      ),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,

                          children: [Icon(Icons.info_outline,

                        color: Colors.grey.shade300,
                        size: 18,

                      ),
                      Space.hS3,
                        Text('تسجيل الدخول مخصص للمندوبين فقط',
                        style: TextStyle(
                          color: Colors.grey.shade300,
                          fontSize: 11
                        ),
                        )
                      
                      ]),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
