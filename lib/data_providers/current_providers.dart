import 'package:enchantment_game/game_stock_items/game_stock%20items.dart';
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
        hp: 200,
        dropList: [
          DropItem(
              chance: 25,
              item: stockBasicSword),
          DropItem(
              chance: 50,
              item: stockScroll),
          DropItem(chance: 5, item: stockDagger),
          DropItem(chance: 5, item: stockBow)

        ]));
