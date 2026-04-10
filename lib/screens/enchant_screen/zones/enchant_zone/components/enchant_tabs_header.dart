import 'package:enchantment_game/theme/app_colors.dart';
import 'package:enchantment_game/theme/app_typography.dart';
import 'package:flutter/material.dart';

enum EnchantTab { stats, effects }

class EnchantTabsHeader extends StatelessWidget {
  final EnchantTab currentTab;
  final ValueChanged<EnchantTab> onTabChanged;

  const EnchantTabsHeader({
    super.key,
    required this.currentTab,
    required this.onTabChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Expanded(child: _buildTab(EnchantTab.stats, 'Stats')),
        Expanded(child: _buildTab(EnchantTab.effects, 'Effects')),
      ],
    );
  }

  Widget _buildTab(EnchantTab tab, String label) {
    final isSelected = currentTab == tab;
    return GestureDetector(
      onTap: () => onTabChanged(tab),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.borderHighlight : AppColors.overlayLight,
        ),
        child: Center(
          child: Text(
            label,
            style: AppTypography.bodyMediumPrimary.copyWith(
              color: isSelected ? AppColors.primaryText : AppColors.secondaryText,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
