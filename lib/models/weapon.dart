import 'package:enchantment_game/models/item.dart';

class Weapon extends Item{
  Weapon({required super.id,required super.type, required super.image,super.isSvgAsset = true,required this.name,required this.lowerDamage,required this.higherDamage,required this.enchantLevel});

  String name;
  int lowerDamage;
  int higherDamage;
  int enchantLevel;

  static Weapon copyWith(Weapon weapon){
    return Weapon(id: weapon.id, type: weapon.type, image: weapon.image, name: weapon.name, lowerDamage: weapon.lowerDamage, higherDamage: weapon.higherDamage, enchantLevel: weapon.enchantLevel);
  }

}