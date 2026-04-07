import 'dart:math';

import 'package:enchantment_game/models/weapon.dart';

/// Per-enchantment-level stat bonus applied to a weapon.
class EnchantBonus {
  final int lowerDamageBonus;
  final int higherDamageBonus;
  final int critRateBonus;
  final int critPowerBonus;

  const EnchantBonus({
    this.lowerDamageBonus = 0,
    this.higherDamageBonus = 0,
    this.critRateBonus = 0,
    this.critPowerBonus = 0,
  });
}

/// Centralised enchantment configuration.
///
/// Adding a new weapon type only requires one entry in [bonusByWeaponType].
class EnchantConfig {
  EnchantConfig._();

  /// Stat bonuses granted per enchantment level, keyed by weapon type.
  static const Map<WeaponType, EnchantBonus> bonusByWeaponType = {
    WeaponType.sword:
        EnchantBonus(lowerDamageBonus: 1, higherDamageBonus: 2),
    WeaponType.bow: EnchantBonus(higherDamageBonus: 3),
    WeaponType.dagger:
        EnchantBonus(lowerDamageBonus: 1, higherDamageBonus: 1),
    WeaponType.fist: EnchantBonus(),
  };

  /// Success chance for enchanting at [currentEnchantLevel].
  ///
  /// Formula: max(25, 95 − level × 4.375)
  /// Level 0 → 95 %, Level 5 → 73.1 %, Level 16 → 25 % (floor).
  static double getSuccessChance(int currentEnchantLevel) {
    return max(25.0, 95.0 - currentEnchantLevel * 4.375);
  }
}
