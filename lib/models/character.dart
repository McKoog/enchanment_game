import 'package:enchantment_game/game_stock_data/item_registry.dart';
import 'package:enchantment_game/models/armor.dart';
import 'package:enchantment_game/models/rarity.dart';
import 'package:enchantment_game/models/weapon.dart';
import 'package:enchantment_game/services/armor_set_service.dart';
import 'package:enchantment_game/services/skill_service.dart';

class Character {
  Character({
    this.level = 1,
    this.currentExp = 0,
    this.gold = 0,
    this.skillPoints = 0,
    this.equippedWeapon,
    this.equippedHelmet,
    this.equippedChestplate,
    this.equippedLeggings,
    this.equippedBoots,
    this.baseHealth = 100,
    this.hpRegen = 1,
    int? currentHealth,
    this.learnedSkills = const {},
    this.escapeCooldownEndTime,
    this.deathCooldownEndTime,
  }) : currentHealth = currentHealth ?? baseHealth;

  final int level;
  final int currentExp;
  final int gold;
  final int skillPoints;

  final Weapon? equippedWeapon;
  final Armor? equippedHelmet;
  final Armor? equippedChestplate;
  final Armor? equippedLeggings;
  final Armor? equippedBoots;

  final int baseHealth;
  final int hpRegen;
  final int currentHealth;

  final Map<String, int> learnedSkills;

  final DateTime? escapeCooldownEndTime;
  final DateTime? deathCooldownEndTime;

  ArmorSetType get activeSetType {
    if (equippedHelmet != null && equippedChestplate != null && equippedLeggings != null && equippedBoots != null) {
      final setType = equippedHelmet!.setType;
      if (setType != ArmorSetType.none && equippedChestplate!.setType == setType && equippedLeggings!.setType == setType && equippedBoots!.setType == setType) {
        return setType;
      }
    }
    return ArmorSetType.none;
  }

  int get activeSetEnchantLevel {
    if (activeSetType != ArmorSetType.none) {
      return equippedHelmet!.enchantLevel + equippedChestplate!.enchantLevel + equippedLeggings!.enchantLevel + equippedBoots!.enchantLevel;
    }
    return 0;
  }

  int get maxExp {
    double exp = 100;
    for (int i = 1; i < level; i++) {
      exp *= 1.25;
    }
    return exp.toInt();
  }

  int getRarityEffectMultiplier(RarityEffect effect) {
    int total = 0;
    void check(List<RarityEffect>? effects, RarityTier? tier) {
      if (effects != null && tier != null && effects.contains(effect)) {
        total += tier.effectMultiplier;
      }
    }

    check(equippedWeapon?.rarityEffects, equippedWeapon?.rarityTier);
    check(equippedHelmet?.rarityEffects, equippedHelmet?.rarityTier);
    check(equippedChestplate?.rarityEffects, equippedChestplate?.rarityTier);
    check(equippedLeggings?.rarityEffects, equippedLeggings?.rarityTier);
    check(equippedBoots?.rarityEffects, equippedBoots?.rarityTier);

    return total;
  }

  double get attackSpeed {
    double speed = equippedWeapon?.attackSpeed ?? ItemRegistry.fist.attackSpeed;
    final setEffect = ArmorSetService.getEffect(activeSetType);
    final weaponType = equippedWeapon?.weaponType ?? WeaponType.fist;
    if (setEffect != null) {
      speed *= setEffect.getAttackSpeedMultiplier(activeSetEnchantLevel, weaponType);
    }
    speed += SkillService.getAttackSpeedBonus(learnedSkills, weaponType);

    // Rarity bonus
    int rarityMult = getRarityEffectMultiplier(RarityEffect.attackSpeed);
    if (rarityMult > 0) {
      speed -= speed * (rarityMult * 0.05); // Attack speed decrease is better
    }

    return speed;
  }

  double get lowerDamage {
    double damage = equippedWeapon?.lowerDamage ?? ItemRegistry.fist.lowerDamage;
    final weaponType = equippedWeapon?.weaponType ?? WeaponType.fist;
    final setEffect = ArmorSetService.getEffect(activeSetType);
    if (setEffect != null) {
      damage += setEffect.getBonusLowerDamage(activeSetEnchantLevel, weaponType);
    }
    final bonusMultiplier = equippedWeapon != null ? SkillService.getEnchantmentBonusDamageMultiplier(learnedSkills, equippedWeapon!.enchantLevel) : 0.0;
    damage += damage * bonusMultiplier;

    // Rarity bonus
    int rarityMult = getRarityEffectMultiplier(RarityEffect.bonusDamage);
    if (rarityMult > 0) {
      damage += damage * (rarityMult * 0.05);
    }

    return damage;
  }

  double get higherDamage {
    double damage = equippedWeapon?.higherDamage ?? ItemRegistry.fist.higherDamage;
    final weaponType = equippedWeapon?.weaponType ?? WeaponType.fist;
    final setEffect = ArmorSetService.getEffect(activeSetType);
    if (setEffect != null) {
      damage += setEffect.getBonusHigherDamage(activeSetEnchantLevel, weaponType);
    }
    final bonusMultiplier = equippedWeapon != null ? SkillService.getEnchantmentBonusDamageMultiplier(learnedSkills, equippedWeapon!.enchantLevel) : 0.0;
    damage += damage * bonusMultiplier;

    // Rarity bonus
    int rarityMult = getRarityEffectMultiplier(RarityEffect.bonusDamage);
    if (rarityMult > 0) {
      damage += damage * (rarityMult * 0.05);
    }

    return damage;
  }

  int get defense {
    int totalDefense = 0;
    if (equippedHelmet != null) totalDefense += equippedHelmet!.defense;
    if (equippedChestplate != null) totalDefense += equippedChestplate!.defense;
    if (equippedLeggings != null) totalDefense += equippedLeggings!.defense;
    if (equippedBoots != null) totalDefense += equippedBoots!.defense;

    final setEffect = ArmorSetService.getEffect(activeSetType);
    if (setEffect != null) {
      final weaponType = equippedWeapon?.weaponType ?? WeaponType.fist;
      totalDefense += setEffect.getBonusDefense(activeSetEnchantLevel, weaponType);
    }

    // Rarity bonus
    int rarityMult = getRarityEffectMultiplier(RarityEffect.bonusDefense);
    if (rarityMult > 0) {
      totalDefense += (totalDefense * (rarityMult * 0.20)).round();
    }

    return totalDefense;
  }

  int get health {
    int hp = baseHealth;
    final setEffect = ArmorSetService.getEffect(activeSetType);
    if (setEffect != null) {
      hp += setEffect.getBonusHealth(activeSetEnchantLevel);
    }

    // Rarity bonus
    int rarityMult = getRarityEffectMultiplier(RarityEffect.maxHp);
    if (rarityMult > 0) {
      hp += (hp * (rarityMult * 0.025)).round();
    }

    return hp;
  }

  int get totalHpRegen {
    int regen = hpRegen;
    final setEffect = ArmorSetService.getEffect(activeSetType);
    if (setEffect != null) {
      regen += setEffect.getBonusHpRegen(activeSetEnchantLevel);
    }

    // Rarity bonus
    int rarityMult = getRarityEffectMultiplier(RarityEffect.hpRegen);
    if (rarityMult > 0) {
      regen += (regen * (rarityMult * 0.10)).round();
    }

    return regen;
  }

  int get critRate {
    int rate = equippedWeapon?.critRate ?? ItemRegistry.fist.critRate;
    final setEffect = ArmorSetService.getEffect(activeSetType);
    if (setEffect != null) {
      final weaponType = equippedWeapon?.weaponType ?? WeaponType.fist;
      rate += setEffect.getBonusCritRate(activeSetEnchantLevel, weaponType);
    }

    // Rarity bonus
    int rarityMult = getRarityEffectMultiplier(RarityEffect.critChance);
    if (rarityMult > 0) {
      rate += rarityMult * 5; // +5% flat
    }

    return rate;
  }

  int get critPower {
    int power = equippedWeapon?.critPower ?? ItemRegistry.fist.critPower;

    // Rarity bonus
    int rarityMult = getRarityEffectMultiplier(RarityEffect.critDamage);
    if (rarityMult > 0) {
      power += rarityMult * 25; // +25% flat
    }

    return power;
  }

  double get blockChance {
    double block = 0.0;

    // Rarity bonus
    int rarityMult = getRarityEffectMultiplier(RarityEffect.blockChance);
    if (rarityMult > 0) {
      block += rarityMult * 0.03; // +3% flat
    }

    return block;
  }

  double get lifesteal {
    double ls = 0.0;

    // Rarity bonus
    int rarityMult = getRarityEffectMultiplier(RarityEffect.lifesteal);
    if (rarityMult > 0) {
      ls += rarityMult * 0.06; // +6% flat
    }

    return ls;
  }

  double get dropChanceBonus {
    double bonus = 0.0;

    // Rarity bonus
    int rarityMult = getRarityEffectMultiplier(RarityEffect.dropChance);
    if (rarityMult > 0) {
      bonus += rarityMult * 0.01; // +1% flat
    }

    return bonus;
  }

  Character copyWith({
    int? level,
    int? currentExp,
    int? gold,
    int? skillPoints,
    Weapon? equippedWeapon,
    Armor? equippedHelmet,
    Armor? equippedChestplate,
    Armor? equippedLeggings,
    Armor? equippedBoots,
    int? baseHealth,
    int? hpRegen,
    int? currentHealth,
    Map<String, int>? learnedSkills,
    DateTime? escapeCooldownEndTime,
    DateTime? deathCooldownEndTime,
    bool clearWeapon = false,
    bool clearHelmet = false,
    bool clearChestplate = false,
    bool clearLeggings = false,
    bool clearBoots = false,
    bool clearEscapeCooldown = false,
    bool clearDeathCooldown = false,
  }) {
    return Character(
      level: level ?? this.level,
      currentExp: currentExp ?? this.currentExp,
      gold: gold ?? this.gold,
      skillPoints: skillPoints ?? this.skillPoints,
      equippedWeapon: clearWeapon ? null : (equippedWeapon ?? this.equippedWeapon),
      equippedHelmet: clearHelmet ? null : (equippedHelmet ?? this.equippedHelmet),
      equippedChestplate: clearChestplate ? null : (equippedChestplate ?? this.equippedChestplate),
      equippedLeggings: clearLeggings ? null : (equippedLeggings ?? this.equippedLeggings),
      equippedBoots: clearBoots ? null : (equippedBoots ?? this.equippedBoots),
      baseHealth: baseHealth ?? this.baseHealth,
      hpRegen: hpRegen ?? this.hpRegen,
      currentHealth: currentHealth ?? this.currentHealth,
      learnedSkills: learnedSkills ?? this.learnedSkills,
      escapeCooldownEndTime: clearEscapeCooldown ? null : (escapeCooldownEndTime ?? this.escapeCooldownEndTime),
      deathCooldownEndTime: clearDeathCooldown ? null : (deathCooldownEndTime ?? this.deathCooldownEndTime),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'level': level,
      'currentExp': currentExp,
      'gold': gold,
      'skillPoints': skillPoints,
      'equippedWeapon': equippedWeapon?.toJson(),
      'equippedHelmet': equippedHelmet?.toJson(),
      'equippedChestplate': equippedChestplate?.toJson(),
      'equippedLeggings': equippedLeggings?.toJson(),
      'equippedBoots': equippedBoots?.toJson(),
      'baseHealth': baseHealth,
      'hpRegen': hpRegen,
      'currentHealth': currentHealth,
      'learnedSkills': learnedSkills,
      'escapeCooldownEndTime': escapeCooldownEndTime?.toIso8601String(),
      'deathCooldownEndTime': deathCooldownEndTime?.toIso8601String(),
    };
  }

  factory Character.fromJson(Map<String, dynamic> json) {
    return Character(
      level: json['level'] ?? 1,
      currentExp: json['currentExp'] ?? 0,
      gold: json['gold'] ?? 0,
      skillPoints: json['skillPoints'] ?? 0,
      equippedWeapon: json['equippedWeapon'] != null ? Weapon.fromJson(json['equippedWeapon']) : null,
      equippedHelmet: json['equippedHelmet'] != null ? Armor.fromJson(json['equippedHelmet']) : null,
      equippedChestplate: json['equippedChestplate'] != null ? Armor.fromJson(json['equippedChestplate']) : null,
      equippedLeggings: json['equippedLeggings'] != null ? Armor.fromJson(json['equippedLeggings']) : null,
      equippedBoots: json['equippedBoots'] != null ? Armor.fromJson(json['equippedBoots']) : null,
      baseHealth: json['baseHealth'] ?? 100,
      hpRegen: json['hpRegen'] ?? 1,
      currentHealth: json['currentHealth'],
      learnedSkills: json['learnedSkills'] != null ? Map<String, int>.from(json['learnedSkills']) : const {},
      escapeCooldownEndTime: json['escapeCooldownEndTime'] != null ? DateTime.parse(json['escapeCooldownEndTime']) : null,
      deathCooldownEndTime: json['deathCooldownEndTime'] != null ? DateTime.parse(json['deathCooldownEndTime']) : null,
    );
  }
}
