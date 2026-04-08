import 'package:enchantment_game/game_stock_data/item_registry.dart';
import 'package:enchantment_game/models/enemy.dart';
import 'package:enchantment_game/models/item.dart';
import 'package:enchantment_game/models/weapon.dart';
import 'package:enchantment_game/utils/game_random.dart';

/// Result of a single attack.
class AttackResult {
  final int damage;
  final bool isCrit;

  const AttackResult({required this.damage, required this.isCrit});
}

/// Result of loot generation after killing an enemy.
class LootResult {
  final List<Item> items;

  const LootResult({required this.items});
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

  /// Generate loot drops from a killed [enemy].
  static LootResult generateLoot(Enemy enemy) {
    final List<Item> loot = [];

    for (final drop in enemy.dropList) {
      if (GameRandom.chance(drop.chance)) {
        final quantity = drop.minQuantity == drop.maxQuantity
            ? drop.minQuantity
            : drop.minQuantity +
                GameRandom.nextInt(drop.maxQuantity - drop.minQuantity + 1);

        if (drop.itemType == ItemType.gold) {
          loot.add(ItemRegistry.createGold(quantity));
        } else {
          for (int i = 0; i < quantity; i++) {
            loot.add(ItemRegistry.createItem(drop.itemType,
                weaponType: drop.weaponType,
                armorType: drop.armorType,
                scrollType: drop.scrollType));
          }
        }
      }
    }

    return LootResult(items: loot);
  }
}
