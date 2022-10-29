import 'package:enchantment_game/models/item.dart';

class Scroll extends Item{
  Scroll({required super.type, required super.image,required this.name, required this.description});

  String name;
  String description;
}