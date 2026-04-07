import 'package:enchantment_game/models/item.dart';
import 'package:enchantment_game/models/weapon.dart';

/// Describes a potential drop from an enemy.
///
/// Instead of holding a concrete [Item] reference, stores descriptive fields
/// so the actual item instance is created at drop time via [ItemRegistry].
class DropItem {
  DropItem({
    required this.chance,
    required this.itemType,
    this.weaponType,
    this.minQuantity = 1,
    this.maxQuantity = 1,
  });

  /// Drop chance as a percentage (0.0 – 100.0).
  final double chance;

  /// The type of item that can drop.
  final ItemType itemType;

  /// Weapon subtype (required when [itemType] == [ItemType.weapon]).
  final WeaponType? weaponType;

  /// Minimum number of items per drop.
  final int minQuantity;

  /// Maximum number of items per drop.
  final int maxQuantity;
}
