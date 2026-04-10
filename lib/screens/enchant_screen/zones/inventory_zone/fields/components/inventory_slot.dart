import 'package:enchantment_game/theme/enchanted_weapons_glow_colors.dart';
import 'package:enchantment_game/theme/app_decorations.dart';
import 'package:enchantment_game/models/item.dart';
import 'package:enchantment_game/models/scroll.dart';
import 'package:enchantment_game/models/weapon.dart';
import 'package:enchantment_game/models/armor.dart';
import 'package:enchantment_game/theme/app_colors.dart';
import 'package:enchantment_game/theme/app_typography.dart';
import 'package:enchantment_game/screens/enchant_screen/zones/inventory_zone/fields/components/inventory_drag_target.dart';
import 'package:enchantment_game/screens/enchant_screen/zones/inventory_zone/fields/components/inventory_draggable_item.dart';
import 'package:flutter/material.dart';

// TODO: Переписать на дженерик
class InventorySlot extends StatelessWidget {
  const InventorySlot(
      {super.key,
      required this.index,
      this.item,
      this.canBeDragged = true,
      this.canBeDragTarget = true,
      this.isPersistent = false,
      this.onTap});

  final int index;
  final Item? item;

  final bool canBeDragged;
  final bool canBeDragTarget;
  final bool isPersistent;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    Weapon? weapon;
    Armor? armor;
    if (item != null && item!.type == ItemType.weapon) weapon = item as Weapon;
    if (item != null && item!.type == ItemType.armor) armor = item as Armor;
    final scroll = item is Scroll ? item as Scroll : null;

    int enchantLevel = 0;
    if (weapon != null) enchantLevel = weapon.enchantLevel;
    if (armor != null) enchantLevel = armor.enchantLevel;

    return GestureDetector(
      onTap: onTap,
      child: Stack(
        alignment: Alignment.center,
        fit: StackFit.expand,
        children: [
          Container(
              padding: const EdgeInsets.all(5),
              decoration: (weapon != null || armor != null)
                  ? BoxDecoration(
                      color: enchantLevel < 16
                          ? AppColors.slotBackground
                              .withValues(alpha: 1 - (0.0666 * enchantLevel))
                          : enchantLevel < 21
                              ? AppColors.slotBackground.withValues(
                                  alpha: 0.5 - (0.06 * (enchantLevel % 16)))
                              : Colors.grey.shade900.withValues(alpha: 0.25),
                      border: isPersistent
                          ? Border.all(color: AppColors.success, width: 2)
                          : Border.all(color: AppColors.panelBorder, width: 2),
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: enchantLevel == 0
                          ? null
                          : enchantLevel > 20
                              ? [
                                  BoxShadow(
                                      color: enchantedWeaponsGlowColors[21],
                                      spreadRadius: 0.3)
                                ]
                              : [
                                  BoxShadow(
                                      color: enchantedWeaponsGlowColors[
                                          enchantLevel],
                                      spreadRadius: 0.3)
                                ])
                  : (AppDecorations.inventorySlot as BoxDecoration).copyWith(
                      border: isPersistent
                          ? Border.all(color: AppColors.success, width: 2)
                          : null),
              child: item != null
                  ? InventoryDragTarget(
                      inventoryIndex: index,
                      canBeDragTarget: canBeDragTarget,
                      child: InventoryDraggableItem(
                        item: item!,
                        inventoryIndex: index,
                        isDraggable: canBeDragged,
                      ),
                    )
                  : InventoryDragTarget(
                      inventoryIndex: index,
                      canBeDragTarget: canBeDragTarget,
                    )),
          // TODO: добавить проверку видимости зачарования
          if ((weapon != null || armor != null) /*&& enchantVisible*/)
            Positioned(
                right: 8,
                bottom: 8,
                child: Text(
                  enchantLevel > 0 ? "+$enchantLevel" : "",
                  style: AppTypography.attributeLabel
                      .copyWith(fontSize: 10, color: AppColors.accentYellow),
                )),
          if (scroll != null)
            Positioned(
                left: 0,
                bottom: 0,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: AppColors.overlayMedium,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.fromBorderSide(
                        BorderSide(color: AppColors.overlayLight)),
                  ),
                  child: Text(
                    scroll.scrollType == ScrollType.weapon ? "W" : "A",
                    style: AppTypography.attributeLabel.copyWith(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: AppColors.accentYellow,
                    ),
                  ),
                )),
          if (scroll != null && scroll.quantity > 1)
            Positioned(
                right: 0,
                bottom: 0,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: AppColors.overlayMedium,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.fromBorderSide(
                        BorderSide(color: AppColors.overlayLight)),
                  ),
                  child: Text(
                    "${scroll.quantity}",
                    style: AppTypography.attributeLabel
                        .copyWith(fontSize: 10, color: AppColors.accentYellow),
                  ),
                ))
        ],
      ),
    );
  }
}
