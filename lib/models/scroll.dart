import 'package:enchantment_game/models/item.dart';

class Scroll extends Item{
  Scroll({required super.id,required super.type, required super.image,required this.name, required this.description});
  String name;
  String description;

  static Scroll copyWith(Scroll scroll){
    return Scroll(id: scroll.id, type: scroll.type, image: scroll.image, name: scroll.name, description: scroll.description);
  }
}