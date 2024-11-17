import 'package:enchantment_game/blocs/draggable_items_bloc/draggable_items_bloc.dart';
import 'package:enchantment_game/blocs/draggable_items_bloc/draggable_items_event.dart';
import 'package:enchantment_game/data_providers/current_providers.dart';
import 'package:enchantment_game/data_providers/show_providers.dart';
import 'package:enchantment_game/models/item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';

class InventoryDraggableItem extends ConsumerWidget {
  const InventoryDraggableItem({super.key,required this.item,required this.inventoryIndex, this.isDraggable = true});
  final Item item;
  final int inventoryIndex;
  final bool isDraggable;

  @override
  Widget build(BuildContext context,WidgetRef ref) {

    if(!isDraggable){
      return item.isSvgAsset?SvgPicture.asset(item.image):Image.asset(item.image);
    }

    final draggableBloc = context.read<DraggableItemsBloc>();

    return Draggable<Item>(
      data: item,
      feedback: item.isSvgAsset
          ?SvgPicture.asset(item.image,height: MediaQuery.of(context).size.height/12,width: MediaQuery.of(context).size.height/12,)
          :Image.asset(item.image,height: MediaQuery.of(context).size.height/12,width: MediaQuery.of(context).size.height/12,),
      childWhenDragging: const SizedBox(),
      onDragStarted: (){
        draggableBloc.add(DraggableItemsEvent$StartDragging(itemInventoryIndex: inventoryIndex));
        // ref.read(currentDragItemInventoryIndex.notifier).update((state) => inventoryIndex);
      },
      onDraggableCanceled: (Velocity vel, Offset offset){
        draggableBloc.add(DraggableItemsEvent$StopDragging());
        // ref.read(currentDragItemInventoryIndex.notifier).update((state) => null);
      },
      onDragEnd: (DraggableDetails details){
        draggableBloc.add(DraggableItemsEvent$StopDragging());
        // ref.read(currentDragItemInventoryIndex.notifier).update((state) => null);
      },
      child: InkWell(
        onTap: (){
          if(item.type == ItemType.scroll) {

            if(ref.watch(currentEnchantSuccess) == null)ref.read(showScrollField.notifier).update((state) => !state);

            ref.read(showWeaponInfoField.notifier).update((state) => false);
            ref.read(currentWeapon.notifier).update((state) => null);
            ref.read(currentScroll.notifier).update((state) => item);
            ref.read(scrollEnchantSlotItem.notifier).update((state) => null);
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
