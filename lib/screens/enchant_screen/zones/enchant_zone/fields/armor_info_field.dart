import 'package:enchantment_game/models/armor.dart';
import 'package:enchantment_game/models/rarity.dart';
import 'package:enchantment_game/services/armor_set_service.dart';
import 'package:enchantment_game/theme/app_colors.dart';
import 'package:enchantment_game/theme/app_typography.dart';
import 'package:flutter/material.dart';

class ArmorInfoField extends StatelessWidget {
  const ArmorInfoField(
      {super.key, required this.sideSize, required this.armor});

  final double sideSize;
  final Armor armor;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
                armor.enchantLevel > 0
                    ? "${armor.displayName} +${armor.enchantLevel}"
                    : armor.displayName,
                style: AppTypography.titleLargeHighlight),
            const SizedBox(
              height: 16,
            ),
            if (armor.rarity > 0) ...[
              Text(
                "Rarity: ${armor.rarity.toStringAsFixed(1)}%",
                style: const TextStyle(
                  color: AppColors.accentYellow,
                  fontSize: 16,
                  fontFamily: 'PT Sans',
                ),
              ),
              const SizedBox(height: 16),
            ],
            Text(
              "Defense: ${armor.defense}",
              style: AppTypography.titleSmallPrimary,
            ),
            if (armor.rarityEffects.isNotEmpty) ...[
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
              ...armor.rarityEffects.map((effect) => Padding(
                    padding: const EdgeInsets.only(bottom: 4.0),
                    child: Text(
                      effect.getDescription(armor.rarityTier.effectMultiplier),
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                        fontFamily: 'PT Sans',
                      ),
                    ),
                  )),
            ],
            if (armor.setType != ArmorSetType.none) ...[
              const SizedBox(height: 24),
              const Text(
                'Set Effects',
                style: TextStyle(
                  color: Colors.yellow,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'PT Sans',
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                "To get set effects you need to equip - helmet, breastplate, pants, boots. Depending on equipped weapon type you'll get additional effects",
                style: TextStyle(
                  color: AppColors.primaryText,
                  fontSize: 14,
                  fontFamily: 'PT Sans',
                ),
              ),
              const SizedBox(height: 16),
              ..._buildSetEffects(armor.setType),
            ],
          ],
        ),
      ),
    );
  }

  List<Widget> _buildSetEffects(ArmorSetType setType) {
    final effects = <Widget>[];
    final setEffect = ArmorSetService.getEffect(setType);

    if (setEffect != null) {
      effects.addAll(setEffect.buildSetEffectsDescription());
    }

    return effects;
  }
}
