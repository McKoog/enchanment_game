import 'package:enchantment_game/models/item.dart';

enum WeaponType { fist,sword, bow, dagger }

class Weapon extends Item {
  Weapon(
      {required super.id,
      required super.type,
      required super.image,
      super.isSvgAsset = true,
      required this.name,
      required this.weaponType,
      required this.lowerDamage,
      required this.higherDamage,
      required this.critRate,
      required this.critPower,
      required this.enchantLevel});

  String name;
  WeaponType weaponType;
  int lowerDamage;
  int higherDamage;
  int critRate;
  int critPower;
  int enchantLevel;

  static Weapon copyWith(Weapon weapon) {
    return Weapon(
        id: weapon.id,
        type: weapon.type,
        image: weapon.image,
        isSvgAsset: weapon.isSvgAsset,
        name: weapon.name,
        weaponType: weapon.weaponType,
        lowerDamage: weapon.lowerDamage,
        higherDamage: weapon.higherDamage,
        critRate: weapon.critRate,
        critPower: weapon.critPower,
        enchantLevel: weapon.enchantLevel);
  }
}
