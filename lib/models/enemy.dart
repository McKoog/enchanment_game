import 'package:enchantment_game/models/drop_item.dart';

class Enemy {
  Enemy(
      {required this.name,
      required this.image,
      required this.hp,
      required this.dropList});

  String name;
  String image;
  List<DropItem> dropList;
  int hp;
}
