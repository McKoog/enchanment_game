import 'package:enchantment_game/models/character.dart';
import 'package:enchantment_game/utils/game_random.dart';

/// Result of a single attack.
class AttackResult {
  final double damage;
  final bool isCrit;

  const AttackResult({required this.damage, required this.isCrit});
}

/// Pure combat logic — no Flutter dependency.
///
/// All damage calculation and loot generation lives here,
/// making it easy to test and extend without touching UI code.
class CombatService {
  CombatService._();

  /// Calculate damage dealt by [character].
  ///
  /// Preserves the original damage distribution:
  /// roll [0, higherDamage], clamp to lowerDamage minimum, then apply crit.
  static AttackResult calculateDamage(Character character) {
    double damage =
        GameRandom.nextInt(character.higherDamage.toInt() + 1).toDouble();
    if (damage < character.lowerDamage) {
      damage = character.lowerDamage;
    }

    bool isCrit = GameRandom.chance(character.critRate.toDouble());
    if (isCrit) {
      double critBonus = damage * (character.critPower / 100);
      damage += critBonus;
    }

    return AttackResult(damage: damage, isCrit: isCrit);
  }
}
