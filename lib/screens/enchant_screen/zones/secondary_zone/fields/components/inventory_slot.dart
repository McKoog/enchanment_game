import 'package:enchantment_game/data_providers/animation_providers.dart';
import 'package:enchantment_game/data_providers/current_providers.dart';
import 'package:enchantment_game/data_providers/show_providers.dart';
import 'package:enchantment_game/decorations/slots_decorations.dart';
import 'package:enchantment_game/models/item.dart';
import 'package:enchantment_game/models/weapon.dart';
import 'package:enchantment_game/screens/enchant_screen/zones/secondary_zone/fields/components/inventory_draggable_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';

class InventorySlot extends ConsumerWidget {
  const InventorySlot({Key? key,required this.index,this.item}) : super(key: key);
  final int index;
  final Item? item;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(currentEnchantSuccess);
    Weapon? weapon;
    if(item != null && item!.type == ItemType.weapon)weapon = item as Weapon;
    return Stack(
      alignment: Alignment.bottomRight,
      fit: StackFit.expand,
      children: [
        Container(
            padding: const EdgeInsets.all(5),
            decoration: inventorySlotDecoration,
            child: item != null
                ?InventoryDraggableItem(item: item!)
                :null
        ),
        if(weapon != null)Positioned(right:8,bottom:8,child: Text(weapon.enchantLevel > 0 ?"+${weapon.enchantLevel}":"",style: const TextStyle(fontSize: 10,color: Colors.yellow),))
      ],
    );
  }
}