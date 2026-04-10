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
    this.critChance = 0.10,
    this.critPower = 1.50,
  });

  final String id;
  final String name;
  final String image;
  final int hp;
  final double attack;
  final double attackSpeed;
  final List<DropItem> dropList;
  final int expReward;
  final int spReward;
  final double critChance;
  final double critPower;

  double get minAttack => attack * 0.9;
  double get maxAttack => attack * 1.1;
  double get attackDamage => minAttack + (maxAttack - minAttack) * (DateTime.now().millisecondsSinceEpoch % 1000) / 1000;
}
