import 'package:enchantment_game/game_stock_items/game_stock_items.dart';
import 'package:enchantment_game/models/dropItem.dart';
import 'package:enchantment_game/models/item.dart';
import 'package:enchantment_game/models/monster.dart';
import 'package:enchantment_game/models/scroll.dart';
import 'package:enchantment_game/models/weapon.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final allMonstersList = StateProvider<List<Monster>>((ref) => List.generate(
    1,
        (index) => Monster(name: 'Werewolf', image: "assets/lvl_1_werewolf.png", hp:200, dropList: [
          DropItem(
              chance: 25,
              item:stockBasicSword),

          DropItem(chance: 50, item: stockScroll),

          DropItem(chance: 5, item: stockDagger),

          DropItem(chance: 5, item: stockBow),
        ])
));