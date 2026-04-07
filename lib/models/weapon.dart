import 'package:enchantment_game/models/item.dart';

enum WeaponType { fist, sword, bow, dagger }

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

  @override
  Map toJson() => {
        'id': id,
        'type': type.name,
        'isSvgAsset': isSvgAsset,
        'image': image,
        'name': name,
        'weaponType': weaponType.name,
        'lowerDamage': lowerDamage,
        'higherDamage': higherDamage,
        'critRate': critRate,
        'critPower': critPower,
        'enchantLevel': enchantLevel
      };

  factory Weapon.fromJson(Map<String, dynamic> json) {
    return Weapon(
      id: json['id'],
      type: ItemType.values.byName(json['type']),
      isSvgAsset: json['isSvgAsset'],
      image: json['image'],
      name: json['name'],
      weaponType: WeaponType.values.byName(json['weaponType']),
      lowerDamage: json['lowerDamage'],
      higherDamage: json['higherDamage'],
      critRate: json['critRate'],
      critPower: json['critPower'],
      enchantLevel: json['enchantLevel'],
    );
  }

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

  @override
  String toString() {
    return "id: $id, type: $type, image $image, isSvgAsset: $isSvgAsset, name: $name, weaponType: $weaponType, lowerDamage: $lowerDamage, higherDamage: $higherDamage, critRate: $critRate, critPower: $critPower, enchantLevel: $enchantLevel";
  }
}
