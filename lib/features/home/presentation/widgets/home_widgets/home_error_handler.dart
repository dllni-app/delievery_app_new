//
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
//
// import '../../../../../common/design/src/widgets/app_error_widget.dart';
// import '../../../../accessories/presentation/bloc/accessory_bloc.dart';
// import '../../../../banners/presentation/bloc/banners_bloc.dart';
// import '../../../../order/domin/use_cases/get_all_orders_use_case.dart';
// import '../../../../order/presentation/bloc/order_bloc.dart';
// import '../../../../service/presentation/bloc/service_bloc.dart';
//
// class HomeErrorWrapper extends StatelessWidget {
//   final BannersBloc bannersBloc;
//   final ServiceBloc serviceBloc;
//   final AccessoryBloc accessoryBloc;
//   final OrderBloc orderBloc;
//   final Widget child;
//
//   const HomeErrorWrapper({
//     super.key,
//     required this.bannersBloc,
//     required this.serviceBloc,
//     required this.accessoryBloc,
//     required this.orderBloc,
//     required this.child,
//   });
//
//   bool _hasError() {
//     return bannersBloc.state.getAllBannersData.isFailed ||
//         serviceBloc.state.getAllServicesData.isFailed ||
//         accessoryBloc.state.getAllAccessoriesData.isFailed ||
//         orderBloc.state.getAllOrderData.isFailed;
//   }
//
//   String _getErrorMessage() {
//     return bannersBloc.state.getAllBannersData.errorMessage ??
//         serviceBloc.state.getAllServicesData.errorMessage ??
//         accessoryBloc.state.getAllAccessoriesData.errorMessage ??
//         orderBloc.state.getAllOrderData.errorMessage ??
//         "Something went wrong";
//   }
//
//   void _onRefresh() {
//     bannersBloc.add(GetBannersEvent());
//     serviceBloc.add(GetAllServicesEvent());
//     accessoryBloc.add(GetAllAccessoriesEvent(isReload: true));
//     orderBloc.add(
//       GetAllOrdersEvent(
//         params: GetAllOrderParams(
//           status: OrderType.notFinished.name,
//         ),
//       ),
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return BlocBuilder<BannersBloc, BannersState>(
//       bloc: bannersBloc,
//       builder: (_, __) {
//         return BlocBuilder<ServiceBloc, ServiceState>(
//           bloc: serviceBloc,
//           builder: (_, __) {
//             return BlocBuilder<AccessoryBloc, AccessoryState>(
//               bloc: accessoryBloc,
//               builder: (_, __) {
//                 return BlocBuilder<OrderBloc, OrderState>(
//                   bloc: orderBloc,
//                   builder: (_, __) {
//
//                     /// ✅ هون صار Reactive 100%
//                     if (_hasError()) {
//                       return AppErrorWidgetReFresh(
//                         errorMessage: _getErrorMessage(),
//                         onTap: _onRefresh,
//                       );
//                     }
//
//                     return child;
//                   },
//                 );
//               },
//             );
//           },
//         );
//       },
//     );
//   }
// }