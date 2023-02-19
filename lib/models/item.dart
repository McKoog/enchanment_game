enum ItemType{
  weapon,
  scroll
}

class Item{
  Item({required this.id,required this.type,this.isSvgAsset = true,required this.image});
  String id;
  ItemType type;
  bool isSvgAsset;
  String image;
}