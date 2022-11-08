// ignore_for_file: file_names

import 'package:enchantment_game/data_providers/current_providers.dart';
import 'package:enchantment_game/data_providers/inventory_provider.dart';
import 'package:enchantment_game/models/item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class InventoryEmptyDragTarget extends ConsumerWidget {
  const InventoryEmptyDragTarget({Key? key,required this.inventoryIndex}) : super(key: key);
  final int inventoryIndex;
  @override
  Widget build(BuildContext context,WidgetRef ref) {
    return DragTarget<Item>(
        onAccept: (value){
          int indexDragFrom = ref.read(currentDragItemInventoryIndex)!;
          ref.read(inventory.notifier).update((state) => state.swapItems(indexDragFrom, inventoryIndex));
          ref.read(currentDragItemInventoryIndex.notifier).update((state) => null);
        },
        builder: (BuildContext context, List<Item?> candidateData, List<dynamic> rejectedData){
          return const SizedBox();
        }
    );
  }
}
