import 'package:enchantment_game/models/item.dart';

sealed class InventoryEvent{}

class InventoryEvent$addItem extends InventoryEvent{
  InventoryEvent$addItem({required this.item});

  final Item? item;
}

class InventoryEvent$removeEvent extends InventoryEvent{
  InventoryEvent$removeEvent({required this.item});

  final Item? item;
}

class InventoryEvent$swapItems extends InventoryEvent{
  InventoryEvent$swapItems({required this.fromIndex, required this.toIndex});

  final int fromIndex;
  final int toIndex;
}