import 'package:enchantment_game/models/item.dart';
import 'package:enchantment_game/models/rarity.dart';

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
      required this.enchantLevel,
      this.rarity = 0.0,
      this.rarityEffects = const []});

  String name;
  WeaponType weaponType;
  double lowerDamage;
  double higherDamage;
  int critRate;
  int critPower;
  double attackSpeed;
  int enchantLevel;
  double rarity;
  List<RarityEffect> rarityEffects;

  RarityTier get rarityTier {
    if (rarity < 20) return RarityTier.common;
    if (rarity < 40) return RarityTier.uncommon;
    if (rarity < 60) return RarityTier.rare;
    if (rarity < 80) return RarityTier.mythical;
    if (rarity < 98) return RarityTier.legendary;
    return RarityTier.godlike;
  }

  String get displayName {
    if (rarity > 0) {
      return '${rarityTier.displayName} $name';
    }
    return name;
  }

  @override
  int get sellPrice {
    double multiplier = 1.0;
    switch (rarityTier) {
      case RarityTier.common:
        multiplier = 1.0;
        break;
      case RarityTier.uncommon:
        multiplier = 1.25;
        break;
      case RarityTier.rare:
        multiplier = 3.0;
        break;
      case RarityTier.mythical:
        multiplier = 11.0;
        break;
      case RarityTier.legendary:
        multiplier = 51.0;
        break;
      case RarityTier.godlike:
        multiplier = 151.0;
        break;
    }
    return (baseSellPrice * multiplier).round();
  }

  @override
  Map toJson() => {
        'id': id,
        'type': type.name,
        'image': image,
        'sellPrice': baseSellPrice,
        'buyPrice': buyPrice,
        'name': name,
        'weaponType': weaponType.name,
        'lowerDamage': lowerDamage,
        'higherDamage': higherDamage,
        'critRate': critRate,
        'critPower': critPower,
        'attackSpeed': attackSpeed,
        'enchantLevel': enchantLevel,
        'rarity': rarity,
        'rarityEffects': rarityEffects.map((e) => e.name).toList()
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
      lowerDamage: json['lowerDamage']?.toDouble() ?? 0.0,
      higherDamage: json['higherDamage']?.toDouble() ?? 0.0,
      critRate: json['critRate'],
      critPower: json['critPower'],
      attackSpeed: json['attackSpeed']?.toDouble() ?? 1.0,
      enchantLevel: json['enchantLevel'],
      rarity: (json['rarity'] as num?)?.toDouble() ?? 0.0,
      rarityEffects: (json['rarityEffects'] as List<dynamic>?)
              ?.map((e) => RarityEffect.values.byName(e as String))
              .toList() ??
          [],
    );
  }

  static Weapon copyWith(Weapon weapon) {
    return Weapon(
        id: weapon.id,
        type: weapon.type,
        image: weapon.image,
        sellPrice: weapon.baseSellPrice,
        buyPrice: weapon.buyPrice,
        name: weapon.name,
        weaponType: weapon.weaponType,
        lowerDamage: weapon.lowerDamage,
        higherDamage: weapon.higherDamage,
        critRate: weapon.critRate,
        critPower: weapon.critPower,
        attackSpeed: weapon.attackSpeed,
        enchantLevel: weapon.enchantLevel,
        rarity: weapon.rarity,
        rarityEffects: List.from(weapon.rarityEffects));
  }

  @override
  String toString() {
    return "id: $id, type: $type, image $image, name: $name, weaponType: $weaponType, lowerDamage: $lowerDamage, higherDamage: $higherDamage, critRate: $critRate, critPower: $critPower, attackSpeed: $attackSpeed, enchantLevel: $enchantLevel, rarity: $rarity, rarityEffects: $rarityEffects";
  }
}
