import 'package:enchantment_game/blocs/inventory_bloc/inventory_event.dart';
import 'package:enchantment_game/blocs/inventory_bloc/inventory_state.dart';
import 'package:enchantment_game/game_stock_data/stock_inventory.dart';
import 'package:enchantment_game/models/Inventory.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class InventoryBloc extends Bloc<InventoryEvent, InventoryState> {
  InventoryBloc({final Inventory? initialInventory})
      : super(InventoryState(inventory: initialInventory ?? stockInventory)) {
    on<InventoryEvent>((event, emitter) => switch (event) {
          InventoryEvent$AddItem() => _addItem(event, emitter),
          InventoryEvent$RemoveItem() => _removeItem(event, emitter),
          InventoryEvent$SwapItems() => _swapItems(event, emitter),
          InventoryEvent$RefreshInventory() =>
            _refreshInventory(event, emitter),
        });
  }

  void _addItem(InventoryEvent$AddItem event, Emitter<InventoryState> emitter) {
    final invItems = [...state.inventory.items];
    final firstEmptySlotIndex = invItems.indexWhere((item) => item == null);
    invItems[firstEmptySlotIndex] = event.item;
    emitter(InventoryState(inventory: Inventory(items: invItems)));
  }

  void _removeItem(
      InventoryEvent$RemoveItem event, Emitter<InventoryState> emitter) {
    final invItems = [...state.inventory.items];
    final removedIndex =
        invItems.indexWhere((item) => item?.id == event.item!.id);
    invItems[removedIndex] = null;
    emitter(InventoryState(inventory: Inventory(items: invItems)));
  }

  void _swapItems(
      InventoryEvent$SwapItems event, Emitter<InventoryState> emitter) {
    final invItems = [...state.inventory.items];
    final changedItem = invItems[event.toIndex];
    invItems[event.toIndex] = invItems[event.fromIndex];
    invItems[event.fromIndex] = changedItem;
    emitter(InventoryState(inventory: Inventory(items: invItems)));
  }

  void _refreshInventory(
      InventoryEvent$RefreshInventory event, Emitter<InventoryState> emitter) {
    final invItems = [...state.inventory.items];
    emitter(InventoryState(inventory: Inventory(items: invItems)));
  }
}
