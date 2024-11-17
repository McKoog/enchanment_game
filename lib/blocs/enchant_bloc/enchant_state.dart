import 'package:enchantment_game/models/weapon.dart';

sealed class EnchantState{
  EnchantState({this.insertedWeapon});

  final Weapon? insertedWeapon;
}

class EnchantState$Idle extends EnchantState{
  EnchantState$Idle({super.insertedWeapon});
}

class EnchantState$EnchantmentInProgress extends EnchantState{
  EnchantState$EnchantmentInProgress({super.insertedWeapon});
}

class EnchantState$Result extends EnchantState{
  EnchantState$Result({super.insertedWeapon, required this.isSuccess});

  final bool isSuccess;
}