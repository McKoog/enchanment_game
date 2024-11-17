import 'package:enchantment_game/models/monster.dart';
import 'package:enchantment_game/models/weapon.dart';

sealed class HuntingFieldState {
  HuntingFieldState(
      {required this.selectedWeapon, required this.selectedMonster});

  final Weapon selectedWeapon;
  final Monster selectedMonster;
}

class HuntingFieldState$PickPhase extends HuntingFieldState {
  HuntingFieldState$PickPhase(
      {required super.selectedWeapon, required super.selectedMonster});
}

class HuntingFieldState$HuntingStarted extends HuntingFieldState {
  HuntingFieldState$HuntingStarted(
      {required super.selectedWeapon, required super.selectedMonster});
}
