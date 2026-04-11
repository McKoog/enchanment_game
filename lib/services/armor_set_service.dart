import 'package:enchantment_game/models/armor.dart';
import 'package:enchantment_game/models/weapon.dart';
import 'package:enchantment_game/theme/app_colors.dart';
import 'package:flutter/material.dart';

abstract class ArmorSetEffect {
  ArmorSetType get setType;

  // Base stat modifiers
  int getBonusHealth(int enchantLevel) => 0;
  int getBonusHpRegen(int enchantLevel) => 0;
  int getBonusDefense(int enchantLevel, WeaponType weaponType) => 0;
  double getBonusLowerDamage(int enchantLevel, WeaponType weaponType) => 0.0;
  double getBonusHigherDamage(int enchantLevel, WeaponType weaponType) => 0.0;
  double getAttackSpeedMultiplier(int enchantLevel, WeaponType weaponType) => 1.0;
  int getBonusCritRate(int enchantLevel, WeaponType weaponType) => 0;

  // Additional mechanics
  bool hasDoubleAttackChance(WeaponType weaponType) => false;
  double getDoubleAttackChance(WeaponType weaponType) => 0.0;

  // UI descriptions
  List<Widget> buildSetEffectsDescription();
  List<Widget> buildActiveEffectsList(int enchantLevel, Weapon weapon);
}

class LeatherSetEffect extends ArmorSetEffect {
  @override
  ArmorSetType get setType => ArmorSetType.leather;

  @override
  int getBonusHealth(int enchantLevel) => 10;

  @override
  int getBonusHpRegen(int enchantLevel) => 1 + (enchantLevel ~/ 5);

  @override
  int getBonusDefense(int enchantLevel, WeaponType weaponType) {
    if (weaponType == WeaponType.fist || weaponType == WeaponType.sword) {
      return 1;
    }
    return 0;
  }

  @override
  double getBonusLowerDamage(int enchantLevel, WeaponType weaponType) {
    if (weaponType == WeaponType.fist) {
      return 1.0;
    }
    if (weaponType == WeaponType.bow) {
      return -1.0;
    }
    return 0.0;
  }

  @override
  double getBonusHigherDamage(int enchantLevel, WeaponType weaponType) {
    if (weaponType == WeaponType.fist) {
      return 1.0;
    }
    if (weaponType == WeaponType.bow) {
      return -1.0;
    }
    return 0.0;
  }

  @override
  double getAttackSpeedMultiplier(int enchantLevel, WeaponType weaponType) {
    if (weaponType == WeaponType.dagger) {
      return 0.95; // +5% attack speed (lower interval)
    }
    return 1.0;
  }

  @override
  int getBonusCritRate(int enchantLevel, WeaponType weaponType) {
    if (weaponType == WeaponType.dagger) {
      return 3;
    }
    return 0;
  }

  @override
  bool hasDoubleAttackChance(WeaponType weaponType) {
    return weaponType == WeaponType.bow;
  }

  @override
  double getDoubleAttackChance(WeaponType weaponType) {
    if (weaponType == WeaponType.bow) return 0.10;
    return 0.0;
  }

  @override
  List<Widget> buildSetEffectsDescription() {
    return [
      const Text('+ 10 hp', style: TextStyle(color: AppColors.accentYellow, fontFamily: 'PT Sans', fontSize: 14)),
      const SizedBox(height: 4),
      const Text('+ 1 hp regen (each 5 enchantments levels will grant additional +1 hp regen)',
          style: TextStyle(color: AppColors.accentYellow, fontFamily: 'PT Sans', fontSize: 14)),
      const SizedBox(height: 12),
      const Text('Weapon effect:', style: TextStyle(color: AppColors.accentYellow, fontFamily: 'PT Sans', fontSize: 14, fontWeight: FontWeight.bold)),
      const SizedBox(height: 4),
      const Text('Fists: + 1 min/max damage, +1 defence', style: TextStyle(color: AppColors.error, fontFamily: 'PT Sans', fontSize: 14)),
      const SizedBox(height: 4),
      const Text('Sword: +1 defence', style: TextStyle(color: AppColors.error, fontFamily: 'PT Sans', fontSize: 14)),
      const SizedBox(height: 4),
      const Text('Dagger: + 5% attack speed, + 3% crit chance', style: TextStyle(color: AppColors.error, fontFamily: 'PT Sans', fontSize: 14)),
      const SizedBox(height: 4),
      const Text('Bow: 10% chance to trigger attack 2 time, -1 min/max damage', style: TextStyle(color: AppColors.error, fontFamily: 'PT Sans', fontSize: 14)),
    ];
  }

  @override
  List<Widget> buildActiveEffectsList(int enchantLevel, Weapon weapon) {
    final effects = <Widget>[];

    effects.add(const Text(
      'Leather Set',
      style: TextStyle(
        color: Colors.yellow,
        fontWeight: FontWeight.bold,
        fontFamily: 'PT Sans',
        fontSize: 16,
      ),
    ));
    effects.add(const SizedBox(height: 8));
    effects.add(const Text('+ 10 hp', style: TextStyle(color: Colors.green, fontFamily: 'PT Sans')));
    effects.add(const SizedBox(height: 8));

    final regenBonus = getBonusHpRegen(enchantLevel);
    effects.add(Text('+ $regenBonus hp regen', style: const TextStyle(color: Colors.green, fontFamily: 'PT Sans')));
    effects.add(const SizedBox(height: 8));

    effects.add(Text('${weapon.name} Effect:', style: const TextStyle(color: Colors.yellow, fontFamily: 'PT Sans')));
    effects.add(const SizedBox(height: 8));

    if (weapon.weaponType == WeaponType.fist) {
      effects.add(const Text('+ 1 min/max damage', style: TextStyle(color: Colors.green, fontFamily: 'PT Sans')));
      effects.add(const SizedBox(height: 8));
      effects.add(const Text('+ 1 defence', style: TextStyle(color: Colors.green, fontFamily: 'PT Sans')));
      effects.add(const SizedBox(height: 8));
    } else if (weapon.weaponType == WeaponType.sword) {
      effects.add(const Text('+ 1 defence', style: TextStyle(color: Colors.green, fontFamily: 'PT Sans')));
      effects.add(const SizedBox(height: 8));
    } else if (weapon.weaponType == WeaponType.dagger) {
      effects.add(const Text('+ 5% attack speed', style: TextStyle(color: Colors.green, fontFamily: 'PT Sans')));
      effects.add(const SizedBox(height: 8));
      effects.add(const Text('+ 3% crit chance', style: TextStyle(color: Colors.green, fontFamily: 'PT Sans')));
      effects.add(const SizedBox(height: 8));
    } else if (weapon.weaponType == WeaponType.bow) {
      effects.add(const Text('10% chance to trigger attack 2 time', style: TextStyle(color: Colors.green, fontFamily: 'PT Sans')));
      effects.add(const SizedBox(height: 8));
      effects.add(const Text('- 1 min/max damage', style: TextStyle(color: Colors.green, fontFamily: 'PT Sans')));
      effects.add(const SizedBox(height: 8));
    }

    return effects;
  }
}

class ArmorSetService {
  static final Map<ArmorSetType, ArmorSetEffect> _effects = {
    ArmorSetType.leather: LeatherSetEffect(),
  };

  static ArmorSetEffect? getEffect(ArmorSetType setType) {
    return _effects[setType];
  }
}
