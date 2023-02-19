// ignore_for_file: file_names

import 'package:enchantment_game/game_stock_items/game_stock%20items.dart';
import 'package:enchantment_game/models/item.dart';
import 'package:enchantment_game/models/weapon.dart';

class Inventory{
  Inventory({required this.items});
  List<Item?> items;

  Inventory swapItems(int from, int to){
    items[to] = items[from];
    items[from] = null;
    return Inventory(items: items);
  }

  List<Weapon> getAllMyWeapons(bool includingFist){
    List<Weapon> weapons = [];
    if(includingFist)weapons.add(stockFist);
    items.forEach((element) {
      if(element != null && element.type == ItemType.weapon) weapons.add(element as Weapon);
    });
    return weapons;
  }

  Inventory putItem(Item item){
    bool added = false;
    for(int i = 0; i < items.length; i++){
      if(items[i] == null && !added){
        items[i] = item;
        added = true;
      }
    }
      return Inventory(items: items);
  }

  Inventory removeItem(Item item){
    bool removed = false;
    for(int i = 0; i < items.length; i++){
      if(items[i] != null && items[i]!.id == item.id && !removed){
        items[i] = null;
        removed = true;
      }
    }
    return Inventory(items: items);
  }

  bool isLastFiveSlots(){
    int emptySlots = 0;
    items.forEach((element) {
      if(element == null){
        emptySlots++;
      }
    });
    return emptySlots <= 5;
  }
}