import 'package:enchantment_game/models/item.dart';

enum ArmorType { helmet, chestplate, leggings, boots }

class Armor extends Item {
  Armor({
    required super.id,
    required super.type,
    required super.image,
    required this.name,
    required this.armorType,
    required this.defense,
    required this.enchantLevel,
  });

  String name;
  ArmorType armorType;
  int defense;
  int enchantLevel;

  Armor.copyWith(Armor other)
      : name = other.name,
        armorType = other.armorType,
        defense = other.defense,
        enchantLevel = other.enchantLevel,
        super(
          id: other.id,
          type: other.type,
          image: other.image,
        );

  @override
  Map toJson() => {
        'id': id,
        'type': type.name,
        'image': image,
        'name': name,
        'armorType': armorType.name,
        'defense': defense,
        'enchantLevel': enchantLevel,
      };

  factory Armor.fromJson(Map<String, dynamic> json) {
    return Armor(
      id: json['id'],
      type: ItemType.values.byName(json['type']),
      image: json['image'],
      name: json['name'],
      armorType: ArmorType.values.byName(json['armorType']),
      defense: json['defense'],
      enchantLevel: json['enchantLevel'],
    );
  }
}
