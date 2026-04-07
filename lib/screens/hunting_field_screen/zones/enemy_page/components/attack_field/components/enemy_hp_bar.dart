import 'package:enchantment_game/decorations/components_decoration.dart';
import 'package:enchantment_game/decorations/text_decoration.dart';
import 'package:enchantment_game/models/enemy.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class EnemyHpBar extends StatelessWidget {
  const EnemyHpBar({
    super.key,
    required this.width,
    required this.enemy,
    required this.widthOfOneHP,
    required this.currentHP,
    this.heightFactor = 80,
  });

  final double width;
  final Enemy enemy;
  final double widthOfOneHP;
  final int currentHP;

  /// Available height for the HP bar row.
  final double heightFactor;

  @override
  Widget build(BuildContext context) {
    // Scale internal elements proportionally.
    // Reference height = 80 (original design).
    final double scale = (heightFactor / 80).clamp(0.4, 1.5);
    final double svgHeight = 50 * scale;
    final double barHeight = 35 * scale;

    return SizedBox(
      height: heightFactor,
      width: width - 60,
      child: Row(
        children: [
          SvgPicture.asset("assets/enemy_hp_icon.svg", height: svgHeight),
          Stack(
            children: [
              Container(
                alignment: Alignment.center,
                height: barHeight,
                width: widthOfOneHP * currentHP,
                decoration: enemyHpBarDecoration,
              ),
              Container(
                  alignment: Alignment.center,
                  height: barHeight,
                  width: widthOfOneHP * enemy.hp,
                  decoration: enemyHpBarDecoration,
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      "$currentHP / ${enemy.hp}",
                      style: farmEnemyHpTextDecoration,
                    ),
                  )),
            ],
          ),
          SvgPicture.asset(
            "assets/enemy_hp_icon.svg",
            height: svgHeight,
          ),
        ],
      ),
    );
  }
}
