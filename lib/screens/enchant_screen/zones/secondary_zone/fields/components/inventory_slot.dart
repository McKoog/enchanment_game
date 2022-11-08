import 'package:enchantment_game/data_providers/animation_providers.dart';
import 'package:enchantment_game/data_providers/current_providers.dart';
import 'package:enchantment_game/data_providers/show_providers.dart';
import 'package:enchantment_game/decorations/slots_decorations.dart';
import 'package:enchantment_game/models/item.dart';
import 'package:enchantment_game/models/weapon.dart';
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
            child: item != null ?Draggable<Item>(
              data: item,
              feedback: SvgPicture.asset(item!.image,height: MediaQuery.of(context).size.height/12,width: MediaQuery.of(context).size.height/12,),
              childWhenDragging: const SizedBox(),

              child: InkWell(
                onTap: item != null
                    ?(){
                  if(item!.type == ItemType.scroll) {
                    ref.read(showWeaponInfoField.notifier).update((state) => false);
                    ref.read(currentWeapon.notifier).update((state) => null);
                    ref.read(showScrollField.notifier).update((state) => !state);
                    ref.read(currentScroll.notifier).update((state) => item);
                    if(ref.read(showScrollField) == false)ref.read(scrollEnchantSlotItem.notifier).update((state) => null);
                    ref.read(startProgressBarAnimation.notifier).update((state) => false);
                    ref.read(finishedProgressBarAnimation.notifier).update((state) => false);
                    ref.read(showScrollProgressBar.notifier).update((state) => false);
                    ref.read(currentEnchantSuccess.notifier).update((state) => null);
                  }
                  else if (item!.type == ItemType.weapon){
                    ref.read(scrollEnchantSlotItem.notifier).update((state) => null);
                    ref.read(showScrollField.notifier).update((state) => false);
                    ref.read(currentScroll.notifier).update((state) => null);
                    ref.read(showWeaponInfoField.notifier).update((state) => !state);
                    ref.read(currentWeapon.notifier).update((state) => item);
                    ref.read(startProgressBarAnimation.notifier).update((state) => false);
                    ref.read(finishedProgressBarAnimation.notifier).update((state) => false);
                    ref.read(showScrollProgressBar.notifier).update((state) => false);
                    ref.read(currentEnchantSuccess.notifier).update((state) => null);
                  }
                }
                    :null,
                child: SvgPicture.asset(item!.image),
              ),
            )
                :null
        ),
        if(weapon != null)Positioned(right:8,bottom:8,child: Text(weapon.enchantLevel > 0 ?"+${weapon.enchantLevel}":"",style: const TextStyle(fontSize: 10,color: Colors.yellow),))
      ],
    );
  }
}