import 'dart:convert';

import 'package:enchantment_game/models/inventory.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Handles saving and loading game data via [SharedPreferences].
class SaveService {
  static const String _inventoryKey = 'saved_inventory';

  /// Persist the current [inventory] to local storage.
  static Future<void> saveInventory(Inventory inventory) async {
    final prefs = await SharedPreferences.getInstance();
    final json = jsonEncode(inventory.toJson());
    await prefs.setString(_inventoryKey, json);
  }

  /// Load a previously saved inventory, or `null` if none exists.
  static Future<Inventory?> loadInventory() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_inventoryKey);
    if (jsonString == null) return null;
    try {
      final json = jsonDecode(jsonString) as Map<String, dynamic>;
      return Inventory.fromJson(json);
    } catch (_) {
      return null;
    }
  }

  /// Remove saved inventory data.
  static Future<void> clearSave() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_inventoryKey);
  }
}
