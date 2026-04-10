import 'package:enchantment_game/models/item.dart';

sealed class InventoryEvent {}

class InventoryEvent$AddItem extends InventoryEvent {
  InventoryEvent$AddItem({required this.item});

  final Item item;
}

class InventoryEvent$AddItemAt extends InventoryEvent {
  InventoryEvent$AddItemAt({required this.item, required this.index});

  final Item item;
  final int index;
}

class InventoryEvent$RemoveItem extends InventoryEvent {
  InventoryEvent$RemoveItem({required this.item});

  final Item item;
}

class InventoryEvent$SwapItems extends InventoryEvent {
  InventoryEvent$SwapItems({required this.fromIndex, required this.toIndex});

  final int fromIndex;
  final int toIndex;
}

class InventoryEvent$RefreshInventory extends InventoryEvent {}

class InventoryEvent$LoadSaved extends InventoryEvent {}

/// Consumes 1 scroll from the stack at [slotIndex].
/// If quantity reaches 0, the slot becomes null.
class InventoryEvent$ConsumeScroll extends InventoryEvent {
  InventoryEvent$ConsumeScroll({required this.slotIndex});

  final int slotIndex;
}

/// Splits a scroll stack: moves [quantity] scrolls from [fromIndex] to [toIndex].
/// [toIndex] can be an empty slot or a compatible scroll stack.
class InventoryEvent$SplitScrollStack extends InventoryEvent {
  InventoryEvent$SplitScrollStack({
    required this.fromIndex,
    required this.toIndex,
    required this.quantity,
  });

  final int fromIndex;
  final int toIndex;
  final int quantity;
}

class InventoryEvent$Reset extends InventoryEvent {}
