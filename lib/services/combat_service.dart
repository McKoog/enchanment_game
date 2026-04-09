import 'package:enchantment_game/models/weapon.dart';
import 'package:enchantment_game/utils/game_random.dart';

/// Result of a single attack.
class AttackResult {
  final int damage;
  final bool isCrit;

  const AttackResult({required this.damage, required this.isCrit});
}

/// Pure combat logic — no Flutter dependency.
///
/// All damage calculation and loot generation lives here,
/// making it easy to test and extend without touching UI code.
class CombatService {
  CombatService._();

  /// Calculate damage dealt by [weapon].
  ///
  /// Preserves the original damage distribution:
  /// roll [0, higherDamage], clamp to lowerDamage minimum, then apply crit.
  static AttackResult calculateDamage(Weapon weapon) {
    int damage = GameRandom.nextInt(weapon.higherDamage + 1);
    if (damage < weapon.lowerDamage) {
      damage = weapon.lowerDamage;
    }

    bool isCrit = GameRandom.chance(weapon.critRate.toDouble());
    if (isCrit) {
      double critBonus = damage * (weapon.critPower / 100);
      damage += critBonus.toInt();
    }

    return AttackResult(damage: damage, isCrit: isCrit);
  }
}
