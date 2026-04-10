import 'package:enchantment_game/models/armor.dart';
import 'package:enchantment_game/models/drop_item.dart';
import 'package:enchantment_game/models/enemy.dart';
import 'package:enchantment_game/models/item.dart';
import 'package:enchantment_game/models/scroll.dart';
import 'package:enchantment_game/models/weapon.dart';

final stockWerewolf = Enemy(
    id: 'werewolf',
    name: 'Werewolf',
    image: "assets/icons/enemies/lvl_1_werewolf.png",
    hp: 200,
    attack: 25.0,
    attackSpeed: 1.0,
    expReward: 100,
    spReward: 8,
    dropList: [
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
  attack: 10.0,
  attackSpeed: 1.0,
  expReward: 5,
  spReward: 1,
  dropList: [
    DropItem(chance: 80, itemType: ItemType.gold, minQuantity: 5, maxQuantity: 10),
    DropItem(chance: 10, itemType: ItemType.scroll, scrollType: ScrollType.armor),
    DropItem(chance: 7, itemType: ItemType.weapon, weaponType: WeaponType.sword),
    DropItem(chance: 5, itemType: ItemType.armor, armorType: ArmorType.helmet),
    DropItem(chance: 5, itemType: ItemType.armor, armorType: ArmorType.chestplate),
    DropItem(chance: 5, itemType: ItemType.armor, armorType: ArmorType.leggings),
    DropItem(chance: 5, itemType: ItemType.armor, armorType: ArmorType.boots),
    DropItem(chance: 5, itemType: ItemType.scroll, scrollType: ScrollType.weapon),
    DropItem(chance: 4, itemType: ItemType.weapon, weaponType: WeaponType.dagger),
    DropItem(chance: 4, itemType: ItemType.weapon, weaponType: WeaponType.bow),
  ],
);

final bandit = Enemy(
  id: 'bandit',
  name: 'Bandit',
  image: "assets/icons/enemies/bandit.png",
  hp: 100,
  attack: 20.0,
  attackSpeed: 0.75,
  expReward: 20,
  spReward: 2,
  dropList: [
    DropItem(chance: 80, itemType: ItemType.gold, minQuantity: 10, maxQuantity: 20),
    DropItem(chance: 20, itemType: ItemType.scroll, scrollType: ScrollType.armor),
    DropItem(chance: 12, itemType: ItemType.weapon, weaponType: WeaponType.dagger),
    DropItem(chance: 12, itemType: ItemType.weapon, weaponType: WeaponType.bow),
    DropItem(chance: 12, itemType: ItemType.weapon, weaponType: WeaponType.sword),
    DropItem(chance: 12, itemType: ItemType.scroll, scrollType: ScrollType.weapon),
    DropItem(chance: 9, itemType: ItemType.armor, armorType: ArmorType.helmet),
    DropItem(chance: 9, itemType: ItemType.armor, armorType: ArmorType.chestplate),
    DropItem(chance: 9, itemType: ItemType.armor, armorType: ArmorType.leggings),
    DropItem(chance: 9, itemType: ItemType.armor, armorType: ArmorType.boots),
  ],
);

final goblin = Enemy(
  id: 'goblin',
  name: 'Goblin',
  image: "assets/icons/enemies/goblin.png",
  hp: 200,
  attack: 30.0,
  attackSpeed: 0.5,
  expReward: 50,
  spReward: 4,
  dropList: [
    DropItem(chance: 80, itemType: ItemType.gold, minQuantity: 25, maxQuantity: 30),
    DropItem(chance: 25, itemType: ItemType.scroll, scrollType: ScrollType.armor),
    DropItem(chance: 20, itemType: ItemType.weapon, weaponType: WeaponType.sword),
    DropItem(chance: 20, itemType: ItemType.scroll, scrollType: ScrollType.weapon),
    DropItem(chance: 18, itemType: ItemType.weapon, weaponType: WeaponType.dagger),
    DropItem(chance: 15, itemType: ItemType.armor, armorType: ArmorType.helmet),
    DropItem(chance: 15, itemType: ItemType.armor, armorType: ArmorType.chestplate),
    DropItem(chance: 15, itemType: ItemType.armor, armorType: ArmorType.leggings),
    DropItem(chance: 15, itemType: ItemType.armor, armorType: ArmorType.boots),
    DropItem(chance: 15, itemType: ItemType.weapon, weaponType: WeaponType.bow),
  ],
);

final dryad = Enemy(
  id: 'dryad',
  name: 'Dryad',
  image: "assets/icons/enemies/dryad.png",
  hp: 300,
  attack: 40.0,
  attackSpeed: 0.5,
  expReward: 100,
  spReward: 8,
  dropList: [
    DropItem(chance: 80, itemType: ItemType.gold, minQuantity: 40, maxQuantity: 50),
    DropItem(chance: 40, itemType: ItemType.scroll, scrollType: ScrollType.armor),
    DropItem(chance: 35, itemType: ItemType.scroll, scrollType: ScrollType.weapon),
    DropItem(chance: 30, itemType: ItemType.weapon, weaponType: WeaponType.bow),
    DropItem(chance: 30, itemType: ItemType.armor, armorType: ArmorType.helmet),
    DropItem(chance: 30, itemType: ItemType.armor, armorType: ArmorType.chestplate),
    DropItem(chance: 30, itemType: ItemType.armor, armorType: ArmorType.leggings),
    DropItem(chance: 30, itemType: ItemType.armor, armorType: ArmorType.boots),
    DropItem(chance: 25, itemType: ItemType.weapon, weaponType: WeaponType.sword),
    DropItem(chance: 25, itemType: ItemType.weapon, weaponType: WeaponType.dagger),
  ],
);
