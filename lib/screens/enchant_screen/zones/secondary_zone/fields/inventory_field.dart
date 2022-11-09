import 'package:enchantment_game/data_providers/inventory_provider.dart';
import 'package:enchantment_game/decorations/zone_decorations.dart';
import 'package:enchantment_game/models/Inventory.dart';
import 'package:enchantment_game/screens/enchant_screen/zones/secondary_zone/fields/components/inventory_slot.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class InventoryField extends ConsumerWidget {
  const InventoryField({Key? key, required this.sideSize,required this.capacity}) : super(key: key);
  final double sideSize;
  final int capacity;

  @override
  Widget build(BuildContext context,WidgetRef ref) {
    return Container(
        height: sideSize,
        width: sideSize,
        //decoration: inventoryZoneDecoration,
        child: GridView.builder(
            physics: const NeverScrollableScrollPhysics(),
            itemCount: capacity,
            padding: const EdgeInsets.all(10),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 5, mainAxisSpacing: 5,crossAxisSpacing: 5),
            itemBuilder: (BuildContext context,int index){
              Inventory invent = ref.watch(inventory);
              return InventorySlot(
                  index: index,
                  item: invent.items[index]
              );
            }
            )
    );
  }
}