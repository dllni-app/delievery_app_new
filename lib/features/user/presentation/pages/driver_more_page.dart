import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../common/design/src/theme/const.dart';
import '../../../../common/extensions/src/context_extensions.dart';
import '../../../../common/helper/src/locale_keys.dart';
import '../../../../core/di/injection.dart';
import '../../../../router/app_router.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../delivery/presentation/widgets/delivery_widgets.dart';
import '../bloc/user_bloc.dart';

class DriverMorePage extends StatefulWidget {
  const DriverMorePage({super.key});

  @override
  State<DriverMorePage> createState() => _DriverMorePageState();
}

class _DriverMorePageState extends State<DriverMorePage> {
  late final UserBloc userBloc;
  late final AuthBloc authBloc;

  @override
  void initState() {
    userBloc = getIt<UserBloc>()..add(DriverGetMeEvent());
    authBloc = getIt<AuthBloc>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      bloc: authBloc,
      listener: (context, state) {
        state.logOutData.listenerFunction(
          onSuccess: () {
            context.pushNamedAndRemoveUntil(RouteName.splash, (e) => false);
          },
        );
      },
      child: BlocBuilder<UserBloc, UserState>(
        bloc: userBloc,
        builder: (context, state) {
          return state.driverGetMeData.builder(
            onSuccess: (_) {
              final driver = state.driverGetMeData.data!.data!;

              return ListView(
                padding: PEdgeInsets.all,
                children: [
                  DeliveryCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          LocaleKeys.profilePersonalAccount.tr(),
                          style: context.headlineSmall(fontSize: 18),
                        ),
                        Space.vM1,
                        _ProfileLine(
                          label: LocaleKeys.profileFirstNameEdit.tr(),
                          value: driver.firstName,
                        ),
                        _ProfileLine(
                          label: LocaleKeys.authEnterPhone.tr(),
                          value: driver.phone,
                        ),
                        _ProfileLine(label: 'المركبة', value: driver.vehicleType),
                        _ProfileLine(label: 'اللوحة', value: driver.plateNumber),
                      ],
                    ),
                  ),
                  Space.vM2,
                  DeliveryPrimaryButton(
                    label: LocaleKeys.drawerLogOut.tr(),
                    icon: Icons.logout,
                    isDanger: true,
                    onPressed: () => authBloc.add(LogOutEvent()),
                  ),
                ],
              );
            },
            onTapRetry: () => userBloc.add(DriverGetMeEvent()),
          );
        },
      ),
    );
  }
}

class _ProfileLine extends StatelessWidget {
  const _ProfileLine({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: context.bodyMedium(
                fontSize: 14,
                color: context.onSurfaceVariantColor,
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              value,
              style: context.headlineSmall(fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }
}
