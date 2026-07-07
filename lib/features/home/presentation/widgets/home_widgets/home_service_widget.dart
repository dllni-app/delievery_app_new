// import 'package:evowash_user_flutter_app/common/design/design.dart';
// import 'package:evowash_user_flutter_app/common/extensions/extensions.dart';
// import 'package:evowash_user_flutter_app/common/models/service_model.dart';
// import 'package:evowash_user_flutter_app/features/service/presentation/bloc/service_bloc.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_animate/flutter_animate.dart';
//
// import '../../../../../common/design/src/theme/assets.gen.dart';
// import '../../../../../common/design/src/widgets/animation_widget/animated_scale_widget.dart';
// import '../../../../../common/design/src/widgets/svg_asset.dart';
// import '../../../../../router/app_router.dart';
// import '../../../../order/presentation/pages/order_washing_screen.dart';
//
// class HomeServiceWidget extends StatelessWidget {
//   final ServiceBloc serviceBloc;
//   final ServiceModel service;
//
//   const HomeServiceWidget({
//     super.key,
//     required this.serviceBloc,
//     required this.service,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return AnimatedScaleWidget(
//       child: GestureDetector(
//         onTap:
//             () => context.pushNamed(
//               RouteName.orderWashingScreen,
//               arguments: OrderWashingParams(
//                 serviceBloc: serviceBloc,
//                 serviceModel: service,
//               ),
//             ),
//         child: Container(
//           margin: EdgeInsets.symmetric(horizontal: 8),
//           child: Column(
//             children: [
//               Container(
//                 decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(16),
//                   gradient: LinearGradient(
//                     colors: [
//                       context.borderGradientStartColor,
//                       context.borderGradientEndColor,
//                     ],
//                     begin: Alignment.topCenter,
//                     end: Alignment.bottomCenter,
//                   ),
//                 ),
//                 width: context.width * .155,
//                 height: context.width * .155,
//                 padding: EdgeInsets.all(3),
//                 child: Container(
//                   padding: EdgeInsets.all( 12),
//                   decoration: BoxDecoration(
//                     borderRadius: BorderRadius.circular(16),
//                     color: context.primarySwatch,
//                   ),
//                   child: Center(child:
//                   service.image?.url==null?
//                   Assets.images.png.failedImageLogo.image():
//                   CacheNetworkImage(imageUrl: service.image!.url!)
//
//                   ),
//                 ),
//               ),
//               Expanded(
//                 child: Container(
//                   width: context.width * .2,
//                   margin: EdgeInsets.only(top: 4),
//
//                   child: Text(
//                     service.name!,
//                     style: context.bodySmall(fontSize: 12),
//                     overflow: TextOverflow.ellipsis,
//                     textAlign: TextAlign.center,
//                     maxLines: 2,
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
