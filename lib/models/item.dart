enum ItemType{
  weapon,
  scroll
}

class Item{
  Item({required this.type,this.isSvgAsset = true,required this.image});
  ItemType type;
  bool isSvgAsset;
  String image;
}