import 'package:enchantment_game/models/monster.dart';
import 'package:enchantment_game/models/weapon.dart';
import 'package:enchantment_game/screens/hunting_field_screen/zones/moster_page/components/attack_field/attack_field.dart';
import 'package:enchantment_game/screens/hunting_field_screen/zones/moster_page/components/monster_field.dart';
import 'package:enchantment_game/screens/hunting_field_screen/zones/moster_page/components/monster_header.dart';
import 'package:flutter/material.dart';

class MonsterPage extends StatelessWidget {
  const MonsterPage(
      {super.key,
      required this.width,
      required this.monster,
      required this.weapon});

  final double width;
  final Monster monster;
  final Weapon weapon;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child:
          Column(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
        MonsterHeader(width: width, monster: monster),
        MonsterField(width: width, assetImageLink: "assets/lvl_1_werewolf.png"),
        Expanded(
            child: AttackField(width: width, monster: monster, weapon: weapon)),
      ]),
    );
  }
}
