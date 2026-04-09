import 'package:enchantment_game/theme/enchanted_weapons_glow_colors.dart';
import 'package:enchantment_game/theme/app_decorations.dart';
import 'package:enchantment_game/models/weapon.dart';
import 'package:enchantment_game/theme/app_colors.dart';
import 'package:flutter/material.dart';

class WeaponField extends StatelessWidget {
  const WeaponField(
      {super.key, required this.weapon, this.showBackground = true});

  final Weapon weapon;
  final bool showBackground;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Scale margin and padding proportionally to available size.
        final double availableSize =
            constraints.maxHeight < constraints.maxWidth
                ? constraints.maxHeight
                : constraints.maxWidth;
        final double margin =
            showBackground ? (availableSize * 0.1).clamp(8, 50) : 0;
        final double padding =
            showBackground ? (availableSize * 0.06).clamp(4, 27) : 0;

        return Container(
            alignment: Alignment.center,
            margin: EdgeInsets.all(margin),
            padding: EdgeInsets.all(padding),
            decoration: showBackground
                ? (weapon.enchantLevel < 1
                    ? AppDecorations.attackField
                    : BoxDecoration(
                        color: AppColors.slotBackground,
                        border: Border.fromBorderSide(BorderSide(
                            color: weapon.enchantLevel <= 15
                                ? AppColors.panelBorder
                                : weapon.enchantLevel <= 20
                                    ? enchantedWeaponsGlowColors[
                                            weapon.enchantLevel]
                                        .withValues(alpha: 0.6)
                                    : AppColors.panelBorder,
                            width: 2)),
                        shape: BoxShape.circle,
                        boxShadow: weapon.enchantLevel == 0
                            ? null
                            : weapon.enchantLevel > 20
                                ? [
                                    BoxShadow(
                                        color: enchantedWeaponsGlowColors[21],
                                        blurRadius: 30,
                                        spreadRadius: 15)
                                  ]
                                : [
                                    BoxShadow(
                                        color: enchantedWeaponsGlowColors[
                                            weapon.enchantLevel],
                                        blurRadius: 30,
                                        spreadRadius: 15)
                                  ]))
                : null,
            child: Image.asset(
              weapon.image,
              gaplessPlayback: true,
              fit: BoxFit.contain,
            ));
      },
    );
  }
}
