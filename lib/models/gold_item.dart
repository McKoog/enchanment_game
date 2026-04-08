import 'package:enchantment_game/models/item.dart';

class GoldItem extends Item {
  GoldItem({
    required super.id,
    required super.type,
    required super.image,
    super.sellPrice,
    super.buyPrice,
    required this.amount,
  });

  final int amount;

  @override
  Map<String, dynamic> toJson() => {
        ...super.toJson(),
        'amount': amount,
      };

  factory GoldItem.fromJson(Map<String, dynamic> json) {
    return GoldItem(
      id: json['id'],
      type: ItemType.gold,
      image: json['image'],
      sellPrice: json['sellPrice'] ?? 0,
      buyPrice: json['buyPrice'] ?? 0,
      amount: json['amount'],
    );
  }
}
