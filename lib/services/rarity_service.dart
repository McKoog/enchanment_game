import 'dart:math';

import 'package:enchantment_game/models/armor.dart';
import 'package:enchantment_game/models/rarity.dart';
import 'package:enchantment_game/models/weapon.dart';

class RarityService {
  static final Random _random = Random();

  static void generateRarityForWeapon(Weapon weapon) {
    weapon.rarity = _generateRarityPercentage();
    weapon.rarityEffects = _generateUniqueEffects(weapon.rarityTier.effectCount);
  }

  static void generateRarityForArmor(Armor armor) {
    armor.rarity = _generateRarityPercentage();
    armor.rarityEffects = _generateUniqueEffects(armor.rarityTier.effectCount);
  }

  static double _generateRarityPercentage() {
    double roll = _random.nextDouble() * 100.0; // 0.0 to 100.0
    
    // common - 50%
    // uncommon - 43%
    // rare - 5%
    // mythical - 1.4%
    // legendary - 0.5%
    // godlike - 0.1%

    double rarityValue;

    if (roll < 50.0) {
      // Common: 0-20%
      rarityValue = _random.nextDouble() * 20.0;
    } else if (roll < 93.0) {
      // Uncommon: 20-40%
      rarityValue = 20.0 + _random.nextDouble() * 20.0;
    } else if (roll < 98.0) {
      // Rare: 40-60%
      rarityValue = 40.0 + _random.nextDouble() * 20.0;
    } else if (roll < 99.4) {
      // Mythical: 60-80%
      rarityValue = 60.0 + _random.nextDouble() * 20.0;
    } else if (roll < 99.9) {
      // Legendary: 80-98%
      rarityValue = 80.0 + _random.nextDouble() * 18.0;
    } else {
      // Godlike: 98-100%
      rarityValue = 98.0 + _random.nextDouble() * 2.0;
    }

    return rarityValue;
  }

  static List<RarityEffect> _generateUniqueEffects(int count) {
    if (count <= 0) return [];
    
    List<RarityEffect> availableEffects = RarityEffect.values.toList();
    List<RarityEffect> selectedEffects = [];
    
    for (int i = 0; i < count; i++) {
      if (availableEffects.isEmpty) break;
      int index = _random.nextInt(availableEffects.length);
      selectedEffects.add(availableEffects[index]);
      availableEffects.removeAt(index);
    }
    
    return selectedEffects;
  }
}
