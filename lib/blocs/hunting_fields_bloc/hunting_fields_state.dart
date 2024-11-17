import 'package:enchantment_game/models/monster.dart';
import 'package:enchantment_game/models/weapon.dart';

class HuntingFieldState{
  HuntingFieldState({required this.selectedWeapon, required this.selectedMonster});

  final Weapon selectedWeapon;
  final Monster selectedMonster;
}