import 'package:enchantment_game/models/item.dart';
import 'package:enchantment_game/models/rarity.dart';

enum ArmorType { helmet, chestplate, leggings, boots }

enum ArmorSetType { none, leather }

class Armor extends Item {
  Armor({
    required super.id,
    required super.type,
    required super.image,
    super.sellPrice,
    super.buyPrice,
    required this.name,
    required this.armorType,
    required this.defense,
    required this.enchantLevel,
    this.setType = ArmorSetType.none,
    this.rarity = 0.0,
    this.rarityEffects = const [],
  });

  String name;
  ArmorType armorType;
  int defense;
  int enchantLevel;
  ArmorSetType setType;
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

  Armor.copyWith(Armor other)
      : name = other.name,
        armorType = other.armorType,
        defense = other.defense,
        enchantLevel = other.enchantLevel,
        setType = other.setType,
        rarity = other.rarity,
        rarityEffects = List.from(other.rarityEffects),
        super(
          id: other.id,
          type: other.type,
          image: other.image,
          sellPrice: other.baseSellPrice,
          buyPrice: other.buyPrice,
        );

  @override
  Map toJson() {
    final json = super.toJson();
    json.addAll({
      'name': name,
      'armorType': armorType.name,
      'defense': defense,
      'enchantLevel': enchantLevel,
      'setType': setType.name,
      'rarity': rarity,
      'rarityEffects': rarityEffects.map((e) => e.name).toList(),
    });
    return json;
  }

  factory Armor.fromJson(Map<String, dynamic> json) {
    return Armor(
      id: json['id'],
      type: ItemType.values.byName(json['type']),
      image: json['image'],
      sellPrice: json['sellPrice'] ?? 0,
      buyPrice: json['buyPrice'] ?? 0,
      name: json['name'],
      armorType: ArmorType.values.byName(json['armorType']),
      defense: json['defense'],
      enchantLevel: json['enchantLevel'],
      setType: json['setType'] != null
          ? ArmorSetType.values.byName(json['setType'])
          : ArmorSetType.none,
      rarity: (json['rarity'] as num?)?.toDouble() ?? 0.0,
      rarityEffects: (json['rarityEffects'] as List<dynamic>?)
              ?.map((e) => RarityEffect.values.byName(e as String))
              .toList() ??
          [],
    );
  }
}
