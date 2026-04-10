import 'dart:math';

import 'package:enchantment_game/models/armor.dart';
import 'package:enchantment_game/models/weapon.dart';

/// Per-enchantment-level stat bonus applied to a weapon.
class EnchantBonus {
  final double lowerDamageBonus;
  final double higherDamageBonus;
  final int critRateBonus;
  final int critPowerBonus;

  const EnchantBonus({
    this.lowerDamageBonus = 0.0,
    this.higherDamageBonus = 0.0,
    this.critRateBonus = 0,
    this.critPowerBonus = 0,
  });
}

class EnchantBonusArmor {
  final int defenseBonus;

  const EnchantBonusArmor({
    this.defenseBonus = 0,
  });
}

/// Centralised enchantment configuration.
///
/// Adding a new weapon type only requires one entry in [bonusByWeaponType].
class EnchantConfig {
  EnchantConfig._();

  /// Stat bonuses granted per enchantment level, keyed by weapon type.
  static const Map<WeaponType, EnchantBonus> bonusByWeaponType = {
    WeaponType.sword: EnchantBonus(lowerDamageBonus: 1, higherDamageBonus: 2),
    WeaponType.bow: EnchantBonus(higherDamageBonus: 4),
    WeaponType.dagger: EnchantBonus(lowerDamageBonus: 1, higherDamageBonus: 2),
    WeaponType.fist: EnchantBonus(),
  };

  static const Map<ArmorType, EnchantBonusArmor> bonusByArmorType = {
    ArmorType.helmet: EnchantBonusArmor(defenseBonus: 1),
    ArmorType.chestplate: EnchantBonusArmor(defenseBonus: 1),
    ArmorType.leggings: EnchantBonusArmor(defenseBonus: 1),
    ArmorType.boots: EnchantBonusArmor(defenseBonus: 1),
  };

  /// Success chance for enchanting at [currentEnchantLevel].
  ///
  /// Formula: max(25, 100 − level × 4.6875)
  /// Level 0 → 100 %, Level 16 → 25 % (floor).
  static double getSuccessChance(int currentEnchantLevel) {
    return max(25.0, 100.0 - currentEnchantLevel * 4.6875);
  }
}
