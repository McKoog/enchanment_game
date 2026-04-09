import 'package:enchantment_game/models/item.dart';

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
  });

  String name;
  ArmorType armorType;
  int defense;
  int enchantLevel;
  ArmorSetType setType;

  Armor.copyWith(Armor other)
      : name = other.name,
        armorType = other.armorType,
        defense = other.defense,
        enchantLevel = other.enchantLevel,
        setType = other.setType,
        super(
          id: other.id,
          type: other.type,
          image: other.image,
          sellPrice: other.sellPrice,
          buyPrice: other.buyPrice,
        );

  @override
  Map toJson() => {
        'id': id,
        'type': type.name,
        'image': image,
        'sellPrice': sellPrice,
        'buyPrice': buyPrice,
        'name': name,
        'armorType': armorType.name,
        'defense': defense,
        'enchantLevel': enchantLevel,
        'setType': setType.name,
      };

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
      setType: json['setType'] != null ? ArmorSetType.values.byName(json['setType']) : ArmorSetType.none,
    );
  }
}
