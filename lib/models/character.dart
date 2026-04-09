import 'package:enchantment_game/game_stock_data/item_registry.dart';
import 'package:enchantment_game/models/armor.dart';
import 'package:enchantment_game/models/weapon.dart';

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

  final DateTime? escapeCooldownEndTime;
  final DateTime? deathCooldownEndTime;

  int get maxExp {
    double exp = 100;
    for (int i = 1; i < level; i++) {
      exp *= 1.25;
    }
    return exp.toInt();
  }

  double get attackSpeed =>
      equippedWeapon?.attackSpeed ?? ItemRegistry.fist.attackSpeed;

  double get lowerDamage =>
      equippedWeapon?.lowerDamage ?? ItemRegistry.fist.lowerDamage;

  double get higherDamage =>
      equippedWeapon?.higherDamage ?? ItemRegistry.fist.higherDamage;

  int get defense {
    int totalDefense = 0;
    if (equippedHelmet != null) totalDefense += equippedHelmet!.defense;
    if (equippedChestplate != null) totalDefense += equippedChestplate!.defense;
    if (equippedLeggings != null) totalDefense += equippedLeggings!.defense;
    if (equippedBoots != null) totalDefense += equippedBoots!.defense;
    return totalDefense;
  }

  int get health => baseHealth;

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
      equippedWeapon:
          clearWeapon ? null : (equippedWeapon ?? this.equippedWeapon),
      equippedHelmet:
          clearHelmet ? null : (equippedHelmet ?? this.equippedHelmet),
      equippedChestplate: clearChestplate
          ? null
          : (equippedChestplate ?? this.equippedChestplate),
      equippedLeggings:
          clearLeggings ? null : (equippedLeggings ?? this.equippedLeggings),
      equippedBoots: clearBoots ? null : (equippedBoots ?? this.equippedBoots),
      baseHealth: baseHealth ?? this.baseHealth,
      hpRegen: hpRegen ?? this.hpRegen,
      currentHealth: currentHealth ?? this.currentHealth,
      escapeCooldownEndTime: clearEscapeCooldown
          ? null
          : (escapeCooldownEndTime ?? this.escapeCooldownEndTime),
      deathCooldownEndTime: clearDeathCooldown
          ? null
          : (deathCooldownEndTime ?? this.deathCooldownEndTime),
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
      equippedWeapon: json['equippedWeapon'] != null
          ? Weapon.fromJson(json['equippedWeapon'])
          : null,
      equippedHelmet: json['equippedHelmet'] != null
          ? Armor.fromJson(json['equippedHelmet'])
          : null,
      equippedChestplate: json['equippedChestplate'] != null
          ? Armor.fromJson(json['equippedChestplate'])
          : null,
      equippedLeggings: json['equippedLeggings'] != null
          ? Armor.fromJson(json['equippedLeggings'])
          : null,
      equippedBoots: json['equippedBoots'] != null
          ? Armor.fromJson(json['equippedBoots'])
          : null,
      baseHealth: json['baseHealth'] ?? 100,
      hpRegen: json['hpRegen'] ?? 1,
      currentHealth: json['currentHealth'],
      escapeCooldownEndTime: json['escapeCooldownEndTime'] != null
          ? DateTime.parse(json['escapeCooldownEndTime'])
          : null,
      deathCooldownEndTime: json['deathCooldownEndTime'] != null
          ? DateTime.parse(json['deathCooldownEndTime'])
          : null,
    );
  }
}
