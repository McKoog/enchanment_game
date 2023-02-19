import 'package:enchantment_game/models/dropItem.dart';
import 'package:enchantment_game/models/item.dart';
import 'package:enchantment_game/models/monster.dart';
import 'package:enchantment_game/models/scroll.dart';
import 'package:enchantment_game/models/weapon.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final currentScroll = StateProvider<Item?>((ref) => null);

final currentWeapon = StateProvider<Item?>((ref) => null);

final scrollEnchantSlotItem = StateProvider<Weapon?>((ref) => null);

final currentEnchantSuccess = StateProvider<bool?>((ref) => null);

final currentDragItemInventoryIndex = StateProvider<int?>((ref) => null);

final currentSelectedWeaponHuntingField = StateProvider<Weapon?>((ref) => null);

final currentSelectedMonsterHuntingField = StateProvider<Monster?>((ref) =>
    Monster(
        name: "Werewolf",
        image: "assets/lvl_1_werewolf.png",
        hp: 100,
        dropList: [
          DropItem(
              chance: 25,
              item: Weapon(
                  id: "0",
                  type: ItemType.weapon,
                  image: "assets/sword.svg",
                  name: "Basic Sword",
                  lowerDamage: 2,
                  higherDamage: 3,
                  enchantLevel: 0)),
          DropItem(
              chance: 50,
              item: Scroll(
                  id: "0",
                  type: ItemType.scroll,
                  image: "assets/enchant_scroll.svg",
                  name: "Scroll of enchant",
                  description:
                      "Increase power of the weapon, but be carefull, it's not garanteed"))
        ]));
