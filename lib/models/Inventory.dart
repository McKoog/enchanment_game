// ignore_for_file: file_names

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
    if(includingFist)weapons.add(Weapon(type: ItemType.weapon,isSvgAsset: false, image: "assets/fist.png", name: "Fists", lowerDamage: 1, higherDamage: 1, enchantLevel: 0));
    items.forEach((element) {
      if(element != null && element.type == ItemType.weapon) weapons.add(element as Weapon);
    });
    return weapons;
  }
}