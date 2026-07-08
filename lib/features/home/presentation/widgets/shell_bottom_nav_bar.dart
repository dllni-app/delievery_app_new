import 'package:flutter/material.dart';

import '../../../../core/utils/app_colors.dart';

class ShellBottomNavBar extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onTap;

  const ShellBottomNavBar({
    super.key,
    required this.selectedIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: .06),
            blurRadius: 12,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
      child: SafeArea(
        top: false,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _BottomNavItem(
              icon: Icons.home_outlined,
              selectedIcon: Icons.home,
              label: 'الرئيسية',
              selected: selectedIndex == 0,
              onTap: () => onTap(0),
            ),
            _BottomNavItem(
              icon: Icons.inventory_2_outlined,
              selectedIcon: Icons.inventory_2,
              label: 'الطلبات',
              selected: selectedIndex == 1,
              onTap: () => onTap(1),
            ),
            _BottomNavItem(
              icon: Icons.payments_outlined,
              selectedIcon: Icons.payments,
              label: 'المالية',
              selected: selectedIndex == 2,
              onTap: () => onTap(2),
            ),
            _BottomNavItem(
              icon: Icons.notifications_none,
              selectedIcon: Icons.notifications,
              label: 'الإشعارات',
              selected: selectedIndex == 3,
              onTap: () => onTap(3),
            ),
            _BottomNavItem(
              icon: Icons.menu,
              selectedIcon: Icons.menu,
              label: 'المزيد',
              selected: selectedIndex == 4,
              onTap: () => onTap(4),
            ),
          ],
        ),
      ),
    );
  }
}

class _BottomNavItem extends StatelessWidget {
  final IconData icon;
  final IconData selectedIcon;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _BottomNavItem({
    required this.icon,
    required this.selectedIcon,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final foreground = selected ? AppColors.primary : const Color(0xFF454651);
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: SizedBox(
        width: 68,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 280),
          curve: Curves.easeOutCubic,
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 7),
          decoration: BoxDecoration(
            color: selected
                ? AppColors.secondary.withValues(alpha: 0.92)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(18),
          ),
          child: AnimatedScale(
            duration: const Duration(milliseconds: 220),
            curve: Curves.easeOutBack,
            scale: selected ? 1 : 0.95,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  selected ? selectedIcon : icon,
                  color: selected ? Colors.white : foreground,
                  size: selected ? 24 : 22,
                ),
                const SizedBox(height: 2),
                AnimatedDefaultTextStyle(
                  duration: const Duration(milliseconds: 220),
                  curve: Curves.easeOutCubic,
                  style: TextStyle(
                    fontFamily: 'Cairo',
                    fontSize: 11,
                    color: selected ? Colors.white : foreground,
                    fontWeight: selected ? FontWeight.w800 : FontWeight.w600,
                    height: 1.15,
                  ),
                  child: Text(
                    label,
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
