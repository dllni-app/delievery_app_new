// import 'package:evowash_user_flutter_app/common/design/src/widgets/animation_widget/animated_title_text_widget.dart';
// import 'package:evowash_user_flutter_app/common/extensions/extensions.dart';
// import 'package:evowash_user_flutter_app/core/di/injection.dart';
// import 'package:evowash_user_flutter_app/features/home/presentation/cubit/home_cubit.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import '../../../../../common/design/src/widgets/my_custom_widget/my_custom_buttons/solid_text_button_widget.dart';
// import '../../../../../common/helper/src/locale_keys.dart';
// import '../../../../accessories/presentation/bloc/accessory_bloc.dart';
// import '../../../../accessories/presentation/widgets/accessories_widget.dart';
// import '../accessory_loading_widget.dart';
//
// class HomeAccessoryWidget extends StatelessWidget {
//   final AccessoryBloc accessoryBloc;
//
//   const HomeAccessoryWidget({super.key, required this.accessoryBloc});
//
//   @override
//   Widget build(BuildContext context) {
//     return SliverToBoxAdapter(
//       child: BlocBuilder<AccessoryBloc, AccessoryState>(
//         bloc: accessoryBloc,
//         builder: (context, state) {
//           return state.getAllAccessoriesData.builder(
//             successWidet: () {
//               return state.getAllAccessoriesData.list.isEmpty
//                   ? SizedBox()
//                   : Column(
//                     children: [
//                       Padding(
//                         padding: EdgeInsets.symmetric(horizontal: 20),
//                         child: Row(
//                           children: [
//                             AnimatedTitleTextWidget(
//                               child: Text(
//                                 LocaleKeys.navBarAccessories.tr(),
//                                 style: context.labelSmall(
//                                   fontSize: 20,
//                                   fontFamily: "Nasaq",
//                                 ),
//                               ),
//                             ),
//                             Spacer(),
//                             AnimatedTitleTextWidget(
//                               child: GestureDetector(
//                                 child: Text(
//                                   LocaleKeys.navBarViewAll.tr(),
//                                   style: context.displaySmall(fontSize: 16),
//                                 ),
//                                 onTap: () {
//                                   getIt<HomeCubit>().changeIndex(2);
//                                 },
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                       ListView.builder(
//                         padding: const EdgeInsets.symmetric(
//                           vertical: 24,
//                           horizontal: 20,
//                         ),
//
//                         itemCount: state.getAllAccessoriesData.list.length
//                             .clamp(0, 2),
//                         itemBuilder: (context, index) {
//                           return Padding(
//                             padding: const EdgeInsets.only(bottom: 16),
//                             child: AccessoriesWidget(
//                               accessoryModel:
//                                   state.getAllAccessoriesData.list[index]!,
//                               accessoryBloc: accessoryBloc,
//                             ),
//                           );
//                         },
//                         physics: NeverScrollableScrollPhysics(),
//                         shrinkWrap: true,
//                       ),
//                     ],
//                   );
//             },
//
//             loadingWidget: AccessoryLoadingWidget(),
//             failedWidget: Column(
//               children: [
//                 Text(
//                   state.getAllAccessoriesData.errorMessage,
//                   style: context.bodySmall(fontSize: 16),
//                 ),
//
//                 Container(
//                   padding: EdgeInsets.symmetric(horizontal: 70, vertical: 20),
//                   child: SolidTextCenterButtonWidget(
//                     onTap: () {
//                       accessoryBloc.add(GetAllAccessoriesEvent(isReload: true));
//                     },
//                     title: LocaleKeys.retry.tr(),
//                   ),
//                 ),
//               ],
//             ),
//
//           );
//         },
//       ),
//     );
//   }
// }
