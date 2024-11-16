import 'package:enchantment_game/models/Inventory.dart';

sealed class InventoryState{}

class InventoryState$Initial extends InventoryState{}

class InventoryState$Loading extends InventoryState{}

class InventoryState$Ready extends InventoryState{
  InventoryState$Ready({required this.inventory});

  final Inventory inventory;
}