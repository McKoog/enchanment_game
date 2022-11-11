import 'package:enchantment_game/models/monster.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final allMonstersList = StateProvider<List<Monster>>((ref) => List.generate(
    1,
        (index) => Monster(name: 'Werewolf', image: "assets/lvl_1_werewolf.png")
));