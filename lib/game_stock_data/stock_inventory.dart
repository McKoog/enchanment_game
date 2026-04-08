import 'package:enchantment_game/game_stock_data/item_registry.dart';
import 'package:enchantment_game/models/armor.dart';
import 'package:enchantment_game/models/inventory.dart';
import 'package:enchantment_game/models/weapon.dart';

final Inventory stockInventory = Inventory(
    items: List.generate(Inventory.defaultCapacity, (index) {
  switch (index) {
    case 0:
      return ItemRegistry.createWeapon(WeaponType.sword);
    case 1:
      return ItemRegistry.createScroll();
    case 2:
      return ItemRegistry.createArmor(ArmorType.helmet);
    case 3:
      return ItemRegistry.createArmor(ArmorType.chestplate);
    case 4:
      return ItemRegistry.createArmor(ArmorType.leggings);
    case 5:
      return ItemRegistry.createArmor(ArmorType.boots);
    case 6:
      return ItemRegistry.createWeapon(WeaponType.dagger);
    case 7:
      return ItemRegistry.createWeapon(WeaponType.bow);
    default:
      return null;
  }
}));
