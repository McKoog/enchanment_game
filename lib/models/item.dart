enum ItemType { weapon, scroll }

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

  checkItemType(String type) {
    switch (type) {
      case "weapon":
        return ItemType.weapon;
      case "scroll":
        return ItemType.scroll;
    }
  }

  factory Item.fromJson(Map<String, dynamic> json) {
    ItemType? type;
    String jsonType = json["type"];
    if (jsonType == "weapon") {
      type = ItemType.weapon;
    } else {
      type = ItemType.scroll;
    }

    return Item(
      id: json['id'],
      type: type,
      isSvgAsset: json['isSvgAsset'],
      image: json['image'],
    );
  }
}
