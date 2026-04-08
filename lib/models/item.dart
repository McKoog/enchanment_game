enum ItemType { weapon, scroll, armor, gold }

class Item {
  Item(
      {required this.id,
      required this.type,
      required this.image,
      this.sellPrice = 0,
      this.buyPrice = 0});

  String id;
  ItemType type;
  String image;
  int sellPrice;
  int buyPrice;

  Map toJson() => {
        'id': id,
        'type': type.name,
        'image': image,
        'sellPrice': sellPrice,
        'buyPrice': buyPrice,
      };

  factory Item.fromJson(Map<String, dynamic> json) {
    return Item(
      id: json['id'],
      type: ItemType.values.byName(json['type']),
      image: json['image'],
      sellPrice: json['sellPrice'] ?? 0,
      buyPrice: json['buyPrice'] ?? 0,
    );
  }
}
