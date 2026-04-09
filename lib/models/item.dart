enum ItemType { weapon, scroll, armor, gold }

class Item {
  Item(
      {required this.id,
      required this.type,
      required this.image,
      int sellPrice = 0,
      this.buyPrice = 0})
      : baseSellPrice = sellPrice;

  String id;
  ItemType type;
  String image;
  int baseSellPrice;
  int buyPrice;

  int get sellPrice => baseSellPrice;
  set sellPrice(int value) => baseSellPrice = value;

  Map toJson() => {
        'id': id,
        'type': type.name,
        'image': image,
        'sellPrice': baseSellPrice,
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
