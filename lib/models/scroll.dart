import 'package:enchantment_game/models/item.dart';

class Scroll extends Item {
  Scroll(
      {required super.id,
      required super.type,
      required super.image,
      required this.name,
      required this.description,
      this.quantity = 1});

  static const int maxStackSize = 99;

  String name;
  String description;
  int quantity;

  @override
  Map toJson() => {
        'id': id,
        'type': type.name,
        'isSvgAsset': false,
        'image': image,
        'name': name,
        'description': description,
        'quantity': quantity,
      };

  factory Scroll.fromJson(Map<String, dynamic> json) {
    return Scroll(
      id: json['id'],
      type: ItemType.values.byName(json['type']),
      image: json['image'],
      name: json['name'],
      description: json['description'],
      quantity: json['quantity'] ?? 1,
    );
  }

  static Scroll copyWith(Scroll scroll) {
    return Scroll(
        id: scroll.id,
        type: scroll.type,
        image: scroll.image,
        name: scroll.name,
        description: scroll.description,
        quantity: scroll.quantity);
  }
}
