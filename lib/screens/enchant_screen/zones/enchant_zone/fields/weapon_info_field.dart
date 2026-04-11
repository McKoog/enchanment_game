import 'package:enchantment_game/theme/app_typography.dart';
import 'package:enchantment_game/theme/app_colors.dart';
import 'package:enchantment_game/models/weapon.dart';
import 'package:enchantment_game/models/rarity.dart';
import 'package:enchantment_game/game_stock_data/enchant_config.dart';
import 'package:flutter/material.dart';

class WeaponInfoField extends StatelessWidget {
  const WeaponInfoField(
      {super.key, required this.sideSize, required this.weapon});

  final double sideSize;
  final Weapon weapon;

  @override
  Widget build(BuildContext context) {
    final bonus = EnchantConfig.bonusByWeaponType[weapon.weaponType] ??
        const EnchantBonus();
    final lowerDamageBonus = bonus.lowerDamageBonus * weapon.enchantLevel;
    final higherDamageBonus = bonus.higherDamageBonus * weapon.enchantLevel;
    final critRateBonus = bonus.critRateBonus * weapon.enchantLevel;
    final critPowerBonus = bonus.critPowerBonus * weapon.enchantLevel;

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
                weapon.enchantLevel > 0
                    ? "${weapon.displayName} +${weapon.enchantLevel}"
                    : weapon.displayName,
                style: AppTypography.titleLargeHighlight),
            const SizedBox(
              height: 16,
            ),
            if (weapon.rarity > 0) ...[
              Text(
                "Rarity: ${weapon.rarity.toStringAsFixed(2)}%",
                style: const TextStyle(
                  color: AppColors.accentYellow,
                  fontSize: 16,
                  fontFamily: 'PT Sans',
                ),
              ),
              const SizedBox(height: 16),
            ],
            Text.rich(
              TextSpan(
                style: AppTypography.titleSmallPrimary,
                children: [
                  TextSpan(
                      text:
                          "Damage: ${weapon.lowerDamage.toStringAsFixed(2)}-${weapon.higherDamage.toStringAsFixed(2)}"),
                  if (lowerDamageBonus > 0 || higherDamageBonus > 0)
                    TextSpan(
                      text:
                          " (+ ${lowerDamageBonus.toStringAsFixed(2)}-${higherDamageBonus.toStringAsFixed(2)})",
                      style: const TextStyle(color: AppColors.accentYellow),
                    ),
                ],
              ),
            ),
            const SizedBox(
              height: 16,
            ),
            Text(
              "Attack Speed: ${weapon.attackSpeed.toStringAsFixed(2)}/s",
              style: AppTypography.titleSmallPrimary,
            ),
            const SizedBox(
              height: 16,
            ),
            Text.rich(
              TextSpan(
                style: AppTypography.titleSmallPrimary,
                children: [
                  TextSpan(
                      text:
                          "Critical hit chance: ${weapon.critRate.toStringAsFixed(2)}%"),
                  if (critRateBonus > 0)
                    TextSpan(
                      text: " (+ $critRateBonus%)",
                      style: const TextStyle(color: AppColors.accentYellow),
                    ),
                ],
              ),
            ),
            const SizedBox(
              height: 16,
            ),
            Text.rich(
              TextSpan(
                style: AppTypography.titleSmallPrimary,
                children: [
                  TextSpan(
                      text:
                          "Critical hit power: ${weapon.critPower.toStringAsFixed(2)}%"),
                  if (critPowerBonus > 0)
                    TextSpan(
                      text: " (+ $critPowerBonus%)",
                      style: const TextStyle(color: AppColors.accentYellow),
                    ),
                ],
              ),
            ),
            if (weapon.rarityEffects.isNotEmpty) ...[
              const SizedBox(height: 24),
              const Text(
                'Rarity Effects',
                style: TextStyle(
                  color: AppColors.accentYellow,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'PT Sans',
                ),
              ),
              const SizedBox(height: 8),
              ...weapon.rarityEffects.map((effect) => Padding(
                    padding: const EdgeInsets.only(bottom: 4.0),
                    child: Text(
                      effect.getDescription(weapon.rarityTier.effectMultiplier),
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                        fontFamily: 'PT Sans',
                      ),
                    ),
                  )),
            ],
          ],
        ),
      ),
    );
  }
}
