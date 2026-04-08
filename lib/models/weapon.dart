import 'package:enchantment_game/models/item.dart';

enum WeaponType { fist, sword, bow, dagger }

class Weapon extends Item {
  Weapon(
      {required super.id,
      required super.type,
      required super.image,
      super.sellPrice,
      super.buyPrice,
      required this.name,
      required this.weaponType,
      required this.lowerDamage,
      required this.higherDamage,
      required this.critRate,
      required this.critPower,
      required this.attackSpeed,
      required this.enchantLevel});

  String name;
  WeaponType weaponType;
  int lowerDamage;
  int higherDamage;
  int critRate;
  int critPower;
  double attackSpeed;
  int enchantLevel;

  @override
  Map toJson() => {
        'id': id,
        'type': type.name,
        'image': image,
        'sellPrice': sellPrice,
        'buyPrice': buyPrice,
        'name': name,
        'weaponType': weaponType.name,
        'lowerDamage': lowerDamage,
        'higherDamage': higherDamage,
        'critRate': critRate,
        'critPower': critPower,
        'attackSpeed': attackSpeed,
        'enchantLevel': enchantLevel
      };

  factory Weapon.fromJson(Map<String, dynamic> json) {
    return Weapon(
      id: json['id'],
      type: ItemType.values.byName(json['type']),
      image: json['image'],
      sellPrice: json['sellPrice'] ?? 0,
      buyPrice: json['buyPrice'] ?? 0,
      name: json['name'],
      weaponType: WeaponType.values.byName(json['weaponType']),
      lowerDamage: json['lowerDamage'],
      higherDamage: json['higherDamage'],
      critRate: json['critRate'],
      critPower: json['critPower'],
      attackSpeed: json['attackSpeed']?.toDouble() ?? 1.0,
      enchantLevel: json['enchantLevel'],
    );
  }

  static Weapon copyWith(Weapon weapon) {
    return Weapon(
        id: weapon.id,
        type: weapon.type,
        image: weapon.image,
        sellPrice: weapon.sellPrice,
        buyPrice: weapon.buyPrice,
        name: weapon.name,
        weaponType: weapon.weaponType,
        lowerDamage: weapon.lowerDamage,
        higherDamage: weapon.higherDamage,
        critRate: weapon.critRate,
        critPower: weapon.critPower,
        attackSpeed: weapon.attackSpeed,
        enchantLevel: weapon.enchantLevel);
  }

  @override
  String toString() {
    return "id: $id, type: $type, image $image, name: $name, weaponType: $weaponType, lowerDamage: $lowerDamage, higherDamage: $higherDamage, critRate: $critRate, critPower: $critPower, attackSpeed: $attackSpeed, enchantLevel: $enchantLevel";
  }
}
