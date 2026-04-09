import 'package:enchantment_game/blocs/inventory_bloc/inventory_event.dart';
import 'package:enchantment_game/blocs/inventory_bloc/inventory_state.dart';
import 'package:enchantment_game/game_stock_data/item_registry.dart';
import 'package:enchantment_game/game_stock_data/stock_inventory.dart';
import 'package:enchantment_game/models/inventory.dart';
import 'package:enchantment_game/models/scroll.dart';
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
          InventoryEvent$ConsumeScroll() => _consumeScroll(event, emitter),
          InventoryEvent$SplitScrollStack() =>
            _splitScrollStack(event, emitter),
          InventoryEvent$Reset() => _reset(event, emitter),
        });

    // Automatically load saved inventory on creation.
    add(InventoryEvent$LoadSaved());
  }

  void _addItem(InventoryEvent$AddItem event, Emitter<InventoryState> emitter) {
    final invItems = [...state.inventory.items];

    // If adding a scroll, try to stack it with an existing scroll first.
    if (event.item is Scroll) {
      final newScroll = event.item as Scroll;

      var remaining = newScroll.quantity;
      while (remaining > 0) {
        final existingIndex = invItems.indexWhere((item) =>
            item is Scroll &&
            _isSameScrollType(item, newScroll) &&
            item.quantity < Scroll.maxStackSize);

        if (existingIndex != -1) {
          final existing = invItems[existingIndex] as Scroll;
          final spaceAvailable = Scroll.maxStackSize - existing.quantity;
          final toAdd =
              remaining <= spaceAvailable ? remaining : spaceAvailable;
          final updatedScroll = Scroll.copyWith(existing);
          updatedScroll.quantity = existing.quantity + toAdd;
          invItems[existingIndex] = updatedScroll;
          remaining -= toAdd;
          continue;
        }

        final firstEmptySlotIndex = invItems.indexWhere((item) => item == null);
        if (firstEmptySlotIndex == -1) break;

        final stackQuantity =
            remaining <= Scroll.maxStackSize ? remaining : Scroll.maxStackSize;
        invItems[firstEmptySlotIndex] =
            _createScrollWithNewId(newScroll, stackQuantity);
        remaining -= stackQuantity;
      }

      final newInventory = Inventory(items: invItems);
      emitter(InventoryState(inventory: newInventory));
      _autoSave(newInventory);
      return;
    }

    // Default: place in first empty slot.
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
    final fromItem = invItems[event.fromIndex];
    final toItem = invItems[event.toIndex];

    // If both are scrolls, merge them into one stack.
    if (fromItem is Scroll &&
        toItem is Scroll &&
        _isSameScrollType(fromItem, toItem)) {
      final totalQuantity = fromItem.quantity + toItem.quantity;
      if (totalQuantity <= Scroll.maxStackSize) {
        final merged = Scroll.copyWith(toItem);
        merged.quantity = totalQuantity;
        invItems[event.toIndex] = merged;
        invItems[event.fromIndex] = null;
      } else {
        // Fill target to max, keep remainder in source.
        final mergedTarget = Scroll.copyWith(toItem);
        mergedTarget.quantity = Scroll.maxStackSize;
        invItems[event.toIndex] = mergedTarget;

        final remainSource = Scroll.copyWith(fromItem);
        remainSource.quantity = totalQuantity - Scroll.maxStackSize;
        invItems[event.fromIndex] = remainSource;
      }
      final newInventory = Inventory(items: invItems);
      emitter(InventoryState(inventory: newInventory));
      _autoSave(newInventory);
      return;
    }

    // Default swap.
    invItems[event.toIndex] = fromItem;
    invItems[event.fromIndex] = toItem;
    final newInventory = Inventory(items: invItems);
    emitter(InventoryState(inventory: newInventory));
    _autoSave(newInventory);
  }

  void _consumeScroll(
      InventoryEvent$ConsumeScroll event, Emitter<InventoryState> emitter) {
    final invItems = [...state.inventory.items];
    final item = invItems[event.slotIndex];
    if (item is! Scroll) return;

    if (item.quantity <= 1) {
      // Last scroll consumed — remove from slot.
      invItems[event.slotIndex] = null;
    } else {
      final updated = Scroll.copyWith(item);
      updated.quantity = item.quantity - 1;
      invItems[event.slotIndex] = updated;
    }

    final newInventory = Inventory(items: invItems);
    emitter(InventoryState(inventory: newInventory));
    _autoSave(newInventory);
  }

  void _splitScrollStack(
      InventoryEvent$SplitScrollStack event, Emitter<InventoryState> emitter) {
    final invItems = [...state.inventory.items];
    if (event.fromIndex == event.toIndex) return;

    final sourceItem = invItems[event.fromIndex];
    if (sourceItem is! Scroll) return;
    if (event.quantity <= 0 || event.quantity > sourceItem.quantity) return;

    final targetItem = invItems[event.toIndex];

    int transfer;
    if (targetItem == null) {
      transfer = event.quantity;
      invItems[event.toIndex] = _createScrollWithNewId(sourceItem, transfer);
    } else if (targetItem is Scroll &&
        _isSameScrollType(sourceItem, targetItem)) {
      final spaceAvailable = Scroll.maxStackSize - targetItem.quantity;
      transfer =
          event.quantity <= spaceAvailable ? event.quantity : spaceAvailable;
      if (transfer <= 0) return;

      final updatedTarget = Scroll.copyWith(targetItem);
      updatedTarget.quantity = targetItem.quantity + transfer;
      invItems[event.toIndex] = updatedTarget;
    } else {
      return;
    }

    final remaining = sourceItem.quantity - transfer;
    if (remaining <= 0) {
      invItems[event.fromIndex] = null;
    } else {
      final updatedSource = Scroll.copyWith(sourceItem);
      updatedSource.quantity = remaining;
      invItems[event.fromIndex] = updatedSource;
    }

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

  void _reset(InventoryEvent$Reset event, Emitter<InventoryState> emitter) {
    emitter(InventoryState(inventory: stockInventory));
    _autoSave(stockInventory);
  }

  /// Fire-and-forget save after each mutation.
  void _autoSave(Inventory inventory) {
    SaveService.saveInventory(inventory);
  }

  static bool _isSameScrollType(Scroll a, Scroll b) {
    return a.scrollType == b.scrollType;
  }

  static Scroll _createScrollWithNewId(Scroll source, int quantity) {
    final scroll = ItemRegistry.createScroll(source.scrollType);
    scroll.image = source.image;
    scroll.name = source.name;
    scroll.description = source.description;
    scroll.quantity = quantity;
    return scroll;
  }
}
