import 'package:enchantment_game/models/armor.dart';
import 'package:enchantment_game/models/weapon.dart';

sealed class CharacterEvent {}

class CharacterEquipWeapon extends CharacterEvent {
  final Weapon weapon;
  CharacterEquipWeapon(this.weapon);
}

class CharacterUnequipWeapon extends CharacterEvent {}

class CharacterEquipArmor extends CharacterEvent {
  final Armor armor;
  CharacterEquipArmor(this.armor);
}

class CharacterUnequipArmor extends CharacterEvent {
  final ArmorType armorType;
  CharacterUnequipArmor(this.armorType);
}

class CharacterAddExp extends CharacterEvent {
  final int amount;
  final int spAmount;
  CharacterAddExp(this.amount, {this.spAmount = 0});
}

class CharacterAddGold extends CharacterEvent {
  final int amount;
  CharacterAddGold(this.amount);
}

class CharacterAddSkillPoints extends CharacterEvent {
  final int amount;
  CharacterAddSkillPoints(this.amount);
}

class CharacterTakeDamage extends CharacterEvent {
  final double damage;
  CharacterTakeDamage(this.damage);
}

class CharacterHeal extends CharacterEvent {
  final int amount;
  CharacterHeal(this.amount);
}

class CharacterRespawn extends CharacterEvent {}

class CharacterStartEscapeCooldown extends CharacterEvent {}

class CharacterClearEscapeCooldown extends CharacterEvent {}

class CharacterUpgradeSkill extends CharacterEvent {
  final String skillName;
  final int cost;
  CharacterUpgradeSkill(this.skillName, this.cost);
}

class CharacterLoad extends CharacterEvent {}

class CharacterReset extends CharacterEvent {}
