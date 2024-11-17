import 'package:enchantment_game/models/monster.dart';
import 'package:enchantment_game/models/weapon.dart';

sealed class HuntingFieldEvent{}

class HuntingFieldEvent$SelectMonster extends HuntingFieldEvent {
  HuntingFieldEvent$SelectMonster({required this.monster});

  final Monster monster;
}

class HuntingFieldEvent$SelectWeapon extends HuntingFieldEvent {
  HuntingFieldEvent$SelectWeapon({required this.weapon});

  final Weapon weapon;
}