import 'package:enchantment_game/game_stock_data/stock_items.dart';
import 'package:enchantment_game/models/item.dart';
import 'package:enchantment_game/models/scroll.dart';
import 'package:enchantment_game/models/weapon.dart';

class Inventory {
  Inventory({required this.items});

  List<Item?> items;

  Map toJson() {
    List<Map?> mapItems = [];
    for (var element in items) {
      if (element == null) {
        mapItems.add(null);
      } else {
        if (element.type == ItemType.weapon) {
          Weapon weapon = element as Weapon;
          mapItems.add(weapon.toJson());
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
        if (element['type'] == 'weapon') {
          Weapon weapon = Weapon.fromJson(element);
          items.add(weapon);
        } else {
          Scroll scroll = Scroll.fromJson(element);
          items.add(scroll);
        }
      }
    }

    return Inventory(
      items: items,
    );
  }

  List<Weapon> getAllMyWeapons(bool includingFist) {
    List<Weapon> weapons = [];
    if (includingFist) weapons.add(stockFist);
    for (var element in items) {
      if (element != null && element.type == ItemType.weapon) {
        weapons.add(element as Weapon);
      }
    }
    return weapons;
  }

  bool isLastFiveSlots() {
    int emptySlots = 0;
    for (var element in items) {
      if (element == null) {
        emptySlots++;
      }
    }
    return emptySlots <= 5;
  }
}
