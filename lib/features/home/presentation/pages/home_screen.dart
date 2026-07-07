import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../common/design/src/theme/assets.gen.dart';
import '../../../../common/design/src/theme/const.dart';
import '../../../../common/design/src/widgets/animation_widget/animated_title_text_widget.dart';
import '../../../../common/extensions/src/context_extensions.dart';
import '../../../../common/helper/src/locale_keys.dart';
import '../../../../core/di/injection.dart';
import '../../../notification/presentation/bloc/notification_bloc.dart';
import '../../../notification/presentation/widgets/notification_widget.dart';
import '../widgets/home_service_widget.dart';
import '../widgets/home_widgets/home_banners_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  ValueNotifier<int> valueNotifier = ValueNotifier(-1);
  final CarouselSliderController _carouselController =
      CarouselSliderController();
  //
  // late final BannersBloc bannersBloc;
  late final NotificationBloc notificationBloc;

  @override
  void initState() {
    // bannersBloc = getIt<BannersBloc>()..add(GetBannersEvent());
    notificationBloc = getIt<NotificationBloc>()
      ..add(GetAllNotificationEvent(isReload: true));
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        // SliverPadding(
        //   padding: const EdgeInsets.only(top: 8, left: 20, right: 20),
        //   sliver: SliverToBoxAdapter(
        //     child: HomeBannersWidget(
        //       carouselController: _carouselController,
        //       bannersBloc: bannersBloc,
        //     ),
        //   ),
        // ),

        SliverPadding(
          padding: EdgeInsets.only(top: 40, left: 20, right: 20, bottom: 40),
          sliver: SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AnimatedTitleTextWidget(
                  child: Text(
                    LocaleKeys.navBarInquiries.tr(),
                    style: context.headlineSmall(
                      fontSize: 16,
                      color: context.primarySwatch,
                    ),
                  ),
                ),
                Space.vS3,
                IntrinsicHeight(
                  child: Row(
                    children: [
                      // HomeServiceWidget(
                      //   svgImage: Assets.images.svg.home.plane,
                      //   title: LocaleKeys.navBarAirShipping.tr(),
                      //   subTitle: LocaleKeys
                      //       .navBarInquireAboutFastAirShippingPrices
                      //       .tr(),
                      //   searchType: SearchType.air,
                      // ),
                      // Space.hM2,
                      //
                      // HomeServiceWidget(
                      //   svgImage: Assets.images.svg.home.boat,
                      //   title: LocaleKeys.navBarSeaShipping.tr(),
                      //   subTitle: LocaleKeys
                      //       .navBarEconomicalSolutionsForLargeShipments
                      //       .tr(),
                      //   searchType: SearchType.sea,
                      // ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),

        SliverToBoxAdapter(
          child: BlocBuilder<NotificationBloc, NotificationState>(
            bloc: notificationBloc,
            builder: (context, state) {
              return state.getAllNotification.builder(
                emptyWidget: SizedBox(),
                successWidet: () {
                  return Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        child:     Align(
                          alignment: AlignmentDirectional.centerStart,

                          child: AnimatedTitleTextWidget(
                            child: Text(
                              LocaleKeys.latestUpdates.tr(),
                              style: context.headlineSmall(
                                fontSize: 16,
                                color: context.primarySwatch
                              ),
                            ),
                          ),
                        ),
                      ),
                      ListView.builder(
                        padding: const EdgeInsets.symmetric(
                          vertical: 24,
                          horizontal: 20,
                        ),


                        itemCount: state.getAllNotification.list.length
                            .clamp(0, 2),
                        itemBuilder: (context, index) {
                          return NotificationWidget(
                            notification: state.getAllNotification.list[index] ,

                          );
                        },
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                      ),
                    ],
                  );
                },

                // loadingWidget: HomeOrderLoadingWidget(),
                failedWidget:Column(
                  children: [
                    Text(
                      state.getAllNotification.errorMessage,
                      style: context.bodySmall(fontSize: 16),
                      textAlign: TextAlign.center,
                    ),
                    Space.vM4,
                    SizedBox(
                      width: context.width * .7,
                      child: ElevatedButton(
                        onPressed: () {
                          notificationBloc.add(GetAllNotificationEvent(
                            isReload: true
                          ));
                        },
                        child: Text(LocaleKeys.retry.tr(),style: context.bodyMedium(
                            color: Colors.white
                        ),),
                      ),
                    ),
                  ],
                )

                // emptyWidget: SizedBox(
                //   height: context.height * .16,
                //   child: Center(
                //     child: Column(
                //       mainAxisAlignment: MainAxisAlignment.start,
                //       children: [
                //         SvgAsset(
                //           Assets.images.svg.noData,
                //           height: context.height * .14,
                //         ),
                //         Text(
                //           LocaleKeys.errorMassegeNocontent.tr(),
                //           style: context.textTheme.titleSmall!.copyWith(
                //             color: Colors.black,
                //             fontSize: 12,
                //           ),
                //         ),
                //       ],
                //     ),
                //   ),
                // ),
              );
            },
          ),
        )

      ],
    );
  }
}
