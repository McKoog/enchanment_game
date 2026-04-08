import 'package:enchantment_game/models/drop_item.dart';
import 'package:enchantment_game/models/enemy.dart';
import 'package:enchantment_game/models/item.dart';
import 'package:enchantment_game/models/weapon.dart';

final stockWerewolf = Enemy(id: 'werewolf', name: 'Werewolf', image: "assets/icons/enemies/lvl_1_werewolf.png", hp: 200, dropList: [
  DropItem(chance: 5, itemType: ItemType.weapon, weaponType: WeaponType.sword),
  DropItem(chance: 50, itemType: ItemType.scroll),
  DropItem(chance: 5, itemType: ItemType.weapon, weaponType: WeaponType.dagger),
  DropItem(chance: 5, itemType: ItemType.weapon, weaponType: WeaponType.bow),
]);
