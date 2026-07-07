//
// import 'package:evowash_user_flutter_app/common/extensions/extensions.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
//
// import '../../../../../common/design/src/widgets/my_custom_widget/my_custom_buttons/solid_text_button_widget.dart';
// import '../../../../../common/helper/src/locale_keys.dart';
// import '../../../../service/presentation/bloc/service_bloc.dart';
// import 'home_service_loading_widget.dart';
// import 'home_service_widget.dart';
//
// class HomeServicesWidget extends StatelessWidget {
//   final ServiceBloc serviceBloc;
//
//   const HomeServicesWidget({super.key, required this.serviceBloc});
//
//
//   @override
//   Widget build(BuildContext context) {
//     return   SliverPadding(
//       padding: const EdgeInsets.symmetric(vertical: 16),
//
//       sliver: SliverToBoxAdapter(
//         child: BlocBuilder<ServiceBloc, ServiceState>(
//           bloc: serviceBloc,
//           builder: (context, state) {
//             return state.getAllServicesData.builder(
//               onSuccess: (_) {
//                 return SizedBox(
//                   height: context.width * .28,
//                   child: ListView.builder(
//                     scrollDirection: Axis.horizontal,
//                     itemBuilder: (context, index) {
//                       return HomeServiceWidget(
//                         serviceBloc: serviceBloc,
//                         service:
//                         state.getAllServicesData.data!.data![index],
//                       );
//                     },
//                     itemCount: state.getAllServicesData.data!.data!.length,
//                   ),
//                 );
//               },
//               failedWidget: Column(
//                 children: [
//                   Text(
//                     state.getAllServicesData.errorMessage,
//                     style: context.bodySmall(fontSize: 16),
//                   ),
//
//                   Container(
//                     padding: EdgeInsets.symmetric(
//                       horizontal: 70,
//                       vertical: 20,
//                     ),
//                     child: SolidTextCenterButtonWidget(
//                       onTap: () {
//                         serviceBloc.add(GetAllServicesEvent());
//                       },
//                       title: LocaleKeys.retry.tr(),
//                     ),
//                   ),
//                 ],
//               ),
//               loadingWidget: SizedBox(
//                   height: context.width * .28,
//
//                   child: HomeServiceLoadingWidget()),
//             );
//           },
//         ),
//       ),
//     );
//   }
// }
