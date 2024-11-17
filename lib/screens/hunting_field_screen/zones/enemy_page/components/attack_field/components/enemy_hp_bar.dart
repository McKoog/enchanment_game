import 'package:enchantment_game/decorations/components_decoration.dart';
import 'package:enchantment_game/decorations/text_decoration.dart';
import 'package:enchantment_game/models/enemy.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class EnemyHpBar extends StatelessWidget {
  const EnemyHpBar(
      {super.key,
      required this.width,
      required this.enemy,
      required this.widthOfOneHP,
      required this.currentHP});

  final double width;
  final Enemy enemy;
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
          SvgPicture.asset("assets/enemy_hp_icon.svg", height: 50),
          Stack(
            children: [
              Container(
                alignment: Alignment.center,
                height: 35,
                width: widthOfOneHP * currentHP,
                decoration: enemyHpBarDecoration,
              ),
              Container(
                  alignment: Alignment.center,
                  height: 35,
                  width: widthOfOneHP * enemy.hp,
                  decoration: enemyHpBarDecoration,
                  child: Text(
                    "$currentHP / ${enemy.hp}",
                    style: farmEnemyHpTextDecoration,
                  )),
            ],
          ),
          SvgPicture.asset(
            "assets/enemy_hp_icon.svg",
            height: 50,
          ),
        ],
      ),
    );
  }
}
