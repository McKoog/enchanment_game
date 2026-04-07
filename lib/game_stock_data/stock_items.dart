// All item templates have been moved to ItemRegistry.
// This file is kept for backward compatibility.

import 'package:enchantment_game/game_stock_data/item_registry.dart';
import 'package:enchantment_game/models/weapon.dart';

/// The fist weapon singleton.
///
/// Prefer using [ItemRegistry.fist] directly in new code.
Weapon get stockFist => ItemRegistry.fist;
