import 'package:dllne_deliver_app/features/home/presentation/pages/nav_bar_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/di/injection.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../auth/presentation/pages/login_screen.dart';
import '../../../delivery/presentation/pages/delivery_disputes_page.dart';
import '../bloc/user_bloc.dart';

class MenuCard extends StatelessWidget {
  final VoidCallback onUpdateStatus;
  final VoidCallback onWallet;
  final VoidCallback onReports;
  final VoidCallback onNotifications;
  final VoidCallback onLogout;
  final Color primary;

  const MenuCard({
    super.key,
    required this.primary,
    required this.onUpdateStatus,
    required this.onWallet,
    required this.onReports,
    required this.onNotifications,
    required this.onLogout,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: Color(0x33000000),
            blurRadius: 12,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          MenuItem(
            icon: Icons.sync_rounded,
            label: 'تحديث الحالة',
            onTap: onUpdateStatus,
            iconBackground: Colors.grey.shade100,
            iconColor: primary,
            showChevron: true,
          ),
          _Divider(),
          MenuItem(
            icon: Icons.account_balance_wallet_outlined,
            label: 'المستحقات',
            onTap: onWallet,
            iconBackground: Colors.grey.shade100,
            iconColor: primary,
            showChevron: true,
          ),
          _Divider(),
          MenuItem(
            icon: Icons.report_problem_outlined,
            label: 'البلاغات',
            onTap: onReports,
            iconBackground: Colors.grey.shade100,
            iconColor: primary,
            showChevron: true,
          ),
          _Divider(),
          MenuItem(
            icon: Icons.notifications_none_rounded,
            label: 'الإشعارات',
            onTap: onNotifications,
            iconBackground: Colors.grey.shade100,
            iconColor: primary,
            showChevron: true,
          ),
          _Divider(),
          MenuItem(
            icon: Icons.logout_rounded,
            label: 'تسجيل الخروج',
            onTap: onLogout,
            iconBackground: Colors.red.withOpacity(0.10),
            iconColor: Colors.redAccent,
            labelColor: Colors.redAccent,
            showChevron: false,
          ),
        ],
      ),
    );
  }
}

class MenuItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final Color iconBackground;
  final Color iconColor;
  final Color? labelColor;
  final bool showChevron;

  const MenuItem({
    super.key,
    required this.icon,
    required this.label,
    required this.onTap,
    required this.iconBackground,
    required this.iconColor,
    this.labelColor,
    this.showChevron = true,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      splashColor: Colors.blueGrey.withOpacity(0.08),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: iconBackground,
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: iconColor),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  color: labelColor ?? const Color(0xFF111827),
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            if (showChevron) ...[
              const SizedBox(width: 8),
              Transform.flip(
                flipX: true,
                child: Icon(Icons.chevron_right_rounded, color: Colors.black54),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class NewMoreScreen extends StatefulWidget {
  const NewMoreScreen({super.key});

  @override
  State<NewMoreScreen> createState() => _NewMoreScreenState();
}

class ProfileCard extends StatelessWidget {
  final String userName;
  final String userPhone;
  final String userRole;
  final String vechial;
  final Color primary;

  const ProfileCard({
    super.key,
    required this.userName,
    required this.userPhone,
    required this.userRole,
    required this.vechial,
    required this.primary,
  });

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: const [
            BoxShadow(
              color: Color(0x33000000),
              blurRadius: 12,
              offset: Offset(0, 4),
            ),
          ],
        ),
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: primary.withOpacity(0.25),
                      width: 2,
                    ),
                  ),
                  child: CircleAvatar(
                    radius: 32,
                    backgroundColor: AppColors.primary,
                    child: Text(
                      userName.isEmpty ? '-' : userName[0].toUpperCase(),
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: -20,
                  left: -10,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: primary.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: Text(
                      vechial,
                      style: TextStyle(
                        color: AppColors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    userName,
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      color: Colors.black87,
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    spacing: 4,
                    children: [
                      Icon(
                        Icons.phone_iphone_rounded,
                        size: 18,
                        color: Colors.black54,
                      ),
                      Text(
                        userPhone,
                        style: const TextStyle(
                          color: Colors.black54,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                        textDirection: TextDirection.ltr,
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: primary.withOpacity(0.08),
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: Text(
                      userRole,
                      style: TextStyle(
                        color: primary,
                        fontWeight: FontWeight.w700,
                        fontSize: 13,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Divider extends StatelessWidget {
  const _Divider();

  @override
  Widget build(BuildContext context) {
    return const Divider(height: 1, thickness: 1, color: Color(0x1F000000));
  }
}

class _NewMoreScreenState extends State<NewMoreScreen> {
  late final UserBloc userBloc;

  @override
  Widget build(BuildContext context) {
    const Color primary = Color(0xFF021064);

    return BlocProvider.value(
      value: userBloc,
      child: SafeArea(
        top: false,
        child: BlocBuilder<UserBloc, UserState>(
          builder: (context, state) {
            if (state.getMeData.isLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state.getMeData.isFailed) {
              return Center(
                child: Column(
                  children: [
                    Text(state.getMeData.errorMessage),
                    ElevatedButton(
                      onPressed: () {
                        userBloc.add(UserGetMeEvent());
                      },
                      child: Text('اعادة المحاولة'),
                    ),
                  ],
                ),
              );
            } else if (state.getMeData.isSuccess) {
              return SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    ProfileCard(
                      userName: state.getMeData.data?.data?.firstName ?? '-',
                      userPhone: state.getMeData.data?.data?.phone ?? '-',
                      userRole: "مندوب مستقل",
                      vechial: state.getMeData.data?.data?.vehicleType ?? "-",
                      primary: primary,
                    ),
                    const SizedBox(height: 16),
                    MenuCard(
                      primary: primary,
                      onUpdateStatus: () {
                        homeCubit.changeIndex(0);
                      },
                      onWallet: () {
                        homeCubit.changeIndex(2);
                      },
                      onReports: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => const Scaffold(
                              appBar: _ReportsAppBar(),
                              body: DeliveryDisputesPage(),
                            ),
                          ),
                        );
                      },
                      onNotifications: () {
                        homeCubit.changeIndex(3);
                      },
                      onLogout: () {
                        SharedPreferences.getInstance().then((value) {
                          value.clear();
                        });
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (context) => LoginScreen(),
                          ),
                          (route) => false,
                        );
                      },
                    ),
                    const SizedBox(height: 12),
                  ],
                ),
              );
            }
            return SizedBox.shrink();
          },
        ),
      ),
    );
  }

  @override
  initState() {
    super.initState();
    userBloc = getIt<UserBloc>();
    userBloc.add(UserGetMeEvent());
  }
}

class _ReportsAppBar extends StatelessWidget implements PreferredSizeWidget {
  const _ReportsAppBar();

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: const Text('البلاغات'),
      centerTitle: false,
      backgroundColor: Colors.white,
      foregroundColor: AppColors.primary,
      elevation: 0,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
