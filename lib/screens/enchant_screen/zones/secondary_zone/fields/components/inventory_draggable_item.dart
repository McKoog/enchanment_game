import 'package:enchantment_game/data_providers/animation_providers.dart';
import 'package:enchantment_game/data_providers/current_providers.dart';
import 'package:enchantment_game/data_providers/show_providers.dart';
import 'package:enchantment_game/models/item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';

class InventoryDraggableItem extends ConsumerWidget {
  const InventoryDraggableItem({Key? key,required this.item,required this.inventoryIndex}) : super(key: key);
  final Item item;
  final int inventoryIndex;

  @override
  Widget build(BuildContext context,WidgetRef ref) {
    return Draggable<Item>(
      data: item,
      feedback: item.isSvgAsset
          ?SvgPicture.asset(item.image,height: MediaQuery.of(context).size.height/12,width: MediaQuery.of(context).size.height/12,)
          :Image.asset(item.image,height: MediaQuery.of(context).size.height/12,width: MediaQuery.of(context).size.height/12,),
      childWhenDragging: const SizedBox(),
      onDragStarted: (){
        ref.read(currentDragItemInventoryIndex.notifier).update((state) => inventoryIndex);
      },
      onDraggableCanceled: (Velocity vel, Offset offset){
        ref.read(currentDragItemInventoryIndex.notifier).update((state) => null);
      },
      onDragEnd: (DraggableDetails details){
        ref.read(currentDragItemInventoryIndex.notifier).update((state) => null);
      },
      child: InkWell(
        onTap: (){
          if(item.type == ItemType.scroll) {

            if(ref.watch(currentEnchantSuccess) == null)ref.read(showScrollField.notifier).update((state) => !state);

            ref.read(showWeaponInfoField.notifier).update((state) => false);
            ref.read(currentWeapon.notifier).update((state) => null);
            ref.read(currentScroll.notifier).update((state) => item);
            ref.read(scrollEnchantSlotItem.notifier).update((state) => null);
            ref.read(startProgressBarAnimation.notifier).update((state) => false);
            ref.read(finishedProgressBarAnimation.notifier).update((state) => false);
            ref.read(showScrollProgressBar.notifier).update((state) => false);
            ref.read(currentEnchantSuccess.notifier).update((state) => null);

            //ref.watch(currentEnchantSuccess) == null
          }
          else if (item.type == ItemType.weapon){
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
        },
          child:item.isSvgAsset?SvgPicture.asset(item.image):Image.asset(item.image)
        //child: Container(decoration: BoxDecoration(borderRadius:BorderRadius.circular(15),boxShadow: [BoxShadow(color:Colors.red.withOpacity(0.9),blurRadius: 0,spreadRadius: 6)]),child: SvgPicture.asset(item.image)),
      ),
    );
  }
}
