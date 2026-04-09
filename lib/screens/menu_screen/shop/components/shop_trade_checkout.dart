import 'package:enchantment_game/models/item.dart';
import 'package:enchantment_game/screens/menu_screen/shop/shop_menu.dart' show ShopTab, TradeItem;
import 'package:flutter/material.dart';
import 'package:enchantment_game/theme/app_colors.dart';
import 'package:enchantment_game/theme/app_typography.dart';

class ShopTradeCheckout extends StatelessWidget {
  final List<TradeItem> tradeList;
  final ShopTab currentTab;
  final int totalSum;
  final bool canConfirm;
  final String Function(Item) getItemName;
  final void Function(int) onRemoveItem;
  final VoidCallback onConfirm;

  const ShopTradeCheckout({
    super.key,
    required this.tradeList,
    required this.currentTab,
    required this.totalSum,
    required this.canConfirm,
    required this.getItemName,
    required this.onRemoveItem,
    required this.onConfirm,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text('Trade List',
            style: AppTypography.bodyLargeHighlight.copyWith(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        Expanded(
          flex: 1,
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.borderHighlight),
              borderRadius: BorderRadius.circular(8),
            ),
            child: ListView.builder(
              itemCount: tradeList.length,
              itemBuilder: (context, index) {
                final trade = tradeList[index];
                final price = currentTab == ShopTab.buy
                    ? trade.item.buyPrice
                    : trade.item.sellPrice;
                return ListTile(
                  leading:
                      Image.asset(trade.item.image, width: 40, height: 40),
                  title: Text(getItemName(trade.item), style: AppTypography.bodySmallPrimary),
                  subtitle: Text(
                      'Quantity: ${trade.quantity} | Total: ${price * trade.quantity} G', style: AppTypography.attributeLabel),
                  trailing: IconButton(
                    icon: const Icon(Icons.remove_circle, color: AppColors.error),
                    onPressed: () => onRemoveItem(index),
                  ),
                );
              },
            ),
          ),
        ),
        const SizedBox(height: 8),
        // Total & Confirm
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text('Total: $totalSum Gold',
                style: AppTypography.bodyLargeHighlight.copyWith(fontWeight: FontWeight.bold)),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.success.withValues(alpha: 0.2),
                padding:
                    const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: BorderSide(
                      color: AppColors.borderHighlight, width: 1),
                ),
              ),
              onPressed: canConfirm ? onConfirm : null,
              child: Text(
                'Confirm Deal',
                style: AppTypography.bodyMediumPrimary.copyWith(color: AppColors.accentYellow),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
