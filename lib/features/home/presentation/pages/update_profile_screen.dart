// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:u_bau/common/extensions/extensions.dart';
// import 'package:u_bau/core/di/injection.dart';
// import '../../../../common/design/src/widgets/awesomeDialog.dart';
// import '../../../auth/presentation/bloc/auth_bloc.dart';
// import '../widgets/update_profile_widget.dart';
//
//
// class UpdateProfilePage extends StatefulWidget {
//
//
//
//
//   @override
//   State<UpdateProfilePage> createState() => _UpdateProfilePageState();
// }
//
// class _UpdateProfilePageState extends State<UpdateProfilePage> {
//   late final AuthBloc authBloc;
//   @override
//   void initState() {
//     authBloc=getIt<AuthBloc>();
//     super.initState();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return BlocConsumer<AuthBloc, AuthState>(
//       bloc: authBloc,
//       listener: (context, state) {
//         state.updateMeData.listenerFunction(onSuccess: (){
//           GetAweomeDialog(context: context, fun: () {
//             context.pop();
//
//           }, sucMessage: 'Profile Update Success');
//
//         });
//       },
//       builder: (context, state) {
//         return UpdateBodyWidget(authBloc: authBloc,);
//       },
//     );
//   }
// }
//
