// import 'package:evowash_user_flutter_app/common/extensions/extensions.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import '../../../../common/design/src/theme/assets.gen.dart';
// import '../../../../common/design/src/widgets/cach_network_image.dart';
// import '../../../../common/design/src/widgets/my_custom_widget/rotating_widget.dart';
// import '../../../../common/design/src/widgets/svg_asset.dart';
// import '../../../../common/helper/src/locale_keys.dart';
// import '../../../../router/app_router.dart';
// import '../../../cart/presentation/bloc/cart_bloc.dart';
// import '../../../cart/presentation/pages/accessories_order_screen.dart';
//
// class HomeCartWidget extends StatelessWidget {
//   final CartBloc cartBloc;
//
//   const HomeCartWidget({super.key, required this.cartBloc});
//
//   @override
//   Widget build(BuildContext context) {
//     return BlocBuilder<CartBloc, CartState>(
//       bloc: cartBloc,
//       builder: (context, state) {
//         return state.getCartData.builder(
//           onSuccess: (_) {
//             return state.getCartData.data!.data!.accessories!.isEmpty
//                 ? SizedBox()
//                 : GestureDetector(
//                   child: Container(
//                     color: Colors.white,
//                     width: context.width,
//                     padding: EdgeInsetsDirectional.symmetric(
//                       vertical: 16,
//                       horizontal: 20,
//                     ),
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         Row(
//                           mainAxisSize: MainAxisSize.max,
//                           children: [
//                             Text(
//                               LocaleKeys.accessoriesOrderList.tr(),
//                               style: context.displaySmall(
//                                 color: context.primarySwatch,
//                                 fontSize: 16,
//                               ),
//                             ),
//                             SizedBox(width: 8),
//                             FlippableImage(
//                               child: SvgAsset(
//                                Assets.images.svg.nextArrowIcon,
//                                 color: context.primarySwatch,
//
//                               ),
//                             ),
//                           ],
//                         ),
//                         SizedBox(
//                           height: context.width * .06,
//                           child: ListView.builder(
//                             scrollDirection: Axis.horizontal,
//                             physics: NeverScrollableScrollPhysics(),
//                             shrinkWrap: true,
//                             itemBuilder: (context, index) {
//                               return Container(
//                                 decoration: BoxDecoration(
//                                   color: Colors.white,
//                                   shape: BoxShape.circle,
//                                 ),
//                                 padding: EdgeInsets.all(2),
//                                 child:
//                                     (state
//                                                     .getCartData
//                                                     .data!
//                                                     .data!
//                                                     .accessories![index]
//                                                     .images ==
//                                                 null ||
//                                             state
//                                                 .getCartData
//                                                 .data!
//                                                 .data!
//                                                 .accessories![index]
//                                                 .images!
//                                                 .isEmpty ||
//                                             state
//                                                     .getCartData
//                                                     .data!
//                                                     .data!
//                                                     .accessories![index]
//                                                     .images![0]
//                                                     .url ==
//                                                 null)
//                                         ? SizedBox(
//                                           child: ClipOval(
//                                             child: Assets.images.png.testImage
//                                                 .image(
//                                                   width: context.width * .05,
//                                                   height: context.width * .05,
//                                                   fit: BoxFit.cover,
//                                                 ),
//                                           ),
//                                         )
//                                         : CacheNetworkImage(
//                                           imageUrl:
//                                               state
//                                                   .getCartData
//                                                   .data!
//                                                   .data!
//                                                   .accessories![index]
//                                                   .images![0]
//                                                   .url!,
//                                           width: context.width * .05,
//                                           height: context.width * .05,
//                                           shape: BoxShape.circle,
//                                         ),
//                               );
//                             },
//                             itemCount: state
//                                 .getCartData
//                                 .data!
//                                 .data!
//                                 .accessories!
//                                 .length
//                                 .clamp(0, 3),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                   onTap: () {
//                     context.pushNamed(
//                       RouteName.accessoriesOrder,
//                       arguments: AccessoriesOrderScreenParams(
//                         cartBloc: cartBloc,
//                       ),
//                     );
//                   },
//                 );
//           },
//           loadingWidget: SizedBox(),
//           failedWidget: SizedBox(),
//
//         );
//       },
//     );
//   }
// }
//
// //loadingWidget: SizedBox(
// //                       height: context.width * .06,
// //                       child: ListView.builder(
// //                         scrollDirection: Axis.horizontal,
// //                         physics: NeverScrollableScrollPhysics(),
// //
// //                         shrinkWrap: true,
// //                         itemBuilder: (context, index) {
// //                           return ShimmerWidget(
// //                             shape: BoxShape.circle,
// //                             width: context.width * .05,
// //                             height: context.width * .05,
// //                           );
// //                         },
// //                         itemCount: 3,
// //                       ),
// //                     ),
// //                     failedWidget: SizedBox(),
