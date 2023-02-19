import 'package:enchantment_game/decorations/components_decoration.dart';
import 'package:enchantment_game/decorations/text_decoration.dart';
import 'package:enchantment_game/models/monster.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class MonsterHpBar extends StatelessWidget {
  const MonsterHpBar(
      {Key? key,
      required this.width,
      required this.monster,
      required this.widthOfOneHP,
      required this.currentHP})
      : super(key: key);

  final double width;
  final Monster monster;
  final double widthOfOneHP;
  final int currentHP;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 80,
      width: width - 60,
      child: Row(
        //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          SvgPicture.asset("assets/monster_hp_icon.svg", height: 50),
          Stack(
            children: [
              Container(
                alignment: Alignment.center,
                height: 35,
                width: widthOfOneHP * currentHP,
                decoration: monsterHpBarDecoration,
              ),
              Container(
                  alignment: Alignment.center,
                  height: 35,
                  width: widthOfOneHP * 100,
                  decoration: monsterHpBarDecoration,
                  child: Text(
                    "$currentHP / ${monster.hp}",
                    style: FarmMonsterHpTextDecoration,
                  )),
            ],
          ),
          SvgPicture.asset(
            "assets/monster_hp_icon.svg",
            height: 50,
          ),
        ],
      ),
    );
  }
}
