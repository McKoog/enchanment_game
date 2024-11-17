import 'package:enchantment_game/models/item.dart';
import 'package:enchantment_game/models/scroll.dart';
import 'package:enchantment_game/models/weapon.dart';
import 'package:uuid/uuid.dart';

final Weapon stockFist = Weapon(
    id: "Fist",
    type: ItemType.weapon,
    isSvgAsset: false,
    image: "assets/fist.png",
    name: "Fists",
    weaponType: WeaponType.fist,
    lowerDamage: 1,
    higherDamage: 1,
    critRate: 0,
    critPower: 0,
    enchantLevel: 0);

final Weapon stockBasicSword = Weapon(
    id: "BasicSword",
    type: ItemType.weapon,
    image: "assets/sword.svg",
    name: "Basic Sword",
    weaponType: WeaponType.sword,
    lowerDamage: 2,
    higherDamage: 3,
    critRate: 15,
    critPower: 50,
    enchantLevel: 0);

final Weapon stockBow = Weapon(
    id: "Bow",
    type: ItemType.weapon,
    isSvgAsset: false,
    image: "assets/bow.png",
    name: "Long Bow",
    weaponType: WeaponType.bow,
    lowerDamage: 1,
    higherDamage: 5,
    critRate: 10,
    critPower: 75,
    enchantLevel: 0);

final Weapon stockDagger = Weapon(
    id: "Dagger",
    type: ItemType.weapon,
    isSvgAsset: false,
    image: "assets/dagger.png",
    name: "Dagger",
    weaponType: WeaponType.dagger,
    lowerDamage: 1,
    higherDamage: 2,
    critRate: 40,
    critPower: 100,
    enchantLevel: 0);

final Scroll stockScroll = Scroll(
    id: "Scroll",
    type: ItemType.scroll,
    image: "assets/enchant_scroll.svg",
    name: "Scroll of enchant",
    description:
        "Increase power of the weapon, but be carefull, it's not garanteed");

Item? getNewStockItem(ItemType type,[WeaponType? weaponType,String? id]) {
  Item? newItem;
  String uuid = Uuid().v1().toString();
  if(type == ItemType.scroll){
    newItem = Scroll.copyWith(stockScroll);
    newItem.id = uuid;
  }
  else if(type == ItemType.weapon){
    if(weaponType == WeaponType.sword || weaponType == null) {
      newItem = Weapon.copyWith(stockBasicSword);
      newItem.id = uuid;
    }
    else if(weaponType == WeaponType.bow){
      newItem = Weapon.copyWith(stockBow);
      newItem.id = uuid;
    }
    else if(weaponType == WeaponType.dagger) {
      newItem = Weapon.copyWith(stockDagger);
      newItem.id = uuid;
    }
  }
  return newItem;
}
