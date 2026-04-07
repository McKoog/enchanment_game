import 'package:enchantment_game/game_stock_data/item_registry.dart';
import 'package:enchantment_game/models/inventory.dart';
import 'package:enchantment_game/models/weapon.dart';

final Inventory stockInventory = Inventory(
    items: List.generate(
        Inventory.defaultCapacity,
        (index) => index == 0
            ? ItemRegistry.createWeapon(WeaponType.sword)
            : index == 1
                ? ItemRegistry.createScroll()
                : null));
