import 'package:enchantment_game/models/skills/skill.dart';
import 'package:enchantment_game/models/skills/skill_type.dart';
import 'package:enchantment_game/models/weapon.dart';

class SkillService {
  static final List<Skill> allSkills = [
    const Skill(
      type: SkillType.rest,
      name: 'Rest',
      unlockLevel: 1,
      baseCost: 10,
    ),
    const Skill(
      type: SkillType.daggerMastery,
      name: 'Dagger mastery',
      unlockLevel: 2,
      baseCost: 50,
    ),
    const Skill(
      type: SkillType.swordMastery,
      name: 'Sword mastery',
      unlockLevel: 2,
      baseCost: 50,
    ),
    const Skill(
      type: SkillType.bowMastery,
      name: 'Bow mastery',
      unlockLevel: 2,
      baseCost: 50,
    ),
    const Skill(
      type: SkillType.enchantmentWeaponPower,
      name: 'Enchantment Weapon power',
      unlockLevel: 3,
      baseCost: 100,
    ),
  ];

  static String getSkillDescription(SkillType type, {int level = 1}) {
    switch (type) {
      case SkillType.rest:
        return '+${3 * level} hp regen while weapon slot is closed in the battle, +${1 * level} hp regen while weapon slot opened but weapon is not taken';
      case SkillType.daggerMastery:
        return '+${1 * level}% attack speed while using dagger';
      case SkillType.swordMastery:
        return '+${1 * level}% attack speed while using sword';
      case SkillType.bowMastery:
        return '+${1 * level}% attack speed while using bow';
      case SkillType.enchantmentWeaponPower:
        return 'each 3 enchantment levels on the weapon grants +${2 * level}% additional bonus damage';
    }
  }

  static double getAttackSpeedBonus(Map<String, int> learnedSkills, WeaponType weaponType) {
    double bonus = 0.0;
    
    if (weaponType == WeaponType.dagger && learnedSkills.containsKey(SkillType.daggerMastery.name)) {
      bonus += 0.01 * learnedSkills[SkillType.daggerMastery.name]!;
    }
    if (weaponType == WeaponType.sword && learnedSkills.containsKey(SkillType.swordMastery.name)) {
      bonus += 0.01 * learnedSkills[SkillType.swordMastery.name]!;
    }
    if (weaponType == WeaponType.bow && learnedSkills.containsKey(SkillType.bowMastery.name)) {
      bonus += 0.01 * learnedSkills[SkillType.bowMastery.name]!;
    }
    
    return bonus;
  }

  static double getEnchantmentBonusDamageMultiplier(Map<String, int> learnedSkills, int weaponEnchantLevel) {
    if (!learnedSkills.containsKey(SkillType.enchantmentWeaponPower.name)) return 0.0;
    int skillLevel = learnedSkills[SkillType.enchantmentWeaponPower.name]!;
    int multiplierCount = weaponEnchantLevel ~/ 3;
    return multiplierCount * 0.02 * skillLevel;
  }
}
