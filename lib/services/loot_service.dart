import 'package:enchantment_game/game_stock_data/item_registry.dart';
import 'package:enchantment_game/models/enemy.dart';
import 'package:enchantment_game/models/item.dart';
import 'package:enchantment_game/utils/game_random.dart';

/// Result of loot generation after killing an enemy.
class LootResult {
  final List<Item> items;

  const LootResult({required this.items});
}

class LootService {
  LootService._();

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
            loot.add(ItemRegistry.createItem(
              drop.itemType,
              weaponType: drop.weaponType,
              armorType: drop.armorType,
              scrollType: drop.scrollType,
            ));
          }
        }
      }
    }

    return LootResult(items: loot);
  }
}
