import 'package:enchantment_game/models/item.dart';

sealed class ItemInfoEvent {}

class ItemInfoEvent$ShowInfo extends ItemInfoEvent {
  ItemInfoEvent$ShowInfo({required this.item});

  final Item item;
}

class ItemInfoEvent$CloseInfo extends ItemInfoEvent {}
