import 'package:enchantment_game/models/item.dart';

sealed class ItemInfoEvent {}

class ItemInfoEvent$ShowInfo extends ItemInfoEvent {
  ItemInfoEvent$ShowInfo({required this.item, required this.inventoryIndex});

  final Item item;
  final int inventoryIndex;
}

class ItemInfoEvent$CloseInfo extends ItemInfoEvent {}
