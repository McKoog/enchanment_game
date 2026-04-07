import 'package:enchantment_game/models/item.dart';

sealed class ItemInfoState {}

class ItemInfoState$Idle extends ItemInfoState {}

class ItemInfoState$Showed extends ItemInfoState {
  ItemInfoState$Showed({required this.item, required this.inventoryIndex});

  final Item item;
  final int inventoryIndex;
}
