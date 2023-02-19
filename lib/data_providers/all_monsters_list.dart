import 'package:enchantment_game/models/dropItem.dart';
import 'package:enchantment_game/models/item.dart';
import 'package:enchantment_game/models/monster.dart';
import 'package:enchantment_game/models/scroll.dart';
import 'package:enchantment_game/models/weapon.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final allMonstersList = StateProvider<List<Monster>>((ref) => List.generate(
    1,
        (index) => Monster(name: 'Werewolf', image: "assets/lvl_1_werewolf.png", hp:100, dropList: [
          DropItem(
              chance: 25,
              item:Weapon(id:"",type: ItemType.weapon, image: "assets/sword.svg", name: "Basic Sword", lowerDamage: 2, higherDamage: 3, enchantLevel: 0)),

          DropItem(chance: 50, item: Scroll(
              id: "",
              type: ItemType.scroll,
              image: "assets/enchant_scroll.svg",
              name: "Scroll of enchant",
              description: "Increase power of the weapon, but be carefull, it's not garanteed"))
        ])
));