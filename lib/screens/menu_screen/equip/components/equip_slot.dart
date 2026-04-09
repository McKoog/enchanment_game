import 'package:enchantment_game/theme/app_decorations.dart';
import 'package:enchantment_game/models/armor.dart';
import 'package:enchantment_game/models/item.dart';
import 'package:enchantment_game/models/weapon.dart';
import 'package:flutter/material.dart';

class EquipSlot extends StatelessWidget {
  const EquipSlot({
    super.key,
    required this.item,
    required this.bgIconPath,
    required this.isSelected,
    required this.onTap,
  });

  final Item? item;
  final String bgIconPath;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: (AppDecorations.inventorySlot as BoxDecoration).copyWith(
              border: isSelected
                  ? Border.all(color: Colors.yellow, width: 2)
                  : (AppDecorations.inventorySlot as BoxDecoration).border,
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Background Icon
                Opacity(
                  opacity: item == null ? 0.6 : 0,
                  child: Image.asset(
                    bgIconPath,
                    fit: BoxFit.contain,
                    width: 80,
                    height: 80,
                    color: Colors.white54,
                  ),
                ),
                // Equipped Item
                if (item != null)
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Image.asset(item!.image),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          SizedBox(
            width: 100,
            child: Text(
              item == null
                  ? "Empty"
                  : (item is Weapon
                      ? ((item as Weapon).enchantLevel > 0
                          ? "${(item as Weapon).name} +${(item as Weapon).enchantLevel}"
                          : (item as Weapon).name)
                      : (item is Armor
                          ? ((item as Armor).enchantLevel > 0
                              ? "${(item as Armor).name} +${(item as Armor).enchantLevel}"
                              : (item as Armor).name)
                          : '')),
              style: const TextStyle(
                fontSize: 12,
                color: Colors.white70,
                fontFamily: 'PT Sans',
              ),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
