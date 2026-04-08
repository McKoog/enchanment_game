import 'package:enchantment_game/models/armor.dart';
import 'package:enchantment_game/models/drop_item.dart';
import 'package:enchantment_game/models/enemy.dart';
import 'package:enchantment_game/models/item.dart';
import 'package:enchantment_game/models/scroll.dart';
import 'package:enchantment_game/models/weapon.dart';

final stockWerewolf =
    Enemy(id: 'werewolf', name: 'Werewolf', image: "assets/icons/enemies/lvl_1_werewolf.png", hp: 200, attack: 25, attackSpeed: 1.0, dropList: [
  DropItem(chance: 5, itemType: ItemType.weapon, weaponType: WeaponType.sword),
  DropItem(chance: 25, itemType: ItemType.scroll, scrollType: ScrollType.weapon),
  DropItem(chance: 25, itemType: ItemType.scroll, scrollType: ScrollType.armor),
  DropItem(chance: 1, itemType: ItemType.weapon, weaponType: WeaponType.dagger),
  DropItem(chance: 1, itemType: ItemType.weapon, weaponType: WeaponType.bow),
]);

final greyWolf = Enemy(
  id: 'grey_wolf',
  name: 'Grey Wolf',
  image: "assets/icons/enemies/wolf.png",
  hp: 50,
  attack: 10,
  attackSpeed: 1.0,
  dropList: [
    DropItem(chance: 80, itemType: ItemType.gold, minQuantity: 2, maxQuantity: 2),
    DropItem(chance: 15, itemType: ItemType.armor, armorType: ArmorType.helmet),
    DropItem(chance: 15, itemType: ItemType.armor, armorType: ArmorType.chestplate),
    DropItem(chance: 15, itemType: ItemType.armor, armorType: ArmorType.leggings),
    DropItem(chance: 15, itemType: ItemType.armor, armorType: ArmorType.boots),
    DropItem(chance: 10, itemType: ItemType.scroll, scrollType: ScrollType.weapon),
    DropItem(chance: 15, itemType: ItemType.scroll, scrollType: ScrollType.armor),
  ],
);

final bandit = Enemy(
  id: 'bandit',
  name: 'Bandit',
  image: "assets/icons/enemies/bandit.png",
  hp: 75,
  attack: 15,
  attackSpeed: 0.75,
  dropList: [
    DropItem(chance: 80, itemType: ItemType.gold, minQuantity: 4, maxQuantity: 4),
    DropItem(chance: 15, itemType: ItemType.weapon, weaponType: WeaponType.sword),
    DropItem(chance: 20, itemType: ItemType.weapon, weaponType: WeaponType.dagger),
    DropItem(chance: 15, itemType: ItemType.scroll, scrollType: ScrollType.weapon),
    DropItem(chance: 20, itemType: ItemType.scroll, scrollType: ScrollType.armor),
  ],
);

final goblin = Enemy(
  id: 'goblin',
  name: 'Goblin',
  image: "assets/icons/enemies/goblin.png",
  hp: 100,
  attack: 20,
  attackSpeed: 0.5,
  dropList: [
    DropItem(chance: 80, itemType: ItemType.gold, minQuantity: 7, maxQuantity: 7),
    DropItem(chance: 25, itemType: ItemType.weapon, weaponType: WeaponType.sword),
    DropItem(chance: 15, itemType: ItemType.weapon, weaponType: WeaponType.dagger),
    DropItem(chance: 20, itemType: ItemType.scroll, scrollType: ScrollType.weapon),
    DropItem(chance: 20, itemType: ItemType.scroll, scrollType: ScrollType.armor),
  ],
);

final dryad = Enemy(
  id: 'dryad',
  name: 'Dryad',
  image: "assets/icons/enemies/dryad.png",
  hp: 150,
  attack: 25,
  attackSpeed: 0.5,
  dropList: [
    DropItem(chance: 80, itemType: ItemType.gold, minQuantity: 10, maxQuantity: 10),
    DropItem(chance: 33, itemType: ItemType.weapon, weaponType: WeaponType.bow),
    DropItem(chance: 15, itemType: ItemType.weapon, weaponType: WeaponType.sword),
    DropItem(chance: 15, itemType: ItemType.weapon, weaponType: WeaponType.dagger),
    DropItem(chance: 33, itemType: ItemType.scroll, scrollType: ScrollType.weapon),
    DropItem(chance: 40, itemType: ItemType.scroll, scrollType: ScrollType.armor),
  ],
);
