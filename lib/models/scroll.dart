import 'package:enchantment_game/models/item.dart';

enum ScrollType { weapon, armor }

class Scroll extends Item {
  Scroll(
      {required super.id,
      required super.type,
      required super.image,
      required this.name,
      required this.description,
      required this.scrollType,
      this.quantity = 1});

  static const int maxStackSize = 99;

  String name;
  String description;
  ScrollType scrollType;
  int quantity;

  @override
  Map toJson() => {
        'id': id,
        'type': type.name,
        'image': image,
        'name': name,
        'description': description,
        'scrollType': scrollType.name,
        'quantity': quantity,
      };

  factory Scroll.fromJson(Map<String, dynamic> json) {
    return Scroll(
      id: json['id'],
      type: ItemType.values.byName(json['type']),
      image: json['image'],
      name: json['name'],
      description: json['description'],
      scrollType: json['scrollType'] != null
          ? ScrollType.values.byName(json['scrollType'])
          : ScrollType.weapon,
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
        scrollType: scroll.scrollType,
        quantity: scroll.quantity);
  }
}
