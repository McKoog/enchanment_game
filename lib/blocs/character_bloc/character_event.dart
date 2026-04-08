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
  CharacterAddExp(this.amount);
}

class CharacterAddGold extends CharacterEvent {
  final int amount;
  CharacterAddGold(this.amount);
}

class CharacterAddSkillPoints extends CharacterEvent {
  final int amount;
  CharacterAddSkillPoints(this.amount);
}

class CharacterLoad extends CharacterEvent {}
