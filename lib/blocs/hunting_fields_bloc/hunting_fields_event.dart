import 'package:enchantment_game/models/enemy.dart';
import 'package:enchantment_game/models/weapon.dart';

sealed class HuntingFieldEvent {}

class HuntingFieldEvent$SelectEnemy extends HuntingFieldEvent {
  HuntingFieldEvent$SelectEnemy({required this.enemy});

  final Enemy enemy;
}

class HuntingFieldEvent$SelectWeapon extends HuntingFieldEvent {
  HuntingFieldEvent$SelectWeapon({required this.weapon});

  final Weapon weapon;
}

class HuntingFieldEvent$StartHunting extends HuntingFieldEvent {}

class HuntingFieldEvent$StopHunting extends HuntingFieldEvent {}
