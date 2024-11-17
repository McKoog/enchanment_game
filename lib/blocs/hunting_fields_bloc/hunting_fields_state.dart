import 'package:enchantment_game/models/enemy.dart';
import 'package:enchantment_game/models/weapon.dart';

sealed class HuntingFieldState {
  HuntingFieldState(
      {required this.selectedWeapon, required this.selectedEnemy});

  final Weapon selectedWeapon;
  final Enemy selectedEnemy;
}

class HuntingFieldState$PickPhase extends HuntingFieldState {
  HuntingFieldState$PickPhase(
      {required super.selectedWeapon, required super.selectedEnemy});
}

class HuntingFieldState$HuntingStarted extends HuntingFieldState {
  HuntingFieldState$HuntingStarted(
      {required super.selectedWeapon, required super.selectedEnemy});
}
