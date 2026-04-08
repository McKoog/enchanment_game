enum ItemType { weapon, scroll, armor }

class Item {
  Item({required this.id, required this.type, required this.image});

  String id;
  ItemType type;
  String image;

  Map toJson() => {
        'id': id,
        'type': type.name,
        'image': image,
      };

  factory Item.fromJson(Map<String, dynamic> json) {
    return Item(
      id: json['id'],
      type: ItemType.values.byName(json['type']),
      image: json['image'],
    );
  }
}
