// ignore_for_file: file_names

import 'package:enchantment_game/blocs/draggable_items_bloc/draggable_items_bloc.dart';
import 'package:enchantment_game/blocs/draggable_items_bloc/draggable_items_state.dart';
import 'package:enchantment_game/blocs/inventory_bloc/inventory_bloc.dart';
import 'package:enchantment_game/blocs/inventory_bloc/inventory_event.dart';
import 'package:enchantment_game/models/item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


class InventoryDragTarget extends StatelessWidget {
  const InventoryDragTarget({super.key,required this.inventoryIndex, this.child = const SizedBox.shrink(), this.canBeDragTarget = true});
  final int inventoryIndex;
  final Widget child;
  final bool canBeDragTarget;

  @override
  Widget build(BuildContext context) {

    if(!canBeDragTarget){
      return child;
    }
    final draggableBloc = context.read<DraggableItemsBloc>();
    final inventoryBloc = context.read<InventoryBloc>();

    return DragTarget<Item>(
      onAcceptWithDetails: (details){
        final dragState = draggableBloc.state;
        if(dragState is DraggableItemsState$Dragged){
          inventoryBloc.add(InventoryEvent$SwapItems(fromIndex: dragState.itemInventoryIndex,toIndex: inventoryIndex));
        }
      },
        // onAccept: (value){
        //   int? indexDragFrom = ref.read(currentDragItemInventoryIndex);
        //   if(indexDragFrom != null)ref.read(inventory.notifier).update((state) => state.swapItems(indexDragFrom, inventoryIndex));
        //   ref.read(currentDragItemInventoryIndex.notifier).update((state) => null);
        // },
        builder: (BuildContext context, List<Item?> candidateData, List<dynamic> rejectedData){
          return child;
        }
    );
  }
}
