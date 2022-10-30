import 'package:enchantment_game/models/Inventory.dart';
import 'package:enchantment_game/models/item.dart';
import 'package:enchantment_game/models/scroll.dart';
import 'package:enchantment_game/models/weapon.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final inventory = StateProvider<Inventory>((ref) => Inventory(
    items: List.generate(
        25,
            (index) => index == 0
                ?Weapon(type: ItemType.weapon, image: "assets/sword.svg", name: "Basic Sword", lowerDamage: 2, higherDamage: 3, enchantLevel: 0)
                :index == 1
                ?Scroll(type: ItemType.scroll, image: "assets/enchant_scroll.svg", name: "Scroll of enchant", description: "Increase power of the weapon, but be carefull, it's not garanteed")
                :null
    )));