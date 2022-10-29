import 'package:enchantment_game/data_providers/current_providers.dart';
import 'package:enchantment_game/decorations/fields_decoration.dart';
import 'package:enchantment_game/screens/enchant_screen/zones/main_zone/fields/components/scroll_enchant_slot.dart';
import 'package:enchantment_game/screens/enchant_screen/zones/secondary_zone/fields/components/inventory_slot.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ScrollField extends ConsumerWidget {
  const ScrollField({Key? key,required this.sideSize}) : super(key: key);
  final double sideSize;

  @override
  Widget build(BuildContext context,WidgetRef ref) {
    return Container(
        decoration: enchantFieldDecoration,
        height:sideSize-100,
        width: sideSize-100,
        child:Stack(
          alignment: Alignment.center,
          fit: StackFit.expand,
          children: [
            Opacity(opacity:0.1,child: InventorySlot(index: 0,item: ref.read(currentScroll),)),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ScrollEnchantSlot(sideSize: (sideSize-100)/4,),
                ElevatedButton(onPressed: (){},style: ElevatedButton.styleFrom(backgroundColor: const Color.fromRGBO(130, 130, 130, 1)), child: const Text("Enchant"),)
              ],
            )
          ],
        ));
  }
}