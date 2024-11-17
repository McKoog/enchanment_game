import 'package:enchantment_game/data_providers/current_providers.dart';
import 'package:enchantment_game/data_providers/inventory_provider.dart';
import 'package:enchantment_game/decorations/enchanted_weapons_glow_colors.dart';
import 'package:enchantment_game/decorations/slots_decorations.dart';
import 'package:enchantment_game/models/item.dart';
import 'package:enchantment_game/models/weapon.dart';
import 'package:enchantment_game/screens/enchant_screen/zones/secondary_zone/fields/components/inventory_draggable_item.dart';
import 'package:enchantment_game/screens/enchant_screen/zones/secondary_zone/fields/components/inventory_drag_target.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// TODO: Переписать на дженерик
class InventorySlot extends ConsumerWidget {
  const InventorySlot(
      {super.key, required this.index, this.item, this.canBeDragged = true, this.canBeDragTarget = true});

  final int index;
  final Item? item;

  final bool canBeDragged;
  final bool canBeDragTarget;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // ref.watch(currentEnchantSuccess);
    Weapon? weapon;
    if (item != null && item!.type == ItemType.weapon) weapon = item as Weapon;

    // var invItems = ref.watch(inventory).items;
    // int? currentDrag = ref.watch(currentDragItemInventoryIndex);
    // bool isDragged = currentDrag != null;
    // var draggedItem = isDragged ? invItems[currentDrag] : null;
    // bool thisItemDragged =
    //     isDragged && draggedItem != null && draggedItem.id == item?.id;
    //
    // bool enchantVisible = item != null && !thisItemDragged;
    //ref.watch(currentDragItemInventoryIndex) != null && ref.read(inventory).items[ref.read(currentDragItemInventoryIndex)!] != null && ref.read(inventory).items[ref.read(currentDragItemInventoryIndex)!]!.id != item!.id;

    return Stack(
      alignment: Alignment.bottomRight,
      fit: StackFit.expand,
      children: [
        Container(
            padding: const EdgeInsets.all(5),
            decoration: weapon != null
                ? BoxDecoration(
                    color: const Color.fromRGBO(85, 85, 85, 1),
                    border: Border.fromBorderSide(BorderSide(
                        color: weapon.enchantLevel <= 15
                            ? Color.fromRGBO(130, 130, 130, 1)
                            : weapon.enchantLevel <= 20
                                ? enchantedWeaponsGlowColors[
                                        weapon.enchantLevel]
                                    .withOpacity(0.6)
                                : Color.fromRGBO(130, 130, 130, 1),
                        width: 2)),
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: weapon.enchantLevel == 0
                        ? null
                        : weapon.enchantLevel > 20
                            ? [
                                BoxShadow(
                                    color: enchantedWeaponsGlowColors[21],
                                    spreadRadius: 2)
                              ]
                            : [
                                BoxShadow(
                                    color: enchantedWeaponsGlowColors[
                                        weapon.enchantLevel],
                                    spreadRadius: 2)
                              ])
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
              ))
      ],
    );
  }
}
