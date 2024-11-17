import 'package:enchantment_game/blocs/inventory_bloc/inventory_event.dart';
import 'package:enchantment_game/blocs/inventory_bloc/inventory_state.dart';
import 'package:enchantment_game/game_stock_items/stock_inventory.dart';
import 'package:enchantment_game/models/Inventory.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class InventoryBloc extends Bloc<InventoryEvent, InventoryState> {
  InventoryBloc({final Inventory? initialInventory})
      : super(InventoryState(inventory: initialInventory??stockInventory)) {
    on<InventoryEvent>((event, emitter) =>
    switch(event){
      InventoryEvent$addItem() => _addItem(event, emitter),
      InventoryEvent$removeEvent() => _removeItem(event, emitter),
      InventoryEvent$swapItems() => _swapItems(event, emitter),
    });
  }

  void _addItem(InventoryEvent$addItem event, Emitter<InventoryState> emitter){
    final invItems = [...state.inventory.items];
    final firstEmptySlotIndex = invItems.indexWhere((item)=> item == null);
    invItems[firstEmptySlotIndex] = event.item;
    emitter(InventoryState(inventory: Inventory(items: invItems)));
  }

  void _removeItem(InventoryEvent$removeEvent event, Emitter<InventoryState> emitter){
    final invItems = [...state.inventory.items];
    invItems.removeWhere((item)=>item?.id == event.item!.id);
    emitter(InventoryState(inventory: Inventory(items: invItems)));
  }

  void _swapItems(InventoryEvent$swapItems event, Emitter<InventoryState> emitter){
    final invItems = [...state.inventory.items];
    final changedItem = invItems[event.toIndex];
    invItems[event.toIndex] = invItems[event.fromIndex];
    invItems[event.fromIndex] = changedItem;
    emitter(InventoryState(inventory: Inventory(items: invItems)));
  }
}
