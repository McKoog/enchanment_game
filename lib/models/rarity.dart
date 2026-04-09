enum RarityTier {
  common,
  uncommon,
  rare,
  mythical,
  legendary,
  godlike,
}

enum RarityEffect {
  bonusDamage,
  attackSpeed,
  bonusDefense,
  critChance,
  critDamage,
  dropChance,
  blockChance,
  lifesteal,
  maxHp,
  hpRegen,
}

extension RarityTierExtension on RarityTier {
  String get displayName {
    switch (this) {
      case RarityTier.common:
        return 'Common';
      case RarityTier.uncommon:
        return 'Uncommon';
      case RarityTier.rare:
        return 'Rare';
      case RarityTier.mythical:
        return 'Mythical';
      case RarityTier.legendary:
        return 'Legendary';
      case RarityTier.godlike:
        return 'GODLIKE';
    }
  }

  int get effectMultiplier {
    switch (this) {
      case RarityTier.common:
      case RarityTier.uncommon:
      case RarityTier.rare:
        return 1;
      case RarityTier.mythical:
      case RarityTier.legendary:
        return 2;
      case RarityTier.godlike:
        return 3;
    }
  }

  int get effectCount {
    switch (this) {
      case RarityTier.common:
        return 0;
      case RarityTier.uncommon:
        return 1;
      case RarityTier.rare:
      case RarityTier.mythical:
        return 2;
      case RarityTier.legendary:
        return 3;
      case RarityTier.godlike:
        return 4;
    }
  }
}

extension RarityEffectExtension on RarityEffect {
  String getDescription(int multiplier) {
    switch (this) {
      case RarityEffect.bonusDamage:
        return '+ ${5 * multiplier}% damage';
      case RarityEffect.attackSpeed:
        return '+ ${5 * multiplier}% attack speed';
      case RarityEffect.bonusDefense:
        return '+ ${5 * multiplier}% defense';
      case RarityEffect.critChance:
        return '+ ${5 * multiplier}% crit chance';
      case RarityEffect.critDamage:
        return '+ ${33 * multiplier}% crit damage';
      case RarityEffect.dropChance:
        return '+ ${1 * multiplier}% item drop chance';
      case RarityEffect.blockChance:
        return '+ ${3 * multiplier}% block chance';
      case RarityEffect.lifesteal:
        return '+ ${6 * multiplier}% lifesteal';
      case RarityEffect.maxHp:
        return '+ ${2.5 * multiplier}% max hp';
      case RarityEffect.hpRegen:
        return '+ ${2.5 * multiplier}% hp regen';
    }
  }
}
