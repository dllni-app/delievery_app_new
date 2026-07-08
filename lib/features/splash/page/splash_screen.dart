import 'package:dllne_deliver_app/features/splash/page/show_version_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../common/design/src/theme/assets.gen.dart';
import '../../../common/design/src/theme/theme/theme_collection.dart';
import '../../../common/extensions/src/context_extensions.dart';
import '../../../core/di/injection.dart';
import '../../../core/utils/app_colors.dart';
import '../../../router/app_router.dart';
import 'cubit/splash_cubit.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  late final SplashCubit splashCubit;

  @override
  void initState() {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        systemNavigationBarColor: ThemeCollection.lightTheme.primaryColor,
        systemNavigationBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.light,

      ),
    );

    super.initState();
    splashCubit = getIt<SplashCubit>();
    // splashCubit = getIt<SplashCubit>()..checkVersion();


    Future.delayed(const Duration(seconds: 1)).then((value) {
      splashCubit.checkNavigator();
    });
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<SplashCubit, SplashState>(
          bloc: splashCubit,
          // listenWhen:
          //     (previous, current) =>
          //         previous.getVersionData.status !=
          //         current.getVersionData.status,
          listener: (context, state) {
            // if (state.getVersionData.isSuccess) {
            //   if (state.getVersionData.data!.updateRequired == true) {
            //     showVersionDialog(
            //       context: context,
            //       storeUrl: state.getVersionData.data?.storeUrl,
            //     );
            //   }
            //   else if (state.getVersionData.data!.updateAvailable == true &&
            //       state.getVersionData.data!.updateRequired == false)
            //   {
            //     showVersionDialogOptional(
            //       context: context,
            //       storeUrl: state.getVersionData.data?.storeUrl,
            //       after: () {
            //         splashCubit.checkNavigator();
            //       },
            //     );
            //   } else {
            //     Future.delayed(const Duration(seconds: 1)).then((value) {
            //       splashCubit.checkNavigator();
            //     });
            //   }
            // }
          },
        ),

        BlocListener<SplashCubit, SplashState>(
          bloc: splashCubit,
          listenWhen:
              (previous, current) =>
                  previous.splashStatus != current.splashStatus,
          listener: (context, state) {
            if (state.splashStatus == SplashStatus.isAuth) {
              context.pushReplacementNamed(RouteName.homeNav);
            } else if (state.splashStatus == SplashStatus.unauthorized) {
              context.pushReplacementNamed(RouteName.login);
            }
          },
        ),
      ],

      child: Scaffold(
        body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          color: AppColors.primary,
          child:  Center(
            child: Assets.images.png.logoWhitle.image(
              width: MediaQuery.of(context).size.width*.5,

              fit: BoxFit.cover,
            ),
          ),
          // Stack(
          //   alignment: Alignment.bottomCenter,
          //   children: [
          //     Center(
          //       child: Assets.images.png.logoWhitle.image(
          //         width: context.width*.5,
          //
          //         fit: BoxFit.cover,
          //       ),
          //     ),
          //
          //     // Positioned(
          //     //   bottom: context.navigationBarHeight + context.height * .1,
          //     //   child: BlocBuilder<SplashCubit, SplashState>(
          //     //     bloc: splashCubit,
          //     //     builder: (context, state) {
          //     //       return state.getVersionData.builder(
          //     //         onSuccess: (_) {
          //     //           return const SizedBox();
          //     //         },
          //     //
          //     //         loadingWidget: CircularProgressIndicator(
          //     //           color: Colors.white,
          //     //         ),
          //     //
          //     //         failedWidget: SizedBox(
          //     //           width: context.width,
          //     //           child: Padding(
          //     //             padding: const EdgeInsets.symmetric(horizontal: 20),
          //     //             child: Column(
          //     //               children: [
          //     //                 IconButton(
          //     //                   onPressed: () {
          //     //                     splashCubit.checkVersion();
          //     //                   },
          //     //                   icon: Icon(
          //     //                     Icons.refresh,
          //     //                     color: Colors.white,
          //     //                     size: 50,
          //     //                   ),
          //     //                 ),
          //     //
          //     //                 Text(
          //     //                   state.getVersionData.errorMessage,
          //     //                   style: context.titleSmall(color: Colors.white),
          //     //                   softWrap: true,
          //     //                   textAlign: TextAlign.center,
          //     //                 ),
          //     //               ],
          //     //             ),
          //     //           ),
          //     //         ),
          //     //       );
          //     //     },
          //     //   ),
          //     // ),
          //   ],
          // ),
        ),
      ),
    );
  }
}
