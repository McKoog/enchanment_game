import 'package:enchantment_game/game_stock_data/item_registry.dart';
import 'package:enchantment_game/models/armor.dart';
import 'package:enchantment_game/models/inventory.dart';
import 'package:enchantment_game/models/scroll.dart';
import 'package:enchantment_game/models/weapon.dart';

final Inventory stockInventory = Inventory(
    items: List.generate(Inventory.defaultCapacity, (index) {
  switch (index) {
    case 0:
      return ItemRegistry.createWeapon(WeaponType.sword, generateRarity: false);
    case 1:
      return ItemRegistry.createScroll(ScrollType.weapon)..quantity = 99;
    case 2:
      return ItemRegistry.createScroll(ScrollType.armor)..quantity = 99;
    case 3:
      return ItemRegistry.createArmor(ArmorType.leggings, generateRarity: false);
    default:
      return null;
  }
}));
