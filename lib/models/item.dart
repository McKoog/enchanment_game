enum ItemType { weapon, scroll, armor }

class Item {
  Item(
      {required this.id,
      required this.type,
      this.isSvgAsset = true,
      required this.image});

  String id;
  ItemType type;
  bool isSvgAsset;
  String image;

  Map toJson() => {
        'id': id,
        'type': type.name,
        'isSvgAsset': isSvgAsset,
        'image': image,
      };

  factory Item.fromJson(Map<String, dynamic> json) {
    return Item(
      id: json['id'],
      type: ItemType.values.byName(json['type']),
      isSvgAsset: json['isSvgAsset'],
      image: json['image'],
    );
  }
}
