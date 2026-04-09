import 'package:enchantment_game/theme/app_decorations.dart';
import 'package:enchantment_game/theme/app_typography.dart';
import 'package:flutter/material.dart';

class PlayerHpBar extends StatelessWidget {
  const PlayerHpBar({
    super.key,
    required this.width,
    required this.currentHP,
    required this.maxHP,
    this.heightFactor = 80,
  });

  final double width;
  final int currentHP;
  final int maxHP;

  /// Available height for the HP bar row.
  final double heightFactor;

  @override
  Widget build(BuildContext context) {
    // Scale internal elements proportionally.
    // Reference height = 80 (original design).
    final double scale = (heightFactor / 40).clamp(0.4, 1.5);
    final double barHeight = 35 * scale;
    final double widthOfOneHP = maxHP > 0 ? (width - 200) / maxHP : 0;

    return SizedBox(
      height: heightFactor,
      width: width - 60,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Stack(
            children: [
              Container(
                  alignment: Alignment.center,
                  height: barHeight,
                  width: widthOfOneHP * maxHP,
                  decoration: AppDecorations.playerHpBar),
              Container(
                  alignment: Alignment.center,
                  height: barHeight,
                  width: widthOfOneHP * currentHP,
                  decoration: AppDecorations.playerHpBar),
              Container(
                  alignment: Alignment.center,
                  height: barHeight,
                  width: widthOfOneHP * maxHP,
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      "$currentHP / $maxHP",
                      style: AppTypography.titleMediumDark,
                    ),
                  )),
            ],
          ),
        ],
      ),
    );
  }
}
