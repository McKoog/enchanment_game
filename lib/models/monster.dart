import 'package:enchantment_game/models/dropItem.dart';

class Monster{
  Monster({required this.name,required this.image,required this.hp, required this.dropList});
  String name;
  String image;
  List<DropItem> dropList;
  int hp;
}