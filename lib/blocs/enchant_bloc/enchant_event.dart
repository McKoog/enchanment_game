import 'package:enchantment_game/models/weapon.dart';

sealed class EnchantEvent{}

class EnchantEvent$InsertWeapon extends EnchantEvent{
  EnchantEvent$InsertWeapon({required this.weapon});

  final Weapon weapon;
}

class EnchantEvent$StartEnchanting extends EnchantEvent{
  EnchantEvent$StartEnchanting({required this.weapon});

  final Weapon weapon;
}