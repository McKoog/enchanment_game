import 'package:enchantment_game/screens/menu_screen/shop/shop_menu.dart' show ShopTab;
import 'package:enchantment_game/theme/app_colors.dart';
import 'package:enchantment_game/theme/app_typography.dart';
import 'package:flutter/material.dart';

class ShopTabsHeader extends StatelessWidget {
  final ShopTab currentTab;
  final ValueChanged<ShopTab> onTabChanged;

  const ShopTabsHeader({
    super.key,
    required this.currentTab,
    required this.onTabChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Expanded(child: _buildTab(ShopTab.buy, 'Buy')),
        Expanded(child: _buildTab(ShopTab.sell, 'Sell')),
      ],
    );
  }

  Widget _buildTab(ShopTab tab, String label) {
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
