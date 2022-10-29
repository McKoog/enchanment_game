enum ItemType{
  weapon,
  scroll
}

class Item{
  Item({required this.type,required this.image});
  ItemType type;
  String image;
}