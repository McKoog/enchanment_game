import 'package:enchantment_game/models/drop_item.dart';

class Enemy {
  Enemy({
    required this.id,
    required this.name,
    required this.image,
    required this.hp,
    required this.dropList,
  });

  final String id;
  final String name;
  final String image;
  final int hp;
  final List<DropItem> dropList;
}
