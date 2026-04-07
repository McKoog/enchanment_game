import 'package:enchantment_game/decorations/enchanted_weapons_glow_colors.dart';
import 'package:enchantment_game/decorations/slots_decorations.dart';
import 'package:enchantment_game/models/item.dart';
import 'package:enchantment_game/models/scroll.dart';
import 'package:enchantment_game/models/weapon.dart';
import 'package:enchantment_game/screens/enchant_screen/zones/inventory_zone/fields/components/inventory_drag_target.dart';
import 'package:enchantment_game/screens/enchant_screen/zones/inventory_zone/fields/components/inventory_draggable_item.dart';
import 'package:flutter/material.dart';

// TODO: Переписать на дженерик
class InventorySlot extends StatelessWidget {
  const InventorySlot({super.key, required this.index, this.item, this.canBeDragged = true, this.canBeDragTarget = true});

  final int index;
  final Item? item;

  final bool canBeDragged;
  final bool canBeDragTarget;

  @override
  Widget build(BuildContext context) {
    Weapon? weapon;
    if (item != null && item!.type == ItemType.weapon) weapon = item as Weapon;
    final scroll = item is Scroll ? item as Scroll : null;

    return Stack(
      alignment: Alignment.center,
      fit: StackFit.expand,
      children: [
        Container(
            padding: const EdgeInsets.all(5),
            decoration: weapon != null
                ? BoxDecoration(
                    color: weapon.enchantLevel < 16
                        ? Color.fromRGBO(85, 85, 85, 1).withValues(alpha: 1 - (0.0666 * weapon.enchantLevel))
                        : weapon.enchantLevel < 21
                            ? Color.fromRGBO(85, 85, 85, 1).withValues(alpha: 0.5 - (0.06 * (weapon.enchantLevel % 16)))
                            : Colors.grey.shade900.withValues(alpha: 0.25),
                    border: Border.fromBorderSide(BorderSide(color: Color.fromRGBO(130, 130, 130, 1), width: 2)),
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: weapon.enchantLevel == 0
                        ? null
                        : weapon.enchantLevel > 20
                            ? [BoxShadow(color: enchantedWeaponsGlowColors[21], spreadRadius: 0.3)]
                            : [BoxShadow(color: enchantedWeaponsGlowColors[weapon.enchantLevel], spreadRadius: 0.3)])
                : inventorySlotDecoration,
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
        if (weapon != null /*&& enchantVisible*/)
          Positioned(
              right: 8,
              bottom: 8,
              child: Text(
                weapon.enchantLevel > 0 ? "+${weapon.enchantLevel}" : "",
                style: const TextStyle(fontSize: 10, color: Colors.yellow),
              )),
        if (scroll != null && scroll.quantity > 1)
          Positioned(
              right: 4,
              bottom: 4,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                decoration: BoxDecoration(
                  color: const Color.fromRGBO(0, 0, 0, 0.4),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.fromBorderSide(BorderSide(color: Colors.black.withValues(alpha: 0.2))),
                ),
                child: Text(
                  "${scroll.quantity}",
                  style: const TextStyle(fontSize: 10, color: Colors.yellow),
                ),
              ))
      ],
    );
  }
}
