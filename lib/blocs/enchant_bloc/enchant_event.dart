import 'package:enchantment_game/models/item.dart';

sealed class EnchantEvent {}

class EnchantEvent$InsertItem extends EnchantEvent {
  EnchantEvent$InsertItem({required this.item});

  final Item item;
}

class EnchantEvent$StartEnchanting extends EnchantEvent {
  EnchantEvent$StartEnchanting({required this.item});

  final Item item;
}

class EnchantEvent$FinishEnchanting extends EnchantEvent {
  EnchantEvent$FinishEnchanting({required this.item, required this.runToken});

  final Item item;
  final int runToken;
}

class EnchantEvent$CancelEnchanting extends EnchantEvent {}

class EnchantEvent$ExtractItem extends EnchantEvent {}
