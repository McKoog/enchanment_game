import 'package:enchantment_game/game_stock_data/item_registry.dart';
import 'package:enchantment_game/models/armor.dart';
import 'package:enchantment_game/models/item.dart';
import 'package:enchantment_game/models/scroll.dart';
import 'package:enchantment_game/models/weapon.dart';

class Inventory {
  Inventory({required this.items});

  static const int defaultCapacity = 25;

  List<Item?> items;

  /// Number of empty slots remaining.
  int get emptySlots => items.where((item) => item == null).length;

  /// Whether the inventory has no empty slots.
  bool get isFull => items.every((item) => item != null);

  Map toJson() {
    List<Map?> mapItems = [];
    for (var element in items) {
      if (element == null) {
        mapItems.add(null);
      } else {
        if (element.type == ItemType.weapon) {
          Weapon weapon = element as Weapon;
          mapItems.add(weapon.toJson());
        } else if (element.type == ItemType.armor) {
          Armor armor = element as Armor;
          mapItems.add(armor.toJson());
        } else {
          Scroll scroll = element as Scroll;
          mapItems.add(scroll.toJson());
        }
      }
    }
    return {'items': mapItems};
  }

  factory Inventory.fromJson(Map<String, dynamic> json) {
    List<Item?> items = [];

    var x = json['items'] as List;

    for (var element in x) {
      if (element == null) {
        items.add(null);
      } else {
        if (element['type'] == ItemType.weapon.name) {
          items.add(Weapon.fromJson(element));
        } else if (element['type'] == ItemType.armor.name) {
          items.add(Armor.fromJson(element));
        } else if (element['type'] == ItemType.scroll.name) {
          items.add(Scroll.fromJson(element));
        }
      }
    }

    return Inventory(
      items: items,
    );
  }

  List<Weapon> getAllMyWeapons(bool includingFist) {
    List<Weapon> weapons = [];
    if (includingFist) weapons.add(ItemRegistry.fist);
    for (var element in items) {
      if (element != null && element.type == ItemType.weapon) {
        weapons.add(element as Weapon);
      }
    }
    return weapons;
  }
}
