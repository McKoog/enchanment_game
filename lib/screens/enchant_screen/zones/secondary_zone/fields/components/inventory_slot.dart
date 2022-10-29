import 'package:enchantment_game/data_providers/current_providers.dart';
import 'package:enchantment_game/data_providers/show_providers.dart';
import 'package:enchantment_game/decorations/slots_decorations.dart';
import 'package:enchantment_game/models/item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';

class InventorySlot extends ConsumerWidget {
  const InventorySlot({Key? key,required this.index,this.item}) : super(key: key);
  final int index;
  final Item? item;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
        padding: const EdgeInsets.all(5),
        decoration: inventorySlotDecoration,
        child: item != null ?Draggable<Item>(
          data: item,
          feedback: SvgPicture.asset(item!.image,height: MediaQuery.of(context).size.height/9,width: MediaQuery.of(context).size.height/9,),
          childWhenDragging: const SizedBox(),

          child: InkWell(
            onTap: item != null
                ?(){
              if(item!.type == ItemType.scroll) {
                ref.read(showEnchantmentScreen.notifier).update((state) => !state);
              }
              ref.read(currentScroll.notifier).update((state) => item);
              if(ref.read(showEnchantmentScreen) == false)ref.read(scrollEnchantSlotItem.notifier).update((state) => null);
            }
                :null,
            child: SvgPicture.asset(item!.image),
          ),
        )
            :null
    );
  }
}