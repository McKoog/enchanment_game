import 'package:enchantment_game/models/item.dart';

sealed class EnchantState {
  EnchantState({this.insertedItem});

  final Item? insertedItem;
}

class EnchantState$Idle extends EnchantState {
  EnchantState$Idle({super.insertedItem});
}

class EnchantState$EnchantmentInProgress extends EnchantState {
  EnchantState$EnchantmentInProgress({super.insertedItem});
}

class EnchantState$Result extends EnchantState {
  EnchantState$Result({super.insertedItem, required this.isSuccess});

  final bool isSuccess;
}
