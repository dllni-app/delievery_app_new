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
              icon: Icons.home,
              label: 'الرئيسية',
              selected: selectedIndex == 0,
              onTap: () => onTap(0),
            ),
            _BottomNavItem(
              icon: Icons.inventory_2_outlined,
              label: 'الطلبات',
              selected: selectedIndex == 1,
              onTap: () => onTap(1),
            ),
            _BottomNavItem(
              icon: Icons.payments_outlined,
              label: 'الإشعارات',
              selected: selectedIndex == 2,
              onTap: () => onTap(2),
            ),
            _BottomNavItem(
              icon: Icons.report_gmailerrorred_outlined,
              label: 'البلاغات',
              selected: selectedIndex == 3,
              onTap: () => onTap(3),
            ),
            _BottomNavItem(
              icon: Icons.menu,
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
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _BottomNavItem({
    required this.icon,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final foreground = selected ? AppColors.primary : const Color(0xFF767682);
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: SizedBox(
        width: 68,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 280),
          curve: Curves.easeOutCubic,
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 7),
          decoration: BoxDecoration(
            color: selected
                ? AppColors.primary.withValues(alpha: 0.12)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(16),
            border: selected
                ? Border.all(
                    color: AppColors.primary.withValues(alpha: 0.22),
                    width: 0.8,
                  )
                : null,
          ),
          child: AnimatedScale(
            duration: const Duration(milliseconds: 220),
            curve: Curves.easeOutBack,
            scale: selected ? 1 : 0.95,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 220),
                  curve: Curves.easeOutCubic,
                  padding: const EdgeInsets.all(2),
                  child: Icon(
                    icon,
                    color: foreground,
                    size: selected ? 24 : 22,
                  ),
                ),
                const SizedBox(height: 2),
                AnimatedDefaultTextStyle(
                  duration: const Duration(milliseconds: 220),
                  curve: Curves.easeOutCubic,
                  style: TextStyle(
                    fontFamily: 'Cairo',
                    fontSize: 11,
                    color: foreground,
                    fontWeight: selected ? FontWeight.w700 : FontWeight.w600,
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

