import 'package:enchantment_game/blocs/inventory_bloc/inventory_event.dart';
import 'package:enchantment_game/blocs/inventory_bloc/inventory_state.dart';
import 'package:enchantment_game/game_stock_data/stock_inventory.dart';
import 'package:enchantment_game/models/inventory.dart';
import 'package:enchantment_game/services/save_service.dart';
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
          InventoryEvent$LoadSaved() => _loadSaved(event, emitter),
        });

    // Automatically load saved inventory on creation.
    add(InventoryEvent$LoadSaved());
  }

  void _addItem(InventoryEvent$AddItem event, Emitter<InventoryState> emitter) {
    final invItems = [...state.inventory.items];
    final firstEmptySlotIndex = invItems.indexWhere((item) => item == null);
    if (firstEmptySlotIndex == -1) return;
    invItems[firstEmptySlotIndex] = event.item;
    final newInventory = Inventory(items: invItems);
    emitter(InventoryState(inventory: newInventory));
    _autoSave(newInventory);
  }

  void _removeItem(
      InventoryEvent$RemoveItem event, Emitter<InventoryState> emitter) {
    final invItems = [...state.inventory.items];
    final removedIndex =
        invItems.indexWhere((item) => item?.id == event.item.id);
    if (removedIndex == -1) return;
    invItems[removedIndex] = null;
    final newInventory = Inventory(items: invItems);
    emitter(InventoryState(inventory: newInventory));
    _autoSave(newInventory);
  }

  void _swapItems(
      InventoryEvent$SwapItems event, Emitter<InventoryState> emitter) {
    final invItems = [...state.inventory.items];
    final changedItem = invItems[event.toIndex];
    invItems[event.toIndex] = invItems[event.fromIndex];
    invItems[event.fromIndex] = changedItem;
    final newInventory = Inventory(items: invItems);
    emitter(InventoryState(inventory: newInventory));
    _autoSave(newInventory);
  }

  void _refreshInventory(
      InventoryEvent$RefreshInventory event, Emitter<InventoryState> emitter) {
    final invItems = [...state.inventory.items];
    final newInventory = Inventory(items: invItems);
    emitter(InventoryState(inventory: newInventory));
    _autoSave(newInventory);
  }

  Future<void> _loadSaved(
      InventoryEvent$LoadSaved event, Emitter<InventoryState> emitter) async {
    final saved = await SaveService.loadInventory();
    if (saved != null) {
      emitter(InventoryState(inventory: saved));
    }
  }

  /// Fire-and-forget save after each mutation.
  void _autoSave(Inventory inventory) {
    SaveService.saveInventory(inventory);
  }
}
