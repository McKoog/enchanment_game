import 'package:enchantment_game/game_stock_data/game_stock_items.dart';
import 'package:enchantment_game/models/dropItem.dart';
import 'package:enchantment_game/models/enemy.dart';

final stockWerewolf = Enemy(
    name: 'Werewolf',
    image: "assets/lvl_1_werewolf.png",
    hp: 200,
    dropList: [
      DropItem(chance: 25, item: stockBasicSword),
      DropItem(chance: 50, item: stockScroll),
      DropItem(chance: 5, item: stockDagger),
      DropItem(chance: 5, item: stockBow),
    ]);
