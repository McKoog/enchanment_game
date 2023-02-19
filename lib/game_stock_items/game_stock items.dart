import 'package:enchantment_game/models/item.dart';
import 'package:enchantment_game/models/scroll.dart';
import 'package:enchantment_game/models/weapon.dart';
import 'package:uuid/uuid.dart';

Weapon stockFist = Weapon(
    id: "Fist",
    type: ItemType.weapon,
    isSvgAsset: false,
    image: "assets/fist.png",
    name: "Fists",
    lowerDamage: 1,
    higherDamage: 1,
    enchantLevel: 0);

Weapon stockBasicSword = Weapon(
    id: "BasicSword",
    type: ItemType.weapon,
    image: "assets/sword.svg",
    name: "Basic Sword",
    lowerDamage: 50,
    higherDamage: 3,
    enchantLevel: 0);

Scroll stockScroll = Scroll(
    id: "Scroll",
    type: ItemType.scroll,
    image: "assets/enchant_scroll.svg",
    name: "Scroll of enchant",
    description:
        "Increase power of the weapon, but be carefull, it's not garanteed");

Item? getNewStockItem(ItemType type,[String? id]) {
  Item? newItem;
  String uuid = Uuid().v1().toString();
  if(type == ItemType.scroll){
    newItem = Scroll.copyWith(stockScroll);
    newItem.id = uuid;
  }
  else if(type == ItemType.weapon){
    newItem = Weapon.copyWith(stockBasicSword);
    newItem.id = uuid;
  }
  return newItem;
}
