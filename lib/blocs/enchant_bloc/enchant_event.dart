import 'package:enchantment_game/models/weapon.dart';

sealed class EnchantEvent {}

class EnchantEvent$InsertWeapon extends EnchantEvent {
  EnchantEvent$InsertWeapon({required this.weapon});

  final Weapon weapon;
}

class EnchantEvent$StartEnchanting extends EnchantEvent {
  EnchantEvent$StartEnchanting({required this.weapon});

  final Weapon weapon;
}

class EnchantEvent$FinishEnchanting extends EnchantEvent {
  EnchantEvent$FinishEnchanting({required this.weapon, required this.runToken});

  final Weapon weapon;
  final int runToken;
}

class EnchantEvent$CancelEnchanting extends EnchantEvent {}
