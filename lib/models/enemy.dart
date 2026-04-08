import 'package:enchantment_game/models/drop_item.dart';

class Enemy {
  Enemy({
    required this.id,
    required this.name,
    required this.image,
    required this.hp,
    required this.attack,
    required this.attackSpeed,
    required this.dropList,
    this.expReward = 0,
    this.spReward = 0,
  });

  final String id;
  final String name;
  final String image;
  final int hp;
  final int attack;
  final double attackSpeed;
  final List<DropItem> dropList;
  final int expReward;
  final int spReward;

  int get attackDamage => attack;
}
