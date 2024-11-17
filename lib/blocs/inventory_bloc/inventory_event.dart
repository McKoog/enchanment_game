import 'package:enchantment_game/models/item.dart';

sealed class InventoryEvent{}

class InventoryEvent$AddItem extends InventoryEvent{
  InventoryEvent$AddItem({required this.item});

  final Item item;
}

class InventoryEvent$RemoveItem extends InventoryEvent{
  InventoryEvent$RemoveItem({required this.item});

  final Item item;
}

class InventoryEvent$SwapItems extends InventoryEvent{
  InventoryEvent$SwapItems({required this.fromIndex, required this.toIndex});

  final int fromIndex;
  final int toIndex;
}

class InventoryEvent$RefreshInventory extends InventoryEvent{}