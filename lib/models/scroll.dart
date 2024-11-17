import 'package:enchantment_game/models/item.dart';

class Scroll extends Item {
  Scroll(
      {required super.id,
      required super.type,
      required super.image,
      required this.name,
      required this.description});

  String name;
  String description;

  @override
  Map toJson() => {
        'id': id,
        'type': type.name,
        'isSvgAsset': false,
        'image': image,
        'name': name,
        'description': description,
      };

  factory Scroll.fromJson(Map<String, dynamic> json) {
    ItemType? type;
    String jsonType = json["type"];
    if (jsonType == "weapon") {
      type = ItemType.weapon;
    } else {
      type = ItemType.scroll;
    }

    return Scroll(
      id: json['id'],
      type: type,
      image: json['image'],
      name: json['name'],
      description: json['description'],
    );
  }

  static Scroll copyWith(Scroll scroll) {
    return Scroll(
        id: scroll.id,
        type: scroll.type,
        image: scroll.image,
        name: scroll.name,
        description: scroll.description);
  }
}
