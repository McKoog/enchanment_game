import 'package:enchantment_game/models/item.dart';

class Weapon extends Item{
  Weapon({required super.type, required super.image,required this.name,required this.lowerDamage,required this.higherDamage,required this.enchantLevel});

  String name;
  int lowerDamage;
  int higherDamage;
  int enchantLevel;

}