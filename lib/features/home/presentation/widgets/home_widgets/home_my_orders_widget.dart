// import 'package:evowash_user_flutter_app/common/extensions/extensions.dart';
// import 'package:evowash_user_flutter_app/core/di/injection.dart';
// import 'package:evowash_user_flutter_app/features/home/presentation/cubit/home_cubit.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_animate/flutter_animate.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import '../../../../../common/design/src/widgets/animation_widget/animated_title_text_widget.dart';
// import '../../../../../common/design/src/widgets/my_custom_widget/my_custom_buttons/solid_text_button_widget.dart';
// import '../../../../../common/helper/src/locale_keys.dart';
// import '../../../../order/domin/use_cases/get_all_orders_use_case.dart';
// import '../../../../order/presentation/bloc/order_bloc.dart';
// import '../../../../order/presentation/widgets/order_widget.dart';
// import 'home_order_loading_widget.dart';
//
// class HomeMyOrdersWidget extends StatelessWidget {
//   final OrderBloc orderBloc;
//
//
//   const HomeMyOrdersWidget({
//     super.key,
//     required this.orderBloc,
//
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return SliverToBoxAdapter(
//       child: BlocBuilder<OrderBloc, OrderState>(
//         bloc: orderBloc,
//         builder: (context, state) {
//           return state.getAllOrderData.builder(
//             onSuccess: (_) {
//               return state.getAllOrderData.data!.data!.isEmpty
//                   ? SizedBox()
//                   : Column(
//                       children: [
//                         Padding(
//                           padding: EdgeInsets.symmetric(horizontal: 20),
//                           child: Row(
//                             children: [
//                               AnimatedTitleTextWidget(
//                                 child: Text(
//                                   LocaleKeys.navBarMyOrders.tr(),
//                                   style: context.labelSmall(
//                                     fontSize: 20,
//                                     fontFamily: "Nasaq",
//                                   ),
//                                 ),
//                               ),
//                               Spacer(),
//                               AnimatedTitleTextWidget(
//                                 child: GestureDetector(
//                                   child: Text(
//                                     LocaleKeys.navBarViewAll.tr(),
//                                     style: context.displaySmall(fontSize: 16),
//                                   ),
//                                   onTap: () {
//
//                                     getIt<HomeCubit>().changeIndex(3);
//                                   },
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                         ListView.builder(
//                           padding: const EdgeInsets.symmetric(
//                             vertical: 24,
//                             horizontal: 20,
//                           ),
//
//
//                           itemCount: state.getAllOrderData.data!.data!.length
//                               .clamp(0, 2),
//                           itemBuilder: (context, index) {
//                             return OrderWidget(
//                               orderModel:
//                                   state.getAllOrderData.data!.data![index],
//                               orderBloc: orderBloc,
//                             );
//                           },
//                           shrinkWrap: true,
//                           physics: NeverScrollableScrollPhysics(),
//                         ),
//                       ],
//                     );
//             },
//
//             loadingWidget: HomeOrderLoadingWidget(),
//             failedWidget: Column(
//               children: [
//                 Text(
//                   state.getAllOrderData.errorMessage,
//                   style: context.bodySmall(fontSize: 16),
//                 ),
//
//                 Container(
//                   padding: EdgeInsets.symmetric(horizontal: 70, vertical: 20),
//                   child: SolidTextCenterButtonWidget(
//                     onTap: () {
//                       orderBloc.add(
//                         GetAllOrdersEvent(
//                           params: GetAllOrderParams(
//                             status: OrderType.notFinished.name,
//                           ),
//                         ),
//                       );
//                     },
//                     title: LocaleKeys.retry.tr(),
//                   ),
//                 ),
//               ],
//             ),
//
//             // emptyWidget: SizedBox(
//             //   height: context.height * .16,
//             //   child: Center(
//             //     child: Column(
//             //       mainAxisAlignment: MainAxisAlignment.start,
//             //       children: [
//             //         SvgAsset(
//             //           Assets.images.svg.noData,
//             //           height: context.height * .14,
//             //         ),
//             //         Text(
//             //           LocaleKeys.errorMassegeNocontent.tr(),
//             //           style: context.textTheme.titleSmall!.copyWith(
//             //             color: Colors.black,
//             //             fontSize: 12,
//             //           ),
//             //         ),
//             //       ],
//             //     ),
//             //   ),
//             // ),
//           );
//         },
//       ),
//     );
//   }
// }
