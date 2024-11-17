import 'package:enchantment_game/game_stock_data/game_stock_items.dart';
import 'package:enchantment_game/models/Inventory.dart';
import 'package:enchantment_game/models/item.dart';

final Inventory stockInventory = Inventory(
    items: List.generate(
        25,
            (index) => index == 0
            ?getNewStockItem(ItemType.weapon)
            :index == 1
            ?getNewStockItem(ItemType.scroll)
        /*:index == 3
                ?getNewStockItem(ItemType.weapon,WeaponType.bow)
                :index == 4
                ?getNewStockItem(ItemType.weapon,WeaponType.dagger)
                :index == 4
                ?Weapon(type: ItemType.weapon, image: "assets/sword.svg", name: "Basic Sword", lowerDamage: 2, higherDamage: 3, enchantLevel: 21)*/
            :null
    ));