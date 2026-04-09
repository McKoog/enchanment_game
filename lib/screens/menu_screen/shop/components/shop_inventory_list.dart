import 'package:enchantment_game/models/item.dart';
import 'package:enchantment_game/models/scroll.dart';
import 'package:enchantment_game/screens/menu_screen/shop/shop_menu.dart' show ShopTab;
import 'package:flutter/material.dart';

import 'shop_list_item.dart';

class ShopInventoryList extends StatelessWidget {
  final ShopTab currentTab;
  final List<Item> buyItems;
  final List<Map<String, dynamic>> sellableItems;
  final String Function(Item) getItemName;
  final void Function(Item, int?, LayerLink) onItemTap;

  const ShopInventoryList({
    super.key,
    required this.currentTab,
    required this.buyItems,
    required this.sellableItems,
    required this.getItemName,
    required this.onItemTap,
  });

  @override
  Widget build(BuildContext context) {
    if (currentTab == ShopTab.buy) {
      return ListView.builder(
        itemCount: buyItems.length,
        itemBuilder: (context, index) {
          final item = buyItems[index];
          return ShopListItem(
            item: item,
            title: getItemName(item),
            subtitle: '${item.buyPrice} Gold',
            onTap: (layerLink) => onItemTap(item, null, layerLink),
          );
        },
      );
    } else {
      return ListView.builder(
        itemCount: sellableItems.length,
        itemBuilder: (context, index) {
          final data = sellableItems[index];
          final item = data['item'] as Item;
          final invIndex = data['index'] as int;
          int qty = 1;
          if (item is Scroll) qty = item.quantity;
          return ShopListItem(
            item: item,
            title: getItemName(item),
            subtitle: 'Quantity: $qty | ${item.sellPrice} Gold',
            onTap: (layerLink) => onItemTap(item, invIndex, layerLink),
          );
        },
      );
    }
  }
}
