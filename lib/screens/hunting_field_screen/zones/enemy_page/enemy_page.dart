import 'package:enchantment_game/models/enemy.dart';
import 'package:enchantment_game/models/weapon.dart';
import 'package:enchantment_game/screens/hunting_field_screen/zones/enemy_page/components/attack_field/attack_field.dart';
import 'package:enchantment_game/screens/hunting_field_screen/zones/enemy_page/components/enemy_field.dart';
import 'package:enchantment_game/screens/hunting_field_screen/zones/enemy_page/components/enemy_header.dart';
import 'package:flutter/material.dart';

class EnemyPage extends StatelessWidget {
  const EnemyPage(
      {super.key,
      required this.width,
      required this.enemy,
      required this.weapon});

  final double width;
  final Enemy enemy;
  final Weapon weapon;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child:
          Column(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
        EnemyHeader(width: width, enemy: enemy),
        EnemyField(width: width, assetImageLink: "assets/lvl_1_werewolf.png"),
        Expanded(
            child: AttackField(width: width, enemy: enemy, weapon: weapon)),
      ]),
    );
  }
}
