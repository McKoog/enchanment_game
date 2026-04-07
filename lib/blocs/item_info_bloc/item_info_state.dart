import 'package:enchantment_game/models/item.dart';

sealed class ItemInfoState {}

class ItemInfoState$Idle extends ItemInfoState {}

class ItemInfoState$Showed extends ItemInfoState {
  ItemInfoState$Showed(
      {required this.item,
      required this.inventoryIndex,
      required this.viewToken,
      this.scrollEnchantFinished = false});

  final Item item;
  final int inventoryIndex;
  final int viewToken;
  final bool scrollEnchantFinished;
}
