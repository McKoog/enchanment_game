import 'package:enchantment_game/decorations/zone_decorations.dart';
import 'package:enchantment_game/models/item.dart';
import 'package:enchantment_game/screens/enchant_screen/zones/secondary_zone/fields/components/inventory_slot.dart';
import 'package:flutter/cupertino.dart';

class InventoryField extends StatelessWidget {
  const InventoryField({Key? key, required this.sideSize,required this.capacity}) : super(key: key);
  final double sideSize;
  final int capacity;



  @override
  Widget build(BuildContext context) {
    return Container(
        height: sideSize,
        width: sideSize,
        decoration: inventoryZoneDecoration,
        child: GridView.builder(
            physics: const NeverScrollableScrollPhysics(),
            itemCount: capacity,
            padding: const EdgeInsets.all(10),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 5, mainAxisSpacing: 5,crossAxisSpacing: 5),
            itemBuilder: (BuildContext context,int index){
              return InventorySlot(index: index, item: index == 0 ? Item(type: ItemType.weapon, image: "assets/sword.svg"): index == 1 ?Item(type: ItemType.scroll, image: "assets/enchant_scroll.svg"):null);
            })
    );
  }
}